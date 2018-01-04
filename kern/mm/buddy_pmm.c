#include "defs.h"
#include "memlayout.h"
#include "mmu.h"
#include "stdio.h"
#include "kdebug.h"
#include "buddy_pmm.h"
#include "pmm.h"
#define IS_POWER_OF_2(x) (!((x)&((x)-1)))
#define INVALID 7
#define LEFT_SON(INDEX) ((INDEX) * 2 + 1)
#define RIGHT_SON(INDEX) ((INDEX) * 2 + 2)
#define BUDDY_VAL(x) (buddy->page[x].val)
#define BUDDY_REF(x) (buddy->page[x].ref)
#define BUDDY_PAGE_ADDR(x) (&(buddy->page[x]))
#define PARENT(INDEX) ((INDEX + 1) / 2 - 1)
#define BUDDY_SIZE_EXCEPT_VAL  (sizeof(struct buddy) - sizeof(struct page))
#define INIT_LOCK init_lock(&buddy->lock, "buddy_system")
#define ACQUIRE acquire(&buddy->lock)
#define RELEASE release(&buddy->lock)

struct buddy{
    uintptr_t beginning_addr;    //the beginning address of buddy 
    uint32_t free_pg;            //the num of free page
    uint32_t pg_size;             //the num of page(4096) 
    uint32_t size;               //the num of page,but in power of 2
    struct spinlock lock;
    struct page page[1];
}__attribute__((packed))*buddy;


//return log2(x)
static uint8_t
fastlog2(int x)
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
     //calc new beginning
     tmp  = ROUNDUP((fix_size(pg_size) * 2 - 1) * sizeof(struct page) + BUDDY_SIZE_EXCEPT_VAL + p_start  , PGSIZE); 
     buddy =  (struct buddy*)P2V(p_start);
     buddy->beginning_addr = tmp;
     assert(buddy->beginning_addr > p_start);
     assert((buddy->beginning_addr - p_start) % PGSIZE == 0);

     //
     buddy->pg_size = pg_size -  (buddy->beginning_addr - p_start) / PGSIZE - 1;

     buddy->size  = fix_size(buddy->pg_size);
     buddy->free_pg = buddy->pg_size;
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
static inline void
adjust_i(uint32_t i ,uint8_t power)
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

static inline uint32_t 
offset2i(uint32_t offset, int32_t* node_size)
{
    uint32_t i = buddy->size - 1 + offset;
    assert(*node_size == 1);
    while(BUDDY_VAL(i) != 0)
    {
        i = PARENT(i);    
        (*node_size) ++;
    }
    return i;
}


static uint32_t 
buddy_pmm_alloc(uint32_t size)
{
    if(size <= 0)
        return ALLOC_FALSE;
    
    if(buddy == NULL)
        return ALLOC_FALSE;
    if(!IS_POWER_OF_2(size))
        size = fix_size(size);
    size = fastlog2(size) + 1;

    uint32_t i = 0;
    uint32_t node_size = fastlog2(buddy->size) + 1;
    uint32_t offset;
    uint32_t offsize;
    //no enough space
    if((BUDDY_VAL(i) & 0x7f) < size)
    {
        return ALLOC_FALSE;
    }
     
    ACQUIRE;
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
    BUDDY_REF(i) ++;
    offsize = ret_val32(node_size);
    offset = i2page_off(i,offsize );

    while(i)
    {
       adjust_i(i = PARENT(i), ++node_size); 
    }
    buddy->free_pg -= offsize;
    RELEASE;
    //cprintf("offset : %x offsize : %x \n", offset, offsize);      
    return offset;
}

static void 
buddy_pmm_free(uint32_t offset)
{
    assert(offset < buddy->size);
    ACQUIRE;
    int32_t node_size = 1;
    uint32_t i = offset2i(offset,&node_size);

    BUDDY_VAL(i) = node_size;         
    assert(BUDDY_REF(i) != 0);
    BUDDY_REF(i) --;
//    cprintf("add pg: %x\n",node_size);
    buddy->free_pg += ret_val32(node_size); 

    while(i)
    {
        adjust_i(i = PARENT(i), ++node_size); 
    }
    RELEASE;
}


static int8_t
buddy_change_page_ref(uint32_t offset, int8_t ch)
{
    ACQUIRE;
    assert(offset < buddy->size);
    int32_t node_size = 1;
    uint32_t i = offset2i(offset,&node_size);
    assert((BUDDY_REF(i) + ch) >= 1);
    int8_t ret = BUDDY_REF(i) += ch;
    RELEASE;
    return ret;
}

