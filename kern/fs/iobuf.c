#include "basic_p.h"
#include "queue.h"
#include "lock_p.h"
#include "kdebug.h"
#include "mm_p.h"
#include "iobuf.h"

/*
struct buf {
  int flags;
  uint dev;
  uint blockno;
  struct sleeplock lock;
  uint refcnt;
  struct buf *prev; // LRU cache list
  struct buf *next;
  struct buf *qnext; // disk queue
  uchar data[BSIZE];
};

#define B_VALID 0x2  // buffer has been read from disk
#define B_DIRTY 0x4  // buffer needs to be written to disk
*/




#define NODE2IOBUF(a) to_struct(a, iobuf, node)  
#define FREE(a) kfree(a)
#define MALLOC(a) kmalloc(a)


#define DEFAULT_ADD_FACTOR 20

iobuf_manager_t iobuf_manager;
#define M_ADD_FACTOR (iobuf_manager.add_factor)


#define LOCK_CALL_IOBUF(x) \
    do{                     \
        ACQUIRE_IOBUF_M(); \
        x;                  \
        RELEASE_IOBUF_M();  \
    }while(0)           

#define PUSH_IOBUF_FREE_QUEUE(a) queue_push(&iobuf_manager.free_queue, &(a->node))
#define POP_IOBUF_FREE_QUEUE() queue_pop(&iobuf_manager.free_queue)
#define SIZE_IOBUF_FREE_QUEUE() queue_size(&iobuf_manager.free_queue)
#define PEEK_IOBUF_FREE_QUEUE() queue_peek(&iobuf_manager.free_queue)


#define PUSH_IOBUF_READY_QUEUE(a) queue_push(&iobuf_manager.ready_queue, &(a->node))
#define POP_IOBUF_READY_QUEUE() queue_pop(&iobuf_manager.ready_queue)
#define SIZE_IOBUF_READY_QUEUE() queue_size(&iobuf_manager.ready_queue)
#define PEEK_IOBUF_READY_QUEUE() queue_peek(&iobuf_manager.ready_queue)



extern iobuf* iobuf_malloc();
inline iobuf* iobuf_malloc()
{
    iobuf *a = MALLOC(sizeof(iobuf));
    assert(a != NULL && IOBUF_SIZE >= 4096);
    a->buf =  MALLOC(IOBUF_SIZE);
    a->flags = 0;
    return a;
}

extern void iobuf_free(iobuf* a);
inline void iobuf_free(iobuf* a)
{
    assert(a); 
    a->flags = 0;
    FREE(a->buf);
    FREE(a); 
}


//analysis_records()
static int analysis_records()
{
    int ret = 0;
    if(SIZE_IOBUF_FREE_QUEUE() == 0 )
    {
        ret = 1;
    }else if(SIZE_IOBUF_FREE_QUEUE() >= DEFAULT_ADD_FACTOR * 3)
    {
        ret =  -(2 * DEFAULT_ADD_FACTOR) ;
    }
    return ret;
}

static void iobuf_adjust_free_queue()
{

    int ret = analysis_records();
    void *tmp;
    iobuf *tmpbuf;
    ACQUIRE_IOBUF_M();
    if(ret >= 0)
    {
        int num = M_ADD_FACTOR * ret;
        iobuf* temp = NULL;

        for(int i = 0 ; i < num ; i ++)
        {
           temp = iobuf_malloc();
           PUSH_IOBUF_FREE_QUEUE(temp);
        }
        
    }else{
        for(int i = 0 ; i < -ret ; i ++)
        {
            tmp = POP_IOBUF_FREE_QUEUE();
            assert(tmp);
            tmpbuf = NODE2IOBUF(tmp);
            iobuf_free(tmpbuf);
        }

    }
    RELEASE_IOBUF_M();
}

int iobuf_acquire_data(void *buf ,int len , uint32_t ndev, uint32_t blockno,int flags)
{
    iobuf *tmp;
    assert(len == IOBUF_SIZE);
    if(flags != B_WRITE || flags != B_READ)
    {
        assert("wrong flags");
    }


    while(SIZE_IOBUF_FREE_QUEUE() == 0)
    {
        iobuf_adjust_free_queue();
    }

    assert(SIZE_IOBUF_FREE_QUEUE() > 0);
    ACQUIRE_IOBUF_M();    
    tmp = NODE2IOBUF(POP_IOBUF_FREE_QUEUE());  
    tmp->dev = ndev;
    tmp->blockno = blockno;
    tmp->flags = flags;
    if(flags == B_WRITE)
        memcpy(tmp->buf ,buf ,len);
    PUSH_IOBUF_READY_QUEUE(tmp); 

    RELEASE_IOBUF_M();
    return 0;
}

int iobuf_release_data()
{

    ACQUIRE_IOBUF_M();
    if(iobuf_manager.cur_iobuf != NULL)
    {
        iobuf_manager.cur_iobuf->flags = B_OK;
        PUSH_IOBUF_FREE_QUEUE(iobuf_manager.cur_iobuf);
        iobuf_manager.cur_iobuf = NULL;
    }
    RELEASE_IOBUF_M();
    return 0;
}

iobuf* iobuf_deal_next_data()
{
    if(SIZE_IOBUF_READY_QUEUE() == 0) 
        return NULL;
    iobuf *tmp;
    ACQUIRE_IOBUF_M();
    
    tmp = NODE2IOBUF(POP_IOBUF_READY_QUEUE());  

    if(iobuf_manager.cur_iobuf != NULL)
    {
        iobuf_manager.cur_iobuf->flags = B_OK;
        PUSH_IOBUF_FREE_QUEUE(iobuf_manager.cur_iobuf);
        iobuf_manager.cur_iobuf = NULL;
    }

    iobuf_manager.cur_iobuf = tmp; 

    RELEASE_IOBUF_M();
    return tmp;
}




void iobuf_manager_init()
{
    queue_init(&iobuf_manager.free_queue);
    queue_init(&iobuf_manager.ready_queue);
    iobuf_manager.cur_iobuf = NULL;
    iobuf_manager.add_factor = DEFAULT_ADD_FACTOR;
    
    init_lock(&iobuf_manager.lock, "iobuf_manager");
    iobuf_adjust_free_queue();
}


