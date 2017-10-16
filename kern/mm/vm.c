#include "defs.h"
#include "mmu.h"
#include "memlayout.h"
#include "pmm.h"
#include "string.h"
#include "stdio.h"
#include "kdebug.h"

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
    //lcr3(V2P(kpgdir));
    return -1;
}
