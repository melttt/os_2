#include "defs.h"
#include "list.h"
#include "pmm.h"
#include "kdebug.h"
//void* alloc_pages(size_t n);
//void free_pages(void *n);
typedef enum{
    KMM_FULL_LIST,
    KMM_USED_LIST,
    KMM_FREE_LIST
}kmm_status;

struct kmm_cache{
    size_t size;
    struct{
        list_entry_t slab_used;
        list_entry_t slab_free;
    }slab_list_cpu[NCPU];
};
typedef struct kmm_cache *kmm_cache_t;

struct kmm_slab{
    kmm_status status;
    struct kmm_cache_t cache;
    int32_t free_count;
    void *buffer;
    list_entry_t list;
    struct bufctl next_free;
};
typedef struct kmm_slab *kmm_slab_t;

struct bufctl{
    struct bufctl *next;
    kmm_slab_t *slab;
    void *addr;
};
typedef struct bufctl *bufctl_t;





