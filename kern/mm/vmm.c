#include "basic_p.h"
#include "lock_p.h"
#include "mmu.h"
#include "memlayout.h"
#include "pmm.h"
#include "string.h"
#include "stdio.h"
#include "kdebug.h"
#include "cpu.h"
#include "lapic.h"
#include "x86.h"
#include "swap.h"

extern char data[];  // defined by kernel.ld

struct mm_struct *check_mm_struct;
static struct kmap {
    uintptr_t virt;
    uintptr_t phys_start;
    uintptr_t phys_end;
    int32_t perm;
} kmap[] = {
    { KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
    { KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
    { (uintptr_t)data,     V2P(data),     0,   PTE_W}, // kern data+memory
    { DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

pte_t *kpgdir;

static inline struct page *
pte2page(pte_t pte) {
    if (!(pte & PTE_P)) {
        panic("pte2page called with invalid pte");
    }
    return pa2page((pte) & ~0xFFF);
}


static inline struct page *
pde2page(pte_t pte) {
    if (!(pte & PTE_P)) {
        panic("pte2page called with invalid pte");
    }
    return pa2page((pte) & ~0xFFF);
}


/**************************************PAGE***********************************/

pte_t*
read_pte_addr(pde_t *pgdir, uintptr_t va, int32_t alloc)
{
    pde_t* pde = &pgdir[PDX(va)];
    pte_t* pte; 
    if(*pde & PTE_P)
    {
       pte = (pte_t*)P2V_WO(PTE_ADDR(*pde)); 
    }else{
       if(!alloc || (pte = (pte_t*)alloc_pages(1)) == NULL)
            return NULL;
       //make sure PTE_P bits are zero.
       memset(pte, 0 ,PGSIZE);
       assert(((uint32_t)pte & 0x3ff) == 0);
       //PTE_U maybe dangerous,but it is very convenient to create user's page table(just copy it).
       *pde = PTE_ADDR(V2P(pte)) | PTE_P | PTE_W | PTE_U ;   
    }
    return &pte[PTX(va)];
}

//sub fuction for page_remove
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
    if (*ptep & PTE_P) {
        struct page *page = pte2page(*ptep);
        free_page(page);
        *ptep = 0;
        tlb_invalidate(pgdir, la);
    }
}

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
    pte_t *ptep = read_pte_addr(pgdir, la, 0);
    if (ptep != NULL) {
        page_remove_pte(pgdir, la, ptep);
    }
}

//insert page with page and perm in la
int
page_insert(pde_t *pgdir, struct page *page, uintptr_t la, uint32_t perm) {
    pte_t *ptep = read_pte_addr(pgdir, la, 1);
    if (ptep == NULL) {
        return -1;
    }
//    page_ref_inc(page);
    if (*ptep & PTE_P) {
        struct page *p = pte2page(*ptep);
        if (p == page) {
 //           page_ref_dec(page);
           ;
        }
        else {
            page_remove_pte(pgdir, la, ptep);
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
    tlb_invalidate(pgdir, la);
    return 0;
}

struct page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
    struct page *page = alloc_page();
    if (page != NULL) {
        if (page_insert(pgdir, page, la, perm) != 0) {
            free_page(page);
            return NULL;
        }
        
        if (swap_init_ok){
            page->pra_vaddr=la;
            page->pgdir = pgdir;
            swap_map_swappable(check_mm_struct, la, page, 0);
        }

    }

    return page;
}




static int
map_pages(pde_t *pgdir, uintptr_t va_st, uintptr_t size, uintptr_t pa, int32_t perm)
{
    uintptr_t va_i = PGROUNDDOWN(va_st);
    uintptr_t va_ed;
    pte_t* pte;
    size = PGROUNDUP(size);           
    pa = PGROUNDDOWN(pa);
    va_ed = va_st + size;
    for( ;  ; )
    {
        if((pte = read_pte_addr(pgdir, va_i, 1)) == NULL)
        {
            return -1;
        }
        assert(!(*pte & PTE_P));
        *pte = pa | perm | PTE_P;
        va_i += PGSIZE, pa += PGSIZE;
        if(va_i == va_ed) break;
    }
    return 0;
}



pde_t* 
setup_kvm(void)
{
    pde_t *pgdir;
    struct kmap *k;

    if((pgdir = (pde_t*)alloc_pages(1)) == NULL)
        return NULL;
    memset(pgdir, 0, PGSIZE);
    kmap[2].phys_end = pmm_info.end;
    assert(P2V_WO(pmm_info.end) < DEVSPACE);
    for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    {
        if(map_pages(pgdir, k->virt, k->phys_end - k->phys_start,
                    (uintptr_t)k->phys_start, k->perm) < 0)
            return NULL;
    }
    return pgdir;
}

int 
kvm_print(pde_t* pgdir)
{
    int32_t i = 0,j = 0;
    int32_t perm;
    uintptr_t start;
    uint32_t size,first;
    pte_t *pte;
    pde_t *pde;
    cprintf("-------------------- BEGIN --------------------\n");
    for(i = 0,first = 0,size = 0 ; i < (PGSIZE / sizeof(uintptr_t)); i ++)
    {
        pde = &pgdir[i]; 
        if(*pde & PTE_P)
        {

            pte = (pte_t*)P2V_WO(PTE_ADDR(*pde)); 

            for(j = 0 ; j < (PGSIZE / sizeof(uintptr_t)) ;j ++) 
            {
                if(pte[j] & PTE_P)
                {
                    if(first == 0 || (first == 1 && (PTE_FLAGS(pte[j]) != perm) ))
                    {
                        if(size != 0)
                        {
                            cprintf("start : %8x, size : %8x ,perm : %8x\n",start , size, perm);
                        }
                        perm = PTE_FLAGS(pte[j]);
                        first = 1;
                        size = 0;
                        start = PTE_ADDR(pte[j]);
                    }
                    size += PGSIZE;
                }else{
                    if(size != 0)
                    {
                        cprintf("start : %8x, size : %8x ,perm : %8x\n",start , size, perm);
                        size = 0;
                    }
                    first = 0;
                }
                    
            }

        }else{
            if(size != 0)
            {
                cprintf("start : %8x, size : %8x ,perm : %8x\n",start , size, perm);
                size = 0;
            }
            first = 0;
        }


    }
    if(size != 0)
    {
        cprintf("start : %8x, size : %8x ,perm : %8x\n",start , size, perm);
        size = 0;
    }
    cprintf("--------------------- END ---------------------\n");
    return 1;
}


void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}


void 
load_tss(struct proc *p)
{
    if(p == 0)
        panic("switchuvm: no process");
    if(p->kstack == 0)
        panic("switchuvm: no kstack");
    if(p->pgdir == 0)
        panic("switchuvm: no pgdir");
    assert(!IS_KERN_PROC(p));
    push_cli();
    struct cpu *cpu = PCPU;
    cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts), 0);
    cpu->gdt[SEG_TSS].s = 0;
    cpu->ts.ss0 = SEG_KDATA << 3;
    cpu->ts.esp0 = (uintptr_t)p->kstack + KSTACKSIZES;
    // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
    // forbids I/O instructions (e.g., inb and outb) from user space
    cpu->ts.iomb = (ushort) 0xFFFF;
    ltr(SEG_TSS << 3);
    pop_cli();
}
void 
switchuvm(struct proc *p)
{
    if(p == 0)
        panic("switchuvm: no process");
    if(p->kstack == 0)
        panic("switchuvm: no kstack");
    if(p->pgdir == 0)
        panic("switchuvm: no pgdir");
    if(p->mm == 0)
        panic("switchuvm: no mm\n");

    push_cli();
    struct cpu *cpu = PCPU;
    cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts), 0);
    cpu->gdt[SEG_TSS].s = 0;
    cpu->ts.ss0 = SEG_KDATA << 3;
    cpu->ts.esp0 = (uintptr_t)p->kstack + KSTACKSIZES;
    // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
    // forbids I/O instructions (e.g., inb and outb) from user space
    cpu->ts.iomb = (ushort) 0xFFFF;
    ltr(SEG_TSS << 3);

    
    lcr3(V2P(p->mm->pgdir));  // switch to process's address space
    pop_cli();
}

