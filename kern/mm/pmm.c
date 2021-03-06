#include "defs.h"
#include "param.h"
#include "pmm.h"
#include "x86.h"
#include "mmu.h"
#include "vmm.h"
#include "swap.h"
#include "kdebug.h"
#include "stdio.h"
#include "buddy_pmm.h"
#include "spinlock.h"
/**************************E820MAP***************************/
struct pmm_info pmm_info = {
    .size = 0,
};
// define in kernel.ld
extern char end[];
// describe info of pmm

//init in bootloader
static struct e820map{
    int nr_map;
    struct{
        long long addr;
        long long size;
        long type;

    }map[30];
}* e820map;
#define E820MAP_ADD 0x8000
#define E820MAP_AVA 0x1
//print mem layout
static void
print_e280map()
{
    int i;
    e820map = (struct e820map*)P2V(E820MAP_ADD);  
    assert(e820map->nr_map != 12345);
    for(i = 0 ; i < e820map->nr_map ; i ++)
    {
        uintptr_t map_start = (uintptr_t)e820map->map[i].addr;
        uint32_t map_size = (uint32_t)e820map->map[i].size;
        cprintf("start : %8x, size : %8x, flag : %s\n",map_start,
                map_size, (int)e820map->map[i].type == E820MAP_AVA ? "AVAILABLE" : "USED" );
    }
}

//init the struct about pmm_info
static void 
init_pmm_info()
{
    int32_t i;
    pmm_info.start = ROUNDUP(V2P_WO((uintptr_t)end), PGSIZE);
    //find available mem
    e820map = (struct e820map*)P2V(E820MAP_ADD);  
    assert(e820map->nr_map != 12345);
    for(i = 0 ; i < e820map->nr_map ; i ++)
    {
        uintptr_t map_start = (uintptr_t)e820map->map[i].addr;
        uint32_t map_size = (uint32_t)e820map->map[i].size;
        uintptr_t map_end = map_start + map_size;
        uint32_t mm_size;
        if((int)e820map->map[i].type == E820MAP_AVA && map_start < pmm_info.start && pmm_info.start < map_end )
        {
            pmm_info.end = ROUNDDOWN(map_end, PGSIZE);
            mm_size = pmm_info.end - pmm_info.start; 
            if(mm_size > KMEMSIZE)
                mm_size = KMEMSIZE;
            assert(mm_size % PGSIZE == 0);
            pmm_info.size = mm_size / PGSIZE; 
            break;
        }
    }

    assert(pmm_info.size != 0);
}

//print pmm_info
static inline void 
print_pmm_info()
{
    assert(pmm_info.size != 0);
    cprintf("pmm_start : %8x, pmm_end : %8x, pmm_size(PGSIZE) : %8x\n",pmm_info.start, pmm_info.end,
            pmm_info.size);
}

/********************************PMM*****************************************/

static inline void*
offset2kva(uint32_t n)
{
    return (void*)P2V_WO(pmm_info.start + PGSIZE * (n));
}
static inline uint32_t
kpa2offset(uint32_t addr)
{
    return ((uint32_t)addr - pmm_info.start) / PGSIZE;
}
static inline uint32_t
kva2offset(void *va)
{
    return kpa2offset(V2P_WO((uint32_t)va)); 
}
const struct pmm_manager *pmm_manager;
uint32_t
get_page_offset(struct page* page)
{
    uint32_t ret;
    assert(page >= pmm_manager->ret_page_addr(0));
    ret = page - pmm_manager->ret_page_addr(0);
    return  ret;
}

void*
alloc_pages(size_t n)
{
   uint32_t offset = pmm_manager->alloc_pages(n);
   if(offset != ALLOC_FALSE)
       return offset2kva(offset);  
   else
       return NULL;
}

void
free_pages(void *n)
{
    assert((uint32_t)n >= KERNBASE);
    uint32_t offset = kva2offset(n);    
    pmm_manager->free_pages(offset);
}


/*not use swap ,the fuction is not use*//*use in do_exec*/
struct page*
alloc_page()
{
   uint32_t offset;
   while(1)
   {
       offset = pmm_manager->alloc_pages(1);
       if (offset != ALLOC_FALSE || swap_init_ok == 0) break;
       extern struct mm_struct *check_mm_struct;
       //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
       swap_out(check_mm_struct, 1, 0);
   }
   if(offset != ALLOC_FALSE && swap_init_ok == 1)
   {
       struct page* page = pmm_manager->ret_page_addr(offset);  
       page->pra_vaddr = (uintptr_t)offset2kva(offset);
       page->pgdir = kpgdir;
   }

   return offset != ALLOC_FALSE ? pmm_manager->ret_page_addr(offset) : NULL;
}
//free one page
void
free_page(struct page* page)
{
    assert(page >= pmm_manager->ret_page_addr(0));
    uint32_t offset = page - pmm_manager->ret_page_addr(0);
    page->pra_vaddr = 0;
    page->pgdir = NULL;
    pmm_manager->free_pages(offset);
}

/*************/

void*
page2kva(struct page* page)
{
    void * ret;
    assert(page >= pmm_manager->ret_page_addr(0));
    uint32_t offset = page - pmm_manager->ret_page_addr(0);
    ret = offset2kva(offset);
    return ret;
}

struct page*
kva2page(void *va)
{
    struct page *ret;
    uint32_t offset = kva2offset(va);
    ret = pmm_manager->ret_page_addr(offset);
    return ret;
}

uintptr_t
page2pa(struct page* page)
{
    return V2P(page2kva(page));
}

struct page*
pa2page(uintptr_t pa)
{
    return kva2page(P2V(pa));
}

size_t
nr_free_pages(void){
    size_t ret;
    ret = pmm_manager->nr_free_pages();
    return ret;
}
void 
init_pmm(void)
{

    init_pmm_info();
#if KERN_INFO
    print_e280map();
    print_pmm_info();
#endif
    pmm_manager = &buddy_pmm_manager;
    pmm_manager->init(&pmm_info.start, &pmm_info.size);
    cprintf(INITOK"pmm init ok !\n");

    assert(pmm_info.size != 0 );

    vmm_init();
    init_slab_allocator();
    //suggest 1
    slab_allocator_test(1);   
}


// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
    if (rcr3() == V2P(pgdir)) {
        invlpg((void *)la);
    }
}
