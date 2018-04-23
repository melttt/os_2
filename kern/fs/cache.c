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
#include "cache.h"
#include "proc.h"
#include "cpu.h"
#include "lock_p.h"

#define LOG_CACHE(x, ...)  cprintf(x, ##__VA_ARGS__)
#define CACHE_SIZE FS_BUF_SIZE
#define CACHE_NUM_PER_SEC (CACHE_SIZE / SEC_SIZE) 

#define BIT_VALID 1
#define BIT_INVALID 0
#define BIT_BABY 2
#define NON_PID 0xff
typedef struct{
    uint32_t using_pid;
    struct sleeplock lock;

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
    list_entry_t invalid_list;
    int invalid_num;
    struct spinlock lock; 
    cache_t* UT_hash_head; 
    list_entry_t arr_list[MAX_PROC];
}_cache_manager;

static _cache_manager cache_manager; 
#define CACHE_CAPACITY_C(a) (cache_manager.capacity += a)
#define CACHE_HASH_HEAD (cache_manager.UT_hash_head)

#define CACHE_INVALID_NUM_C(a) (cache_manager.invalid_num += a)
#define CACHE_INVALID_LIST_P (&cache_manager.invalid_list)
#define CACHE_LOCK (&cache_manager.lock)
#define ACQUIRE_CACHE acquire(CACHE_LOCK)
#define RELEASE_CACHE release(CACHE_LOCK)

#define CACHE_LIST(a) (&cache_manager.arr_list[a])

list_entry_t* get_list()
{
    return CACHE_LIST(CUR_PROC->pid);
}

int cache_init()
{
    ideinit();
    cache_manager.limit = DEFAULT_LIMIT ;
    cache_manager.capacity = 0; 
    cache_manager.tick = 0;

    list_init(CACHE_INVALID_LIST_P);
    cache_manager.invalid_num = 0;

    init_lock(CACHE_LOCK ,"cache lock");
    CACHE_HASH_HEAD = NULL;
    for(int i = 0 ; i < MAX_PROC ; i ++)
    {
        list_init(CACHE_LIST(i));
    }

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
    t->using_pid = NON_PID;
    initsleeplock(&t->lock , "sleeplock");

    return t; 
}

static void cache_free(cache_t *t)
{
    if(holdingsleep(&t->lock))
        releasesleep(&t->lock);

    kfree(t->buf);
    kfree(t);
}


static cache_t* cache_add(int sec)
{
    cache_t* t = cache_malloc(); 
    assert(t);

    t->sec = sec;
    t->flags = BIT_BABY;
    list_init(&t->list);
    ACQUIRE_CACHE; 
    HASH_ADD_INT(CACHE_HASH_HEAD, sec, t); 
    CACHE_CAPACITY_C(1);
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
        CACHE_CAPACITY_C(-1);
        RELEASE_CACHE;
        cache_free(t);
        ret = -ret;
    }
    return ret; 
}

#define DEFAULT_REDUCE 1000
static int cache_reduce_list()
{
    cache_t *t;
    list_entry_t *le, *tmp;
    int index;
    int reduce_nums;

    if(cache_manager.capacity < cache_manager.limit) return 0;
    index = 0;
    reduce_nums = cache_manager.invalid_num / 5 ;

    //reduce invalid
    ACQUIRE_CACHE;
    le  = list_next(CACHE_INVALID_LIST_P);
    while(true) 
    {
        tmp = le;
        //reduce 1/5 lists
        if(le == CACHE_INVALID_LIST_P || index >= reduce_nums)
        {
            break;
        }
        le = list_next(le);
        t = list2cache(tmp);
        assert(t->flags == BIT_INVALID);

        list_del_init(&t->list);
        CACHE_INVALID_NUM_C(-1);

        RELEASE_CACHE;
        cache_delete(t->sec);
        ACQUIRE_CACHE;

        index ++;
    }

    RELEASE_CACHE;
//    LOG_CACHE("capacity: %d \n unfsyn : %d \n invalid : %d\n", cache_manager.capacity ,cache_manager.unfsyn_num ,cache_manager.invalid_num);
    return 1;
}

void* mapping_file(uint sec ,uint off)
{
    cache_t *t;
    void *ret = NULL;
    assert(off >= 0 && off < CACHE_SIZE);
    if((t = cache_find(sec)) == NULL)
    {
        t = cache_add(sec);
        assert(t && cache_manager.capacity <= 8000);
        ide_read(t->buf ,t->sec *(CACHE_NUM_PER_SEC));
        t->using_pid = CUR_PROC->pid;
    }

    if((t->flags != BIT_VALID ) || (t->flags == BIT_VALID && CUR_PROC->pid != t->using_pid))
        acquiresleep(&t->lock);

    t->using_pid = CUR_PROC->pid;
    ACQUIRE_CACHE;  
    if(t->flags == BIT_INVALID || t->flags == BIT_BABY)
    {
        if(t->flags == BIT_INVALID)
            CACHE_INVALID_NUM_C(-1);

        list_del_init(&t->list);
        list_add_before(get_list(), &t->list);
        t->flags = BIT_VALID;
    }
    ret = ((char*)t->buf + off);
    RELEASE_CACHE;

    return ret;
}




int begin_cache()
{
    list_entry_t  *list = CACHE_LIST(CUR_PROC->pid);    
    
    if(!list_empty(list))
    {
        cache_t * x = list2cache(list->next);
        panic("x->sec : %d", x->sec);
    }
    return 1;
}




int end_cache()
{
    list_entry_t *tmp, *next, *list = CACHE_LIST(CUR_PROC->pid);    
    cache_t *cache;
    int i = 0;
    
    for(next = list_next(list) ; next != list ;  )
    {
        tmp = next;
        next = list_next(next);

        list_del_init(tmp);
        cache = list2cache(tmp);
        assert(cache->flags == BIT_VALID);
        assert(holdingsleep(&cache->lock));
        cache->using_pid = NON_PID;
        cache->flags = BIT_INVALID;
        ide_write(cache->buf, cache->sec * (CACHE_NUM_PER_SEC));
        ACQUIRE_CACHE;
        CACHE_INVALID_NUM_C(1);
        list_add_before(CACHE_INVALID_LIST_P, tmp);
        RELEASE_CACHE;
        releasesleep(&cache->lock);
        i ++;
    }
    assert(list_empty(list));
    return 1;

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

