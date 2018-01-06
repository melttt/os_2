#ifndef __KERN_SLAB_H_
#define __KERN_SLAB_H_
#include "defs.h"
#include "list.h"
#include "param.h"
#include "spinlock.h"
//void* alloc_pages(size_t n);
//void free_pages(void *n);
typedef enum{
    KMM_FULL_LIST,
    KMM_USED_LIST,
    KMM_FREE_LIST
}kmm_status;

struct kmm_cache{
    const char *name;
    size_t size;
    struct{
        list_entry_t slab_used;
        list_entry_t slab_free;
        struct spinlock lock;
    }slab_list_cpu[NCPU];
};
typedef struct kmm_cache *kmm_cache_t;

struct bufctl;
struct kmm_slab{
    kmm_status status;
    kmm_cache_t cache;
    int32_t free_count;
    void *buffer;
    list_entry_t list;
    struct bufctl* next_free;
};
typedef struct kmm_slab *kmm_slab_t;

struct bufctl{
    struct bufctl *next;
    kmm_slab_t slab;
    void *addr;
};
typedef struct bufctl *bufctl_t;



kmm_cache_t kmm_cache_create(const char *name, size_t size);
bool kmm_cache_destroy(kmm_cache_t cache);
bool kmm_slab_grow(kmm_cache_t cache);
void kmm_slab_destroy(kmm_slab_t slab);
void* kmm_alloc(kmm_cache_t cache);
void kmm_free(bufctl_t addr);

#endif
