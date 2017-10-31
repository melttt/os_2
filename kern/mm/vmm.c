#include "defs.h"
#include "mmu.h"
#include "memlayout.h"
#include "pmm.h"
#include "string.h"
#include "stdio.h"
#include "kdebug.h"
#include "mp.h"
#include "lapic.h"
#include "x86.h"
#include "swap.h"

extern char data[];  // defined by kernel.ld
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

//
static pte_t*
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
kvm_test(pde_t* pgdir)
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
        if(*pde & PTE_P )
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

static inline void
lcr3(uint32_t val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
}

void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}

int32_t 
init_kvm(void)
{
    kpgdir = setup_kvm();
    if(kpgdir == NULL) return 1;
    kvm_test(kpgdir);
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
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
//  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
//  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
//  c->gdt[SEG_KCPU] = SEG(1, 0xffffffff, 0, DPL_USER);
  ///c->gdt[SEG_KCPU].p = 0;

  lgdt(c->gdt, sizeof(c->gdt) );
//  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
//  cpu = c;
//  proc = 0;
}



/*************************************************************************************/


/**************************************VMA********************************************/
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

        if (swap_init_ok) /*swap_init_mm(mm)*/;
        else mm->sm_priv = NULL;
    }
    return mm;
}

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
    mm=NULL;
}

static void
check_vma_struct(void);
static void
check_vmm(void);

void
vmm_init(void) {
    init_kvm();
    seginit();


    //should after ide_init()
    check_vmm();
}
// check_vmm - check correctness of vmm
static void
check_vmm(void) {
    size_t nr_free_pages_store = nr_free_pages();
    check_vma_struct();
    //check_pgfault();

    assert(nr_free_pages_store == nr_free_pages());

    cprintf("check_vmm() succeeded.\n");
}



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

/*
// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
    size_t nr_free_pages_store = nr_free_pages();

    check_mm_struct = mm_create();
    assert(check_mm_struct != NULL);

    struct mm_struct *mm = check_mm_struct;
    pde_t *pgdir = mm->pgdir = boot_pgdir;
    assert(pgdir[0] == 0);

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
    assert(vma != NULL);

    insert_vma_struct(mm, vma);

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

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
    free_page(pde2page(pgdir[0]));
    pgdir[0] = 0;

    mm->pgdir = NULL;
    mm_destroy(mm);
    check_mm_struct = NULL;

    assert(nr_free_pages_store == nr_free_pages());

    cprintf("check_pgfault() succeeded!\n");
}
*/