int32_t 
init_kvm(void)
{
    kpgdir = setup_kvm();
    if(kpgdir == NULL) return 1;
    kvm_print(kpgdir);
    switchkvm();
    return -1;
}


void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[get_cpu()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);


  lgdt(c->gdt, sizeof(c->gdt) );
}



/*************************************************************************************/


/**************************************VMA&MM********************************************/

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));

    if (vma != NULL) {
        vma->vm_start = vm_start;
        vma->vm_end = vm_end;
        vma->vm_flags = vm_flags;
    }
    return vma;
}

// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
    struct vma_struct *vma = NULL;
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
                    vma = le2vma(le, list_link);
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
                    vma = NULL;
                }
        }
        if (vma != NULL) {
            mm->mmap_cache = vma;
        }
    }
    return vma;
}


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
}

// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

    list_entry_t *le = list;
    while ((le = list_next(le)) != list) {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start) {
            break;
        }
        le_prev = le;
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list) {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
    }
    if (le_next != list) {
        check_vma_overlap(vma, le2vma(le_next, list_link));
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count ++;
}


/************************************MM*****************************************/
// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {

    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
    if (mm != NULL) {
        list_init(&(mm->mmap_list));
        mm->mmap_cache = NULL;
        mm->pgdir = NULL;
        mm->map_count = 0;
        set_mm_count(mm, 0);
        if (swap_init_ok) swap_init_mm(mm);
        else mm->sm_priv = NULL;
    }
    return mm;
}

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
    mm=NULL;
}
bool
mm_setup_pgdir(struct mm_struct *mm){
    assert(mm != NULL);
    pde_t *pgdir;
    if((pgdir = kmalloc(PGSIZE)) == NULL)
    {
        return false;
    }
    memcpy(pgdir, kpgdir, PGSIZE);
    mm->pgdir = pgdir;
    return true;
}

