#include "defs.h"
#include "pmm.h"
#include "slab.h"
#include "kdebug.h"
#include "mmu.h"
/*
void* alloc_pages(size_t n);
void free_pages(void *n);
*/
#define SLAB_ALLOCATOR_SIZE 20
bool slab_allocator_activated = false;
kmm_cache_t slab_allocator[SLAB_ALLOCATOR_SIZE];
#define SLAB_NORMAL 11
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


//0 = normal, 1 = kmm_cache, 2 = kmm_slab 
static int8_t
select_slab(size_t size)
{
    if(size > slab_size_map[SLAB_NORMAL - 1])
    {
        return -1;
    }
    //binfind will be better
    int i;
    for(i = 0 ; i < SLAB_NORMAL ; i ++)
    {
        if(size >= slab_size_map[i])
        {
            return i;
        }
    }
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
        slab_allocator[i] = kmm_cache_create("n-malloc",slab_size_map[i]);
    }
    for(i = 0; i < 10 ; i ++)
    {
        kmm_slab_grow(slab_allocator[SLAB_NORMAL]);
        kmm_slab_grow(slab_allocator[SLAB_NORMAL + 1]);
    }
    slab_allocator_activated = true; 
}


void
kfree(void *n)
{
    if((uintptr_t)n&PGSIZE && slab_allocator_activated)
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
    bufctl_t buf = NULL;
    if(n <= 0) return NULL;

    if(slab_allocator_activated == false || n >= PGSIZE)
    {
        return alloc_pages( (PGSIZE + n - 1) / PGSIZE );
    }else{
        if(n == sizeof(struct kmm_cache))
        {
            buf = kmm_alloc(slab_allocator[SLAB_NORMAL]);  
            if(!buf) goto alloc_page; 
        }else if(n == sizeof(struct kmm_slab))
        {
            buf = kmm_alloc(slab_allocator[SLAB_NORMAL + 1]);  
            if(!buf) goto alloc_page; 
        }else{
            buf = kmm_alloc(slab_allocator[select_slab(n)]);
            if(!buf) goto ret_null; 
        }
    }
    return buf->addr;
alloc_page:
    ret = alloc_pages(1);
ret_null:
    return ret; 
}








