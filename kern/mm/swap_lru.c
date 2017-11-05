#include "defs.h"
#include "swap_lru.h"
#include "stdio.h"
#include "list.h"
#include "kdebug.h"
#include "pmm.h"
#include "vmm.h"


struct pra_list_manager{
    list_entry_t free_list;
    int32_t free_count;
    list_entry_t busy_list;
    uint32_t busy_count;
}_pra_list_manager;

#define LEN 10

/*
 *  _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */

static void
init_pra_list_manager(struct pra_list_manager *p)
{
     p->busy_count = p->free_count = 0;
     list_init(&p->free_list);
     list_init(&p->busy_list);
}
static int
_lru_init_mm(struct mm_struct *mm)
{
     init_pra_list_manager(&_pra_list_manager);
     mm->sm_priv = &_pra_list_manager;

     return 1;
}

static list_entry_t*
_lru_swap_cleanup(struct mm_struct *mm, int32_t cleanup_len)
{
    //init value
    struct pra_list_manager* p = (struct pra_list_manager*)mm->sm_priv;
    list_entry_t *free_head = &p->free_list;
    list_entry_t *busy_head = &p->busy_list;

    int32_t free_i = MIN(cleanup_len, p->free_count), busy_i = MIN(cleanup_len, p->busy_count);
    list_entry_t *found = NULL;
    int32_t i,delt;

    //find list_busy 
    list_entry_t *le = busy_head->next;
    for(i = 0, delt = 0 ; i < busy_i ; i ++,le = le->next)
    {
       struct page *page = le2page(le, pra_page_link);
       if(page->pgdir == NULL){
           list_del(le);
           p->busy_count --;
           continue;
       }
       pte_t* ptep = read_pte_addr(page->pgdir, page->pra_vaddr, 0);
       assert((*ptep & PTE_P) != 0);
       if(!(*ptep & PTE_A || *ptep & PTE_D))
       {
           list_del(le);
           list_add_before(free_head, le);
           delt ++;
       }
    }
    p->free_count += delt;
    p->busy_count -= delt;

    //find list_free
    le = free_head->next;
    for(i = 0, delt = 0 ; i < free_i ; i ++,le = le->next)
    {
       struct page *page = le2page(le, pra_page_link);
       if(page->pgdir == NULL){
           list_del(le);
           p->free_count --;
           continue;
       }
       assert(page->pgdir != NULL);
       pte_t* ptep = read_pte_addr(page->pgdir, page->pra_vaddr, 0);
       assert(*ptep & PTE_P);
       if(*ptep & PTE_A || *ptep & PTE_D)
       {
           list_del(le);
           list_add_before(busy_head, le);
           delt ++;
       }else{
           if(found == NULL)
               found = le; 
       }
    }
    p->free_count -= delt;
    p->busy_count += delt;

    return found;
}

/*
 *  _fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */

static bool
_lru_swap_out_victim(struct mm_struct *mm, struct page ** ptr_page, int in_tick)
{
    struct pra_list_manager* p = (struct pra_list_manager*)mm->sm_priv;
    list_entry_t *free_head = &p->free_list;
    list_entry_t *busy_head = &p->busy_list;
    list_entry_t *found;

    assert(in_tick == 0);
    assert( free_head != NULL && busy_head != NULL);

    found = _lru_swap_cleanup(mm, LEN);

    //point the first one
    if(found == NULL) 
    {
        if(p->free_count != 0)
        {
            found = free_head->next;
            p->free_count --;
        }
        else{
           if(p->busy_count == 0) return false;
           found = busy_head->next; 
           p->busy_count --;
        }
    }else{
        p->free_count --;
    }
    
    list_del(found); 
    *ptr_page = le2page(found, pra_page_link);


    return true;
}


/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static bool
_lru_map_swappable(struct mm_struct *mm, uintptr_t addr, struct page *page, int swap_in)
{
    struct pra_list_manager* p = (struct pra_list_manager*)mm->sm_priv;
    list_entry_t *free_head = &p->free_list;
    list_entry_t *entry = &(page->pra_page_link);
    _lru_swap_cleanup(mm, LEN);

    list_add_before(free_head, entry);
    p->free_count ++;
    return true;
}


static int
_lru_check_swap(void) {
    /*
    cprintf("write Virt Page c in fifo_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==4);
    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==4);
    cprintf("write Virt Page d in fifo_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==4);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==4);
    cprintf("write Virt Page e in fifo_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==5);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==5);
    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==6);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==7);
    cprintf("write Virt Page c in fifo_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==8);
    cprintf("write Virt Page d in fifo_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==9);
    cprintf("write Virt Page e in fifo_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==10);
    cprintf("write Virt Page a in fifo_check_swap\n");
    assert(*(unsigned char *)0x1000 == 0x0a);
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==11);
    */
    return 0;
}

static bool
_lru_init(void)
{
    return true;
}


static int
_lru_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_lru_tick_event(struct mm_struct *mm)
{ return 0; }


struct swap_manager swap_manager_lru =
{
     .name            = "lru swap manager",
     .init            = &_lru_init,
     .init_mm         = &_lru_init_mm,
     .tick_event      = &_lru_tick_event,
     .map_swappable   = &_lru_map_swappable,
     .set_unswappable = &_lru_set_unswappable,
     .swap_out_victim = &_lru_swap_out_victim,
     .check_swap      = &_lru_check_swap,
};