static void 
buddy_pmm_test(uintptr_t p_start)
{
    uint32_t i,free_num = 0;
    uint32_t free_store = buddy->free_pg;

    assert((buddy->beginning_addr - p_start) >= (buddy->size + BUDDY_SIZE_EXCEPT_VAL));
    for(i = (buddy->size - 1) ; i < 2 * buddy->size - 1 ; i  ++)
    {
       free_num ++; 
    }
    assert(free_num == buddy->size);
    //test 1
    uint32_t a,b,c;
    a = buddy_pmm_alloc(1); 
    b = buddy_pmm_alloc(1);
    c = buddy_pmm_alloc(1);
    
    assert(a != ALLOC_FALSE && b != ALLOC_FALSE && c != ALLOC_FALSE);
    assert(a == 0 && b == 1 && c == 2);
    
    buddy_pmm_free(b);
    b = buddy_pmm_alloc(2);
    assert(b == 4);

    buddy_pmm_free(c);
    c = buddy_pmm_alloc(2);
    assert(c == 2);

    buddy_pmm_free(a);
    a = buddy_pmm_alloc(2);
    assert(a == 0);

    assert(buddy_change_page_ref(a,0) == 1); 
    buddy_pmm_free(a); 
    buddy_pmm_free(b); 
    assert(buddy_change_page_ref(c,0) == 1);
    assert(buddy_change_page_ref(c,4) == 5);
    assert(buddy_change_page_ref(c,-4) == 1);
    buddy_pmm_free(c); 
    
    assert(buddy->free_pg == buddy->pg_size);

    //test 2
    a = buddy_pmm_alloc(3); 
    assert(a == 0);
    b = buddy_pmm_alloc(5);
    assert(b == 8);
    c = buddy_pmm_alloc(7);
    assert(c == 16);

    buddy_pmm_free(b);
    b = buddy_pmm_alloc(3);
    assert(b == 4);
    buddy_pmm_free(a);
    a = buddy_pmm_alloc(9);
    assert(a == 32);
    
    buddy_pmm_free(a);
    buddy_pmm_free(b); 
    buddy_pmm_free(c); 


    assert(buddy->free_pg == buddy->pg_size);
    //test 3
    uint32_t d,e;
    a = buddy_pmm_alloc(0x990);   
    b = buddy_pmm_alloc(0x2000);
    assert(b == a + b && b == 0x2000);
    c = buddy_pmm_alloc(0x2990);
    assert(c == 0x4000);
    d = buddy_pmm_alloc(940);
    assert(d == 0x1000);
    e = buddy_pmm_alloc(buddy->size);
    assert(e == ALLOC_FALSE);
    buddy_pmm_free(d); 
    d = buddy_pmm_alloc(0x39);
    assert(d == 0x1000);
    assert((buddy->pg_size - buddy->free_pg) == (0x1000 + 0x2000 + 0x4000+ 0x40));
    buddy_pmm_free(a);
    buddy_pmm_free(b); 
    buddy_pmm_free(c); 
    buddy_pmm_free(d); 
    
    assert(buddy->free_pg == buddy->pg_size);

    //test 4
    b = 0;
    for(a = buddy->size / 2 ; (a != 0) && ((c = buddy_pmm_alloc(a)) != ALLOC_FALSE) ; b += a, a /= 2 )
    {
       assert(b == c); 
    }
    assert(a > buddy->free_pg);
    for(d = buddy->size / 2 , b = 0 ; d != a ; b += d, d /= 2 )
    {
        buddy_pmm_free(b);
    }
    assert(buddy->free_pg == buddy->pg_size);



    free_num = 0;
    for(i = (buddy->size - 1) ; i < 2 * buddy->size - 1 ; i  ++)
    {
       free_num ++; 
    }
    assert(free_num == buddy->size);
    assert(free_store = buddy->free_pg);
}
//init pmm in buddy system
static void
init_buddy_pmm(uintptr_t *p_start, uint32_t *pg_size)
{
    //
    calc(*p_start,*pg_size);
    cprintf("buddy_start: %8x, buddy_pg_size: %8x, buddy_size: %8x\n",buddy->beginning_addr, buddy->pg_size, buddy->size); 
    assert(buddy->size > 0);
    assert(buddy->beginning_addr - *p_start >= (buddy->size + 12));

    int32_t i; 
    uint8_t node_size = 1 ; // fastlog2(buddy->size * 2);
    assert((node_size & 0x80) == 0);
    for( i = buddy->size * 2 - 2 ; i >= 0 ; i --)
    {
        uint32_t page_off;
         

        BUDDY_REF(i) = 0;
        if(i < buddy->size - 1)
        {
            adjust_i(i, node_size);
        }else{

            BUDDY_VAL(i) = (node_size & 0x7f);
            page_off = i2page_off(i,1);
            if(page_off  >= buddy->pg_size)
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
    buddy_pmm_test(*p_start);
         
    *p_start = buddy->beginning_addr;
    *pg_size = buddy->pg_size;
    INIT_LOCK;
    cprintf("---------->buddy init ok!\n");
}

static size_t
buddy_pmm_free_pages()
{
    return buddy->free_pg;
}

static struct page*
buddy_pmm_ret_page_addr(size_t offset)
{
    assert(offset <= (buddy->size / 2)); 
    return BUDDY_PAGE_ADDR(buddy->size / 2 + offset);
}


const struct pmm_manager buddy_pmm_manager = {
    .name = "Buddy_System_Pmm_Manager",
    .init = init_buddy_pmm,
    .alloc_pages = buddy_pmm_alloc,
    .free_pages = buddy_pmm_free,
    .nr_free_pages = buddy_pmm_free_pages,
    .change_page_ref = buddy_change_page_ref,
    .ret_page_addr = buddy_pmm_ret_page_addr,
};
