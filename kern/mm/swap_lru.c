#include "defs.h"
#include "swap_lru.h"
#include "stdio.h"
#include "list.h"
#include "pmm.h"
#include "vmm.h"


struct pra_list_manager{
    list_entry_t free_list;
    int32_t free_count;
    list_entry_t busy_list;
    uint32_t busy_count;
}_pra_list_manager;


/*
 *  _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */

static void
init_pra_list_manager(struct pra_list_manager *p)
{
     p->busy_count = p->free_count = 0;
     list_init(p->free_list);
     list_init(p->busy_list);
}
static int
_fifo_init_mm(struct mm_struct *mm)
{
     init_pra_list_manager(_pra_list_manager);
     mm->sm_priv = &_pra_list_manager;

     return 0;
}

/*
 * _fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct page *page, int swap_in)
{
    struct pra_list_manager* now_manager = (struct pra_list_manager*)mm->sm_priv;
    list_entry_t *free_head = &now_manager->free_list;
    list_entry_t *busy_head = &now_manager->busy_list;
    list_entry_t *entry=&(page->pra_page_link);


    assert(entry != NULL && free_head != NULL && busy_head != NULL);
    list_before(busy_head, entry);
    now_manager->busy_count ++;

    list_entry_t *le = free_head->prev;
    if(le != free_head)
    {
       struct page *page = le2page(le, pra_page_link);

    }


    return 0;
}





