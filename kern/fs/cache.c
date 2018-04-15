#include "basic_p.h"
#include "mm_p.h"
#include "lock_p.h"
#include "stdio.h"
#include "string.h"
#include "kdebug.h"
#include "uthash.h"
#include "list.h"
#include "ide_2.h"
#include "timer.h"


#define LOG_CACHE(x, ...)  cprintf(x, ##__VA_ARGS__)
#define CACHE_SIZE FS_BUF_SIZE
#define CACHE_NUM_PER_SEC (CACHE_SIZE / SEC_SIZE) 

#define BIT_VALID 1
#define BIT_DIRTY 2
#define BIT_WRITING 4
#define BIT_WRITE (BIT_VALID | BIT_DIRTY)
#define BIT_READ (BIT_VALID)

#define BIT_INVALID 0
typedef struct{
    uint32_t sec;
    uint8_t flags; 
    void *buf;
    list_entry_t list;
    UT_hash_handle hh;
}cache_t;
#define list2cache(a) (to_struct(a, cache_t, list))
#define DEFAULT_LIMIT (8000)
typedef struct{
    int tick;
    int limit;
    int capacity;
    list_entry_t unfsyn_list; 
    int unfsyn_num;
    list_entry_t invalid_list;
    int invalid_num;
    struct spinlock lock; 
    cache_t* UT_hash_head; 
}_cache_manager;
static _cache_manager cache_manager; 
#define CACHE_CAPACITY_C(a) (cache_manager.capacity += a)
#define CACHE_HASH_HEAD (cache_manager.UT_hash_head)
#define CACHE_UNFSYN_LIST_P (&cache_manager.unfsyn_list)
#define CACHE_UNFSYN_NUM_C(a) (cache_manager.unfsyn_num += a)

#define CACHE_INVALID_NUM_C(a) (cache_manager.invalid_num += a)
#define CACHE_INVALID_LIST_P (&cache_manager.invalid_list)
#define CACHE_LOCK (&cache_manager.lock)
#define ACQUIRE_CACHE acquire(CACHE_LOCK)
#define RELEASE_CACHE release(CACHE_LOCK)

int cache_init()
{
    ideinit();
    cache_manager.limit = DEFAULT_LIMIT ;
    cache_manager.capacity = 0; 
    cache_manager.tick = 0;

    list_init(CACHE_UNFSYN_LIST_P);
    cache_manager.unfsyn_num = 0;
    list_init(CACHE_INVALID_LIST_P);
    cache_manager.invalid_num = 0;

    init_lock(CACHE_LOCK ,"cache lock");
    CACHE_HASH_HEAD = NULL;
    cprintf(INITOK"cache_ok\n");
    return 0;
}

static int cache_reduce_list();
static cache_t* cache_malloc()
{
    if(cache_manager.capacity >= cache_manager.limit) 
    {
        cache_reduce_list();
    }

    cache_t *t = kmalloc(sizeof(cache_t));
    t->buf = kmalloc(CACHE_SIZE);
    assert(t->buf != NULL);
    t->flags = BIT_INVALID;
    list_init(&t->list);

    return t; 
}

static void cache_free(cache_t *t)
{
    kfree(t->buf);
    kfree(t);
}


static cache_t* cache_add(int sec, void *buf, int flags)
{
    cache_t* t = cache_malloc(); 
    assert(t);
    if(flags == BIT_WRITE)
        memcpy(t->buf, buf, CACHE_SIZE);       
    t->sec = sec;

    ACQUIRE_CACHE; 
    HASH_ADD_INT(CACHE_HASH_HEAD, sec, t); 
    RELEASE_CACHE;

    return t;
}

static cache_t* cache_find(int sec)
{
    cache_t* t = NULL;

    ACQUIRE_CACHE;
    HASH_FIND_INT(CACHE_HASH_HEAD, &sec, t);
    RELEASE_CACHE;

    return t;
}

static int cache_delete(int sec)
{
    cache_t* t = NULL;
    int ret = -1;

    if((t = cache_find(sec)) != NULL)
    {
        ACQUIRE_CACHE;
        HASH_DEL(CACHE_HASH_HEAD, t);
        RELEASE_CACHE;
        cache_free(t);
        ret = -ret;
    }
    return ret; 
}


