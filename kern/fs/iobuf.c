#include "basic_p.h"
#include "queue.h"
#include "lock_p.h"
#include "kdebug.h"


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

#define B_VALID 0x2  // buffer has been read from disk
#define B_DIRTY 0x4  // buffer needs to be written to disk

#define IOBUF_SIZE 4096
typedef struct{
    int flags; 
    uint32_t dev;
    uint32_t blockno;
    uint8_t buf[IOBUF_SIZE];
    uint32_t buf_len;
    struct sleeplock slock;
    QueueNode node;
}iobuf;


void iobuf_init(iobuf *n)
{
    //init_queue;
    assert(n);
}











