// mm_copy - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
int
mm_copy(uint32_t clone_flags, struct proc *proc) {
    struct mm_struct *mm, *oldmm = CUR_PROC->mm;

    /* current is a kernel thread */
    if (oldmm == NULL) {
        return 0;
    }

    if (!(clone_flags & CLONE_VM)) {
        mm = oldmm;
        goto good_mm;
    }

    panic("now no support copy mm\n");
#if 0
    int ret = -E_NO_MEM;
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }
    if (setup_pgdir(mm) != 0) {
        goto bad_pgdir_cleanup_mm;
    }

    lock_mm(oldmm);
    {
        ret = dup_mmap(mm, oldmm);
    }
    unlock_mm(oldmm);

    if (ret != 0) {
        goto bad_dup_cleanup_mmap;
    }

#endif
good_mm:
    mm_count_inc(mm);
    proc->mm = mm;
    proc->cr3 = V2P(mm->pgdir);
    return 0;
#if 0
bad_dup_cleanup_mmap:
    exit_mmap(mm);
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    return ret;
#endif
}


#if 0
static int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
    assert(to != NULL && from != NULL);
    list_entry_t *list = &(from->mmap_list), *le = list;
    while ((le = list_prev(le)) != list) {
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
        if (nvma == NULL) {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
            return -E_NO_MEM;
        }
    }
    return 0;
}

/* copy_range - copy content of memory (start, end) of one process A to another process B
 * @to:    the addr of process B's Page Directory
 * @from:  the addr of process A's Page Directory
 * @share: flags to indicate to dup OR share. We just use dup method, so it didn't be used.
 *
 * CALL GRAPH: copy_mm-->dup_mmap-->copy_range
 */
int
copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end, bool share) {
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
    assert(USER_ACCESS(start, end));
    do {
        pte_t *ptep = get_pte(from, start, 0), *nptep;
        if (ptep == NULL) {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
            continue ;
        }
        if (*ptep & PTE_P) {
            if ((nptep = get_pte(to, start, 1)) == NULL) {
                return -E_NO_MEM;
            }
        uint32_t perm = (*ptep & PTE_USER);
        //get page from ptep
        struct Page *page = pte2page(*ptep);
        // alloc a page for process B
        struct Page *npage=alloc_page();
        assert(page!=NULL);
        assert(npage!=NULL);
        int ret=0;

        void * kva_src = page2kva(page);
        void * kva_dst = page2kva(npage);
    
        memcpy(kva_dst, kva_src, PGSIZE);

        ret = page_insert(to, npage, start, perm);
        assert(ret == 0);
        }
        start += PGSIZE;
    } while (start != 0 && start < end);
    return 0;
}

#endif

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
    if (!USER_ACCESS(start, end)) {
        return -E_INVAL;
    }

    assert(mm != NULL);

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
        goto out;
    }
    ret = -E_NO_MEM;

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
        goto out;
    }
    insert_vma_struct(mm, vma);
    if (vma_store != NULL) {
        *vma_store = vma;
    }
    ret = 0;
out:
    return ret;
}


void
exit_mmap(struct mm_struct *mm) {
    assert(mm != NULL && mm_count(mm) == 0);
    pde_t *pgdir = mm->pgdir;
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
    }
}

void
put_pgdir(struct mm_struct *mm) {
    free_page(kva2page(mm->pgdir));
}

void
put_kstack(struct proc *proc){
    kfree((proc->kstack));
}


void
vmm_init(void) {
    init_kvm();
    seginit();
    cprintf(INITOK"init vmm ok!\n");
}

#define PTSIZE 4096*1024
void
unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
    assert(USER_ACCESS(start, end));

    do {
        pte_t *ptep = read_pte_addr(pgdir, start, 0);
        if (ptep == NULL) {
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
            continue ;
        }
        if (*ptep != 0) {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
    } while (start != 0 && start < end);
}

void
exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
    assert(USER_ACCESS(start, end));

    start = ROUNDDOWN(start, PTSIZE);
    do {
        int pde_idx = PDX(start);
        if (pgdir[pde_idx] & PTE_P) {
            free_page(pde2page(pgdir[pde_idx]));
            pgdir[pde_idx] = 0;
        }
        start += PTSIZE;
    } while (start != 0 && start < end);
}


