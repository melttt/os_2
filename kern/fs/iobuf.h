#ifndef __KERN_FS_IOBUF_H_
#define __KERN_FS_IOBUF_H_
#include "defs.h"
#include "queue.h"

typedef struct{
    volatile int flags; 
    uint32_t dev;
    uint32_t blockno;
    uint32_t buf_len;
    uint8_t *buf;//[IOBUF_SIZE];
    uint8_t *read_buf;
    QueueNode node;
}iobuf;

#define HISTORY_RECODE_LEN  10
typedef struct{
    Queue free_queue;
    Queue ready_queue;
    iobuf *cur_iobuf;

    int add_factor;
    struct spinlock lock;

    //history records
    int history_records[HISTORY_RECODE_LEN];

}iobuf_manager_t;

extern iobuf_manager_t iobuf_manager;

#define B_OK 0x1
#define B_READ 0x2  // buffer has been read from disk
#define B_WRITE 0x4  // buffer needs to be written to disk



#define IOBUF_LOCK (&(iobuf_manager.lock))
#define ACQUIRE_IOBUF_M() (acquire(IOBUF_LOCK))
#define RELEASE_IOBUF_M() (release(IOBUF_LOCK))
#define IOBUF_SIZE FS_BUF_SIZE
#define CUR_IOBUF (iobuf_manager.cur_iobuf)

void iobuf_manager_init();
iobuf* iobuf_acquire_data(void *buf ,int len , uint32_t ndev, uint32_t blockno,int flags);
iobuf* iobuf_deal_next_data();


#endif
