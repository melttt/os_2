#include "defs.h"
#include "memlayout.h"
#include "mmu.h"
#include "stdio.h"
#include "kdebug.h"
#define IS_POWER_OF_2(x) (!((x)&((x)-1)))
#define INVALID 7
#define LEFT_SON(INDEX) ((INDEX) * 2 + 1)
#define RIGHT_SON(INDEX) ((INDEX) * 2 + 2)
#define BUDDY_VAL(x) (buddy->val[x])
#define PARENT(INDEX) ((INDEX + 1) / 2 - 1)
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
static inline
uint32_t i2page_off(uint32_t i, uint32_t size)
{
    return (i + 1) * size - buddy->size ;
}

//return the real val
static inline
uint32_t ret_val32(uint8_t val)
{
    return 1 << ((val & 0x7f) - 1);
}
static inline
bool IsValid(uint8_t i)
{
    return (i & 0x80) ? false : true;
}
//adjust by son node
static inline void adjust_i(uint32_t i ,uint8_t power)
{
    uint32_t left_son_i = BUDDY_VAL(LEFT_SON(i)), right_son_i = BUDDY_VAL(RIGHT_SON(i)) ;
    if(IsValid(left_son_i) && IsValid(right_son_i))
    {
        if((left_son_i == right_son_i)  && (right_son_i == power - 1))
        {
            BUDDY_VAL(i) = left_son_i + 1;
        }else{
            BUDDY_VAL(i) = MAX(left_son_i, right_son_i);               
        }

    }else if(!IsValid(left_son_i) && IsValid(right_son_i))
    {
        BUDDY_VAL(i) = right_son_i; 
    }else if(IsValid(left_son_i) && !IsValid(right_son_i))
    {
        BUDDY_VAL(i) = left_son_i; 
    }else{
        BUDDY_VAL(i) = 0x80;
    }
}
uint32_t 
buddy_pmm_alloc(uint32_t size)
{
    if(size <= 0)
        return -1;
    
    if(buddy == NULL)
        return -1;
    if(!IS_POWER_OF_2(size))
        size = fix_size(size);
    size = fastlog2(size) + 1;
    uint32_t i = 0;
    uint32_t node_size = fastlog2(buddy->size) + 1;
    uint32_t offset;
    uint32_t offsize;
    //no enough space
    if((BUDDY_VAL(i) & 0x7f) < size)
        return -1;
       
    for(; size != node_size ; node_size --)
    {
       if((BUDDY_VAL(LEFT_SON(i)) & 0x7f) >= size)
       {
           i = LEFT_SON(i);
       }else{
           i = RIGHT_SON(i);
       }
    }

    assert(IsValid(BUDDY_VAL(i)) == true);
    BUDDY_VAL(i) = 0;
    offsize = ret_val32(node_size);
    cprintf("node_size : %d , i : %d, size : %d\n",node_size, i, size);
    offset = i2page_off(i,offsize );

    while(i)
    {
       adjust_i(i = PARENT(i), ++node_size); 
    }

    cprintf("offset : %x offsize : %x \n", offset, offsize);      
    return offset;
}

bool
buddy_pmm_free(uint32_t offset)
{
    assert(offset < buddy->size);

    uint32_t i = buddy->size - 1 + offset;
    uint32_t node_size = 1;
    while(BUDDY_VAL(i) != 0)
    {
        i = PARENT(i);    
        node_size ++;
    }

    BUDDY_VAL(i) = node_size;         

    while(i)
    {
        adjust_i(i = PARENT(i), ++node_size); 
    }
    return true;
}

void 
buddy_pmm_test()
{
    int z,x;
    z = buddy_pmm_alloc(0x2);
    x = buddy_pmm_alloc(0x2);
    buddy_pmm_free(z);
    buddy_pmm_alloc(0x2);
    buddy_pmm_alloc(0x7);
    buddy_pmm_alloc(0x2);
    buddy_pmm_free(x);
    buddy_pmm_alloc(0x2);
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

    int32_t i; 
    uint8_t node_size = 1 ; // fastlog2(buddy->size * 2);
    assert((node_size & 0x80) == 0);
    for( i = buddy->size * 2 - 2 ; i >= 0 ; i --)
    {
        uint32_t page_off;
         

        if(i < buddy->size - 1)
        {
            adjust_i(i, node_size);
        }else{

            BUDDY_VAL(i) = (node_size & 0x7f);
            page_off = i2page_off(i,1);
            if(page_off  >= buddy->pgsize)
            {
                BUDDY_VAL(i) |= 1 << INVALID;
            }
        }


        if(IS_POWER_OF_2(i + 1))
        {
            node_size += 1;
        }
    }

    assert(node_size == fastlog2(buddy->size * 2) + 1);
    
    int starnum = 0;
    int plusnum = 0;
    for(i = (buddy->size - 1); i <  buddy->size * 2 - 1 ; i ++ )
    {
        if(!IsValid(BUDDY_VAL(i)))
        {
    //        cprintf("*");
            starnum ++;
        }else{
     //       cprintf("_");
            plusnum ++;
        }
    }
    cprintf("\nstarnum : %x , plusnum : %x\n", starnum, plusnum);
    
        
    buddy_pmm_test();
    
    return 1;
}