static int cache_reduce_list()
{
    cache_t *t;
    list_entry_t *le, *tmp;
    int index;

    if(cache_manager.capacity < cache_manager.limit) return 0;
    index = 0;
    ACQUIRE_CACHE;
    le  = list_next(CACHE_INVALID_LIST_P);
    while(true) 
    {
        tmp = le;
        //reduce 1/6 lists
        if(le == CACHE_INVALID_LIST_P || index >= cache_manager.invalid_num / 6)
        {
            break;
        }
        le = list_next(le);
        t = list2cache(tmp);
        assert(t->flags == BIT_READ || t->flags == BIT_INVALID || t->flags == BIT_WRITING);
        if(t->flags == BIT_INVALID || t->flags == BIT_READ)
        {
            list_del_init(&t->list);
            RELEASE_CACHE;
            cache_delete(t->sec);
            ACQUIRE_CACHE;
            index ++;
            CACHE_INVALID_NUM_C(-1);
            CACHE_CAPACITY_C(-1);
        }

    }
    RELEASE_CACHE;
//    LOG_CACHE("capacity: %d \n unfsyn : %d \n invalid : %d\n", cache_manager.capacity ,cache_manager.unfsyn_num ,cache_manager.invalid_num);
    return 1;
}
int cache_write(int sec, void *buf)
{
    cache_t *t;
    if((t = cache_find(sec)) != NULL)
    {
        ACQUIRE_CACHE;  
        memcpy(t->buf ,buf ,CACHE_SIZE);
        if(t->flags != BIT_WRITE)
        {
            list_del_init(&t->list);
            list_add_before(CACHE_UNFSYN_LIST_P, &t->list);
            t->flags = BIT_WRITE;
            CACHE_UNFSYN_NUM_C(1);
            CACHE_INVALID_NUM_C(-1);
        }
        RELEASE_CACHE;
    }else{
        t = cache_add(sec , buf, BIT_WRITE);     

        ACQUIRE_CACHE;
        t->flags = BIT_WRITE;
        //insert unfsyn list
        list_add_before(CACHE_UNFSYN_LIST_P, &t->list);
        CACHE_UNFSYN_NUM_C(1);
        CACHE_CAPACITY_C(1);
        RELEASE_CACHE;
    }

    //not write
    //ide_write(buf , sec);
    return 1;
}


int cache_read(int sec, void *buf)
{
    cache_t *t;
    assert(buf && sec >= 0);
    if((t = cache_find(sec)) != NULL) 
    {
        ACQUIRE_CACHE;  
        memcpy(buf ,t->buf ,CACHE_SIZE);
        if(t->flags == BIT_INVALID)
        {

            list_del_init(&t->list);
            list_add_before(CACHE_UNFSYN_LIST_P, &t->list);
            t->flags = BIT_READ;
            CACHE_UNFSYN_NUM_C(1);
            CACHE_INVALID_NUM_C(-1);
        }

        RELEASE_CACHE;
    }else{
        t = cache_add(sec , buf, BIT_READ);

        assert(t && cache_manager.capacity < 8000);
        ide_read(buf, sec * (CACHE_NUM_PER_SEC));
        ACQUIRE_CACHE;
        t->flags = BIT_READ;
        //insert unfsyn list
        list_add_before(CACHE_UNFSYN_LIST_P, &t->list);
        CACHE_UNFSYN_NUM_C(1);
        CACHE_CAPACITY_C(1);
        memcpy(t->buf, buf, CACHE_SIZE);
        RELEASE_CACHE;

    }
    return 1;  
}


int cache_fsyn()
{
    cache_t *t = NULL;
    list_entry_t *le, *tmp;


LABEL_BEGIN: 
    ACQUIRE_CACHE;
    if(t && t->flags == BIT_WRITING)
        t->flags = BIT_INVALID;

    le  = list_next(CACHE_UNFSYN_LIST_P);
    while(true) 
    {
        tmp = le;
        if(le == CACHE_UNFSYN_LIST_P)
            break;
        le = list_next(le);
        t = list2cache(tmp);
        list_del_init(&t->list);
        CACHE_UNFSYN_NUM_C(-1);

        list_add_before(CACHE_INVALID_LIST_P ,&t->list);
        CACHE_INVALID_NUM_C(1);

        if(t->flags & BIT_DIRTY) 
        {
            t->flags = BIT_WRITING;
            RELEASE_CACHE;
            ide_write(t->buf, t->sec * (CACHE_NUM_PER_SEC));
            goto LABEL_BEGIN;
        }else{
            t->flags = BIT_INVALID;  
        }

    }
    RELEASE_CACHE;

    /*
     * maybe will wrong
     FOR_EACH_LIST(CACHE_UNFSYN_LIST_P, le)
     {
     t = list2cache(le);
     ACQUIRE_CACHE;

     list_del_init(t->list);    
     CACHE_UNFSYN_NUM_C(-1);

     list_add_before(CACHE_INVALID_LIST_P ,&t->list);
     CACHE_INVALID_NUM_C(1);

     if(t->flags & BIT_DIRTY)
     {
     t->flags &= ~BIT_DIRTY;
     RELEASE_CACHE;
     ide_write(t->buf, t->sec);            
     ACQUIRE_CACHE;
     }
     t->flags = BIT_INVALID;

     RELEASE_CACHE;
     }
     FOR_EACH_END
     */
    return 0;
}

int cache_tick()
{
    static int interal_tick = 0;
    interal_tick ++;
    cache_manager.tick ++;;
    if(interal_tick == 1000)
    {
        cache_reduce_list();
        interal_tick = 0;
    }
    return 1;
}

