#include "defs.h"
#include "swap.h"
#include "swapfs.h"
#include "stdio.h"
#include "memlayout.h"
#include "mmu.h"
#include "pmm.h"

volatile bool  swap_init_ok = 0;
size_t max_swap_offset;

// the valid vaddr for check is between 0~CHECK_VALID_VADDR-1
#define CHECK_VALID_VIR_PAGE_NUM 5
#define BEING_CHECK_VALID_VADDR 0X1000
#define CHECK_VALID_VADDR (CHECK_VALID_VIR_PAGE_NUM+1)*0x1000
// the max number of valid physical page for check
#define CHECK_VALID_PHY_PAGE_NUM 4
// the max access seq number
#define MAX_SEQ_NO 10


static void check_swap(void);

    bool
swap_init(void)
{
    swapfs_init();

    if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
    {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
    }



    sm = &swap_manager_fifo;
    int r = sm->init();

    if (r == true)
    {
        swap_init_ok = 1;
        cprintf("SWAP: manager = %s\n", sm->name);
        check_swap();
    }

    return r;
}


    int
swap_init_mm(struct mm_struct *mm)
{
    return sm->init_mm(mm);
}


    int
swap_tick_event(struct mm_struct *mm)
{
    return sm->tick_event(mm);
}


    int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    return sm->map_swappable(mm, addr, page, swap_in);
}

    int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return sm->set_unswappable(mm, addr);
}

volatile unsigned int swap_out_num=0;


int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
    int i;
    for (i = 0; i != n; ++ i)
    {
        uintptr_t v;
        //struct Page **ptr_page=NULL;
        struct page *page;
        // cprintf("i %d, SWAP: call swap_out_victim\n",i);
        int r = sm->swap_out_victim(mm, &page, in_tick);
        if (r != 0) {
            cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
            break;
        }
        //assert(!PageReserved(page));

        //cprintf("SWAP: choose victim page 0x%08x\n", page);
        v=page->vaddr;
         
        pte_t *ptep = read_pte_addr(mm->pgdir, v, 0);
        assert((*ptep & PTE_P) != 0);
    
        //warning
        if (swapfs_write(page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
            cprintf("SWAP: failed to save\n");
            sm->map_swappable(mm, v, page, 0);
            continue;
        }
        else {
            cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
            *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
            free_page(page);
        }

        tlb_invalidate(mm->pgdir, v);
    }
    return i;
}

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
     struct page *result = alloc_page();
     assert(result!=NULL);

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));

     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
     {
        assert(r!=0);
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
     *ptr_result=result;
     return 0;
}


static inline void
check_content_set(void)
{
     *(unsigned char *)0x1000 = 0x0a;
     assert(pgfault_num==1);
     *(unsigned char *)0x1010 = 0x0a;
     assert(pgfault_num==1);
     *(unsigned char *)0x2000 = 0x0b;
     assert(pgfault_num==2);
     *(unsigned char *)0x2010 = 0x0b;
     assert(pgfault_num==2);
     *(unsigned char *)0x3000 = 0x0c;
     assert(pgfault_num==3);
     *(unsigned char *)0x3010 = 0x0c;
     assert(pgfault_num==3);
     *(unsigned char *)0x4000 = 0x0d;
     assert(pgfault_num==4);
     *(unsigned char *)0x4010 = 0x0d;
     assert(pgfault_num==4);
}



static inline int
check_content_access(void)
{
    int ret = sm->check_swap();
    return ret;
}







