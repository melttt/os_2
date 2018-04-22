#include "defs.h"
#include "pmm.h"
#include "slab.h"
#include "kdebug.h"
#include "mmu.h"
#include "stdio.h"
#ifdef KDEBUG
#define LOG_DEBUG(x,...)  cprintf(x,##__VA_ARGS__)
#endif
/*
void* alloc_pages(size_t n);
void free_pages(void *n);
*/
#define SLAB_ALLOCATOR_SIZE 20
#define SLAB_NORMAL 11
static const char *str[SLAB_NORMAL] = {
    "slab-8",
    "slab-16",
    "slab-32",
    "slab-64",
    "slab-96",
    "slab-128",
    "slab-192",
    "slab-256",
    "slab-512",
    "slab-1024",
    "slab-2048"
};

static bool slab_allocator_activated = false;
static kmm_cache_t slab_allocator[SLAB_ALLOCATOR_SIZE];
size_t slab_size_map[SLAB_ALLOCATOR_SIZE] = {
    [0] = 8,
    [1] = 16,
    [2] = 32,
    [3] = 64,
    [4] = 96,
    [5] = 128,
    [6] = 192,
    [7] = 256,
    [8] = 512,
    [9] = 1024,
    [10] = 2048,
};

//0 = normal, 1 = kmm_cache, 2 = kmm_slab 
static int32_t
select_slab(size_t size)
{
    if(size > slab_size_map[SLAB_NORMAL - 1])
    {
        panic("NO VALID SLAB");
        return -1;
    }
    //binfind will be better
    int i;
    for(i = 0 ; i < SLAB_NORMAL ; i ++)
    {
        if(slab_size_map[i] >= size)
        {
            return i;
        }
    }
    panic("NO VALID SLAB");
    return -1;
}
static size_t init_before_page;
void 
init_slab_allocator()
{
    init_before_page = nr_free_pages();
    //install special slab -> cache,slab
    slab_size_map[SLAB_NORMAL] = sizeof(struct kmm_cache); 
    slab_size_map[SLAB_NORMAL + 1] = sizeof(struct kmm_slab);

    //init 'slab cache' slab  
    slab_allocator[SLAB_NORMAL] = kmm_cache_create("KMM_CACHE",sizeof(struct kmm_cache));
    slab_allocator[SLAB_NORMAL + 1] = kmm_cache_create("KMM_SLAB",sizeof(struct kmm_slab));
    assert(slab_allocator[SLAB_NORMAL] && slab_allocator[SLAB_NORMAL + 1]);

    //init 'normal' slab
    int i;
    for(i = 0 ; i < SLAB_NORMAL ; i ++)
    {
        slab_allocator[i] = kmm_cache_create(str[i],slab_size_map[i]);
    }
    for(i = 0; i < 5 ; i ++)
    {
        assert(kmm_slab_grow(slab_allocator[SLAB_NORMAL]));
        assert(kmm_slab_grow(slab_allocator[SLAB_NORMAL + 1]));
    }
    slab_allocator_activated = true; 
}
//just for test case 2
static void 
deinit_slab_allocator()
{
    int i = 0;
    for(i = 0 ; i <= 12 ; i ++)
    {
        kmm_cache_destroy(slab_allocator[i]);
    }
    slab_allocator_activated = false; 
    assert(nr_free_pages() == init_before_page);
}

void
kfree(void *n)
{
    if(((uintptr_t)n&(PGSIZE-1)) && slab_allocator_activated)
    {
        kmm_free((bufctl_t)n - 1); 
    }else{
        free_pages(n);
    }
}
void* 
kmalloc(int32_t n)
{
    void *ret = NULL;
    if(n <= 0) return NULL;
    if(slab_allocator_activated == false || n > slab_size_map[SLAB_NORMAL - 1])
    {
        return alloc_pages( (PGSIZE + n - 1) / PGSIZE );
    }else{
        if(n == sizeof(struct kmm_cache))
        {
            ret = kmm_alloc(slab_allocator[SLAB_NORMAL]);  
            if(!ret) goto alloc_page; 
        }else if(n == sizeof(struct kmm_slab))
        {
            ret = kmm_alloc(slab_allocator[SLAB_NORMAL + 1]);  
            if(!ret) goto alloc_page; 
        }else{
            ret = kmm_alloc(slab_allocator[select_slab(n)]);
            
            if(!ret) goto ret_null; 
        }
    }
    assert(ret != NULL);

    return ret;
alloc_page:
    ret = alloc_pages(1);
ret_null:
    assert(ret != NULL);
    return ret; 
}



//try X macro :-)

void
slab_allocator_test(size_t n)
{
//    LOG_DEBUG("slab test start !\nbuf_size : %d \n", sizeof(struct bufctl));    
    //Case 1: only one data
    int *a = NULL, *tmp = NULL;
    a = tmp = kmalloc(sizeof(int)); 
    kfree(a);
    a = kmalloc(sizeof(int));     
    kfree(a);
    a = kmalloc(sizeof(int));
    assert(a == tmp);
    kfree(tmp);

    //Case 2: many data
#define TEST_LIST \
    ENTRY(8,40) \
    ENTRY(16,20) \
    ENTRY(32,14) \
    ENTRY(64,12) \
    ENTRY(128,32) \
    ENTRY(192,50) \
    ENTRY(256,62) \
    ENTRY(512,12) \
    ENTRY(1024,10) \
    ENTRY(2048,7)

#define SLAB_TEST2_LEN 100
    void* ptr[SLAB_TEST2_LEN];
#define I(x) __i_##x
#define FOR_EACH_INT(a,b)   \
    for(I(a) = 0 ; I(a) < b ; I(a) ++) 
#define ENTRY(a,b) \
    do{             \
        int I(a) ;    \
        FOR_EACH_INT(a,b)       \
        {                       \
            ptr[I(a)] = kmalloc(sizeof(char) * a); \
        }                                           \
        FOR_EACH_INT(a,b)       \
        {                       \
            kfree(ptr[I(a)]);   \
        }               \
    }while(0);
    TEST_LIST
    TEST_LIST
#undef ENTRY
#undef FOR_EACH_INT
#undef I
    deinit_slab_allocator();
    init_slab_allocator();
    if(n != 0)
    {
        slab_allocator_test(--n);
        LOG_DEBUG(INITOK"slab test ok !\n");
    }
}
