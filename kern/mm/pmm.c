#include "defs.h"
#include "pmm.h"
#include "mmu.h"
#include "kdebug.h"
#include "stdio.h"
#include "buddy_pmm.h"
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
page2kva(uint32_t n)
{
    return (void*)P2V_WO(pmm_info.start + PGSIZE * (n));
}
static inline uint32_t
kpa2page(uint32_t addr)
{
    return ((uint32_t)addr - pmm_info.start) / PGSIZE;
}
static inline uint32_t
kva2page(void *va)
{
    return kpa2page(V2P_WO((uint32_t)va)); 
}
const struct pmm_manager *pmm_manager;

void*
alloc_pages(size_t n)
{
   uint32_t offset = pmm_manager->alloc_pages(n);
   if(offset != ALLOC_FALSE)
       return page2kva(offset);  
   else
       return NULL;
}

void
free_pages(void *n)
{
    assert((uint32_t)n >= KERNBASE);
    uint32_t offset = kva2page(n);    
    pmm_manager->free_pages(offset);
}
void 
init_pmm(void)
{
    void* i,*j;
    print_e280map();
    init_pmm_info();
    print_pmm_info();
    
    pmm_manager = &buddy_pmm_manager;
    pmm_manager->init(&pmm_info.start, &pmm_info.size);

    assert(pmm_info.size != 0 );

    i = alloc_pages(1);
    free_pages(i);
    i = alloc_pages(2);
    j = alloc_pages(1);
    cprintf("%x j : %x\n", (uint32_t)i, (uintptr_t)j);
    cprintf("pmm_end : %x\n",pmm_info.end);
    init_kvm();
    
    
    
}


