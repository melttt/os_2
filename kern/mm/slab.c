#include "defs.h"
#include "slab.h"
#include "pmm.h"
#include "mp.h"
#include "kdebug.h"
#include "stdio.h"

#define MALLOC(a) kmalloc(a)
#define FREE(a) kfree(a)
#define BUFSIZE 4096
#define to_slab(ptr) to_struct(ptr, struct kmm_slab, list)

static void kmm_slab_add_buf(kmm_slab_t slab, void *addr);
static void adjust_slab_list(kmm_cache_t cache, kmm_slab_t slab, kmm_status status);
static bufctl_t kmm_pull_buf(kmm_slab_t slab);
static void kmm_push_buf(kmm_slab_t slab, bufctl_t buf);
static kmm_status get_status(kmm_slab_t slab);


kmm_cache_t
kmm_cache_create(const char *name,size_t size)
{
    kmm_cache_t t = (kmm_cache_t)MALLOC(sizeof(struct kmm_cache));
    size_t i;
    if(!t) return NULL;
    t->size = size;
    t->name = name;
    for(i = 0 ; i < NCPU ; i ++)
    {
        list_init(&t->slab_list_cpu[i].slab_used);
        list_init(&t->slab_list_cpu[i].slab_free);
    }
    return t;
}

bool
kmm_cache_destroy(kmm_cache_t cache)
{
    list_entry_t *l_used = &cache->slab_list_cpu[get_cpu()].slab_used;
    list_entry_t *l_free = &cache->slab_list_cpu[get_cpu()].slab_free;
    list_entry_t *le,*tmp;
    assert(list_empty(l_used));
    if(!list_empty(l_free)){
        le = l_free->next; 
        while(le != l_free)
        {
            tmp = le;
            le = le->next;
            list_del(tmp);
            kmm_slab_destroy(to_slab(tmp));
        }
    }
    FREE(cache);
    return true;
}

void
kmm_slab_destroy(kmm_slab_t slab)
{
    assert(slab->status == KMM_FREE_LIST);
    list_del_init(&slab->list);
    FREE(slab->buffer);
    FREE(slab);
}


bool
kmm_slab_grow(kmm_cache_t cache)
{
    kmm_slab_t slab = (kmm_slab_t)MALLOC(sizeof(struct kmm_slab)); 
    size_t var;
    size_t size = cache->size + sizeof(struct bufctl);

    if(slab == NULL){
        goto slab_fail;
    } 

    slab->cache = cache;
    if(!(slab->buffer = MALLOC(BUFSIZE)))
    {
        goto buf_fail;
    }
    slab->free_count = BUFSIZE / size;
    list_init(&slab->list);
    slab->next_free = NULL;
    for(var = 0 ; var < slab->free_count ; var ++)
    {
        kmm_slab_add_buf(slab, slab->buffer + size*var);
    }
    slab->status = KMM_FREE_LIST;
    adjust_slab_list(cache, slab, KMM_FREE_LIST);
    return true;
buf_fail:
    FREE(slab);
slab_fail:
    return false;
}

static void
kmm_slab_add_buf(kmm_slab_t slab, void *addr)
{
   bufctl_t buf = (bufctl_t)addr;  
   buf->slab = slab;
   buf->addr = (buf + 1);
   buf->next = slab->next_free;
   slab->next_free = buf;
}

static void
adjust_slab_list(kmm_cache_t cache, kmm_slab_t slab, kmm_status status)
{
    list_entry_t *l_head;
    size_t i_cpu = get_cpu();
    assert(slab && cache);
    slab->status = status;
    switch(status)
    {
        case KMM_USED_LIST:
            l_head = &cache->slab_list_cpu[i_cpu].slab_used;
            break;
        case KMM_FREE_LIST:
            l_head = &cache->slab_list_cpu[i_cpu].slab_free;
            break;
        case KMM_FULL_LIST:
            l_head = NULL;
            break;
        default:
            panic("status is unknow");
    }
    list_del_init(&slab->list);
    if(l_head)
    {
        list_add_after(l_head, &slab->list);
    }
    slab->cache = cache;
}

void *
kmm_alloc(kmm_cache_t cache)
{
    assert(cache);
    list_entry_t *l_used = &cache->slab_list_cpu[get_cpu()].slab_used;
    list_entry_t *l_free = &cache->slab_list_cpu[get_cpu()].slab_free;
    kmm_slab_t slab;
    bufctl_t buf;

    if(!list_empty(l_used))
    {
        slab = to_slab(l_used->next);
    }else if(!list_empty(l_free))
    {
        slab = to_slab(l_free->next);  
    }else{
        if(!kmm_slab_grow(cache))
        {
            return NULL;
        }
        slab = to_slab(l_free->next);
    }
    buf = kmm_pull_buf(slab);
    adjust_slab_list(cache, slab, slab->status);

    return buf->addr;
}

inline static kmm_status
get_status(kmm_slab_t slab)
{
    assert(slab && slab->cache);
    size_t count = BUFSIZE / (slab->cache->size + sizeof(struct bufctl)); 

    assert(slab->free_count <= count && slab->free_count >= 0);
    if(count == slab->free_count)
    {
        return KMM_FREE_LIST;
    }else if(slab->free_count == 0)
    {
        return KMM_FULL_LIST;
    }else{
        return KMM_USED_LIST;
    }
}

static bufctl_t
kmm_pull_buf(kmm_slab_t slab)
{
    bufctl_t ret;
    assert(slab->next_free);
    ret = slab->next_free;
    slab->next_free = ret->next;
    slab->free_count --;
    slab->status = get_status(slab);
    return ret;
}

static void
kmm_push_buf(kmm_slab_t slab, bufctl_t buf)
{
    buf->next = slab->next_free;
    slab->next_free = buf;
    slab->free_count ++;
    slab->status = get_status(slab);
}

void
kmm_free(bufctl_t addr)
{
    assert(addr->slab && addr->slab->cache);
    kmm_cache_t cache = addr->slab->cache;
    kmm_push_buf(addr->slab, addr); 
    adjust_slab_list(cache, addr->slab, addr->slab->status);
}