#if 0
static void
check_vma_struct(void);
static void
check_pgfault(void);
#endif



// check_vmm - check correctness of vmm
void
check_vmm(void) {
#if 0
    swap_init();
    size_t nr_free_pages_store = nr_free_pages();
    check_vma_struct();
    check_pgfault();

    assert(nr_free_pages_store == nr_free_pages());

    cprintf("check_vmm() succeeded.\n");
#endif
}

#if 0

//check vmm and mm structure
static void
check_vma_struct(void) {
    size_t nr_free_pages_store = nr_free_pages();

    struct mm_struct *mm = mm_create();
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
        assert(le != &(mm->mmap_list));
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }


    for (i = 5; i <= 5 * step2; i +=5) {
        struct vma_struct *vma1 = find_vma(mm, i);
        assert(vma1 != NULL);
        struct vma_struct *vma2 = find_vma(mm, i+1);
        assert(vma2 != NULL);
        struct vma_struct *vma3 = find_vma(mm, i+2);
        assert(vma3 == NULL);
        struct vma_struct *vma4 = find_vma(mm, i+3);
        assert(vma4 == NULL);
        struct vma_struct *vma5 = find_vma(mm, i+4);
        assert(vma5 == NULL);

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
        struct vma_struct *vma_below_5= find_vma(mm,i);
        if (vma_below_5 != NULL ) {
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end);
        }
        assert(vma_below_5 == NULL);
    }
    mm_destroy(mm);

    assert(nr_free_pages_store == nr_free_pages());

    cprintf("check_vma_struct() succeeded!\n");
}

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
    size_t nr_free_pages_store = nr_free_pages();

    check_mm_struct = mm_create();
    assert(check_mm_struct != NULL);

    struct mm_struct *mm = check_mm_struct;
    pde_t *pgdir = mm->pgdir = kpgdir;
    assert(pgdir[0] == 0);

    struct vma_struct *vma = vma_create(0, PGSIZE * 1024, VM_WRITE | VM_READ );
    assert(vma != NULL);

    insert_vma_struct(mm, vma);

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    // test1
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));

    //test2
    pte_t* tmp = read_pte_addr(pgdir,0,0);
    *tmp = 0 << 8 | 4;
    tlb_invalidate(kpgdir,0x100);

    tmp = read_pte_addr(pgdir,0,0);
    assert(*(int*)(0x100) == SWAP_MAGIC_NUM );

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
    free_page(pde2page(pgdir[0]));
    pgdir[0] = 0;

    mm->pgdir = NULL;
    mm_destroy(mm);
    check_mm_struct = NULL;

    assert(nr_free_pages_store == nr_free_pages());

    cprintf("check_pgfault() succeeded!\n");
}
#endif
volatile unsigned int pgfault_num=0;

//page fault fuction
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
    int ret = -1;
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);

    pgfault_num++;
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
        goto failed;
    }
    //check the error_code
    switch (error_code & 3) {
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
        goto failed;
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
            goto failed;
        }
    }
    /* IF (write an existed addr ) OR
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
        perm |= PTE_W;
    }
    addr = ROUNDDOWN(addr, PGSIZE);

    ret = -1;

    pte_t *ptep=NULL;
    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (notice the 3th parameter '1')
    if ((ptep = read_pte_addr(mm->pgdir, addr, 1)) == NULL) {
        cprintf("get_pte in do_pgfault failed\n");
        goto failed;
    }
    if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
            goto failed;
        }
    }
    else { // if this pte is a swap entry, then load data from disk to a page with phy addr
           // and call page_insert to map the phy addr with logical addr
        if(swap_init_ok) {
            struct page *page=NULL;
            if ((ret = swap_in(mm, addr, &page)) == false) {
                cprintf("swap_in in do_pgfault failed\n");
                goto failed;
            }
            page_insert(mm->pgdir, page, addr, perm);
            swap_map_swappable(mm, addr, page, 1);
            page->pra_vaddr = addr;
            page->pgdir = mm->pgdir;
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
   ret = 0;
failed:
    return ret;
}

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write){
    if(mm != NULL){
        if(!USER_ACCESS(addr, addr + len)){
            return false;
        }

        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
        while(start < end){
            if((vma = find_vma(mm, start)) == NULL || start < vma->vm_start){
                return 0;
            }

            if(!(vma->vm_flags & ((write ? VM_WRITE : VM_READ)))){
                return 0;
            }

            if(write && (vma->vm_flags & VM_STACK)){
                panic("VM_STACK test maybe wrong");
                if(start < vma->vm_start + PGSIZE){
                    return 0;
                } 
            }

            start = vma->vm_end;

        }
        return 1;
    }
    return 1;
}



