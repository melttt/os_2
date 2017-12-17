#include "defs.h"
#include "pmm.h"
#include "slab.h"
#include "kdebug.h"
#include "mmu.h"
#include "stdio.h"
#define LOG_DEBUG(a,...)  \
        cprintf(a,##__VA_ARGS__)

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
void 
init_slab_allocator()
{
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


void
kfree(void *n)
{
    if((uintptr_t)n&PGSIZE && slab_allocator_activated)
    {
        LOG_DEBUG("kmm_free : %x\n",(int32_t)n);
        kmm_free((bufctl_t)n - 1); 
    }else{
        LOG_DEBUG("free_pages : %x\n",(int32_t)n);
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
        LOG_DEBUG("alloc_pages size: %d\n",n);
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
    LOG_DEBUG("kmm_alloc size: %d\n",n);
    return ret;
alloc_page:
    LOG_DEBUG("alloc_one_page \n");
    ret = alloc_pages(1);
ret_null:
    return ret; 
}




void
slab_allocator_test(void)
{
    LOG_DEBUG("slab test start !\nbuf_size : %d \n", sizeof(struct bufctl));    
    int *a = kmalloc(sizeof(int));
    int *b;
    *a = 1;
    kfree(a);
    b = kmalloc(sizeof(int) * 4);
    kfree(b);


    LOG_DEBUG("slab test end !\n");
}
