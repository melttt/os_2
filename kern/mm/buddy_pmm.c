#include "defs.h"
#include "memlayout.h"
#include "mmu.h"
#include "stdio.h"
#include "kdebug.h"
#define IS_POWER_OF_2(x) (!((x)&((x)-1)))
#define INVALIED 7

// 
struct buddy{
    uintptr_t beginning_addr;    //the beginning address of buddy 
    uint32_t pgsize;             //the num of page(4096) 
    uint32_t size;               //the num of page,but in power of 2
    uint8_t val[1];              //a val describe a page
}*buddy;

//return log2(x)
uint8_t fastlog2(int x)
{
    float fx;
    unsigned long ix, exp;

    fx = (float)x;
    ix = *(unsigned long*)&fx;
    exp = (ix >> 23) & 0xff;

    return exp - 127;
}


// return the power of 2 of size 
static uint32_t
fix_size(uint32_t size)
{
    size |= size >> 1;
    size |= size >> 2;
    size |= size >> 4;
    size |= size >> 8;
    size |= size >> 16;
    return size + 1;
}


//init the buddy  and calc the real start addr
static void 
calc(uintptr_t p_start, uint32_t pg_size)
{
     uint32_t tmp; 
     tmp  = ROUNDUP(fix_size(pg_size) * 2 - 1 + 12 + p_start  , PGSIZE); 
     buddy =  (struct buddy*)p_start;
     buddy->beginning_addr = tmp;
     assert(buddy->beginning_addr > p_start);
     assert((buddy->beginning_addr - p_start) % PGSIZE == 0);
     buddy->pgsize = pg_size -  (buddy->beginning_addr - p_start) / PGSIZE;

     buddy->size  = fix_size(buddy->pgsize);

}

//return the offset of the i'th page
static inline uint32_t i2page_off(uint32_t i, uint32_t size)
{
    return (i + 1) * size - buddy->size ;
}

//return the real val
static inline uint32_t ret_val32(uint8_t val)
{
    return 1 << ((val & 0x7f) - 1);
}

//init pmm in buddy system
bool 
init_buddy_pmm(uintptr_t p_start, uint32_t pg_size)
{
    //
    calc(p_start,pg_size);
    cprintf("buddy_start: %8x, buddy_pgsize: %8x, buddy_size: %8x\n",buddy->beginning_addr, buddy->pgsize, buddy->size); 
    assert(buddy->size > 0);
    assert(buddy->beginning_addr - p_start >= (buddy->size + 12));

    
    uint32_t i;
    uint8_t node_size = fastlog2(buddy->size * 2);
    assert((node_size & 0x80) == 0);
    for(i = 0 ; i < buddy->size * 2 - 1 ; i ++)
    {
        uint32_t page_off;
        if(IS_POWER_OF_2(i + 1))
        {
            assert(node_size != 0);
            node_size -= 1;
        }
         
        buddy->val[i] = (node_size & 0x7f) + 1;
        page_off = i2page_off(i,ret_val32(buddy->val[i]) );
        if(i == 1)
            cprintf("page_off : %x add : %x\n" ,page_off,page_off + ret_val32(buddy->val[i]) );
        if(page_off + ret_val32(buddy->val[i]) > buddy->pgsize)
        {
            buddy->val[i] |= 1 << INVALIED;
        }
    }
    
    int starnum = 0;
    int plusnum = 0;
    for(i =(buddy->size - 1); i <  buddy->size * 2 - 1 ; i ++ )
    {
        if(buddy->val[i] & 0x80)
        {
    //        cprintf("*");
            starnum ++;
        }else{
     //       cprintf("_");
            plusnum ++;
        }
    }
    cprintf("\nstarnum : %x , plusnum : %x\n", starnum, plusnum);
    

         
    
    return 1;
}

