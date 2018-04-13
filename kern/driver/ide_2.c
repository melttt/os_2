#include "basic_p.h"
#include "stdio.h"
#include "arch_p.h"
#include "mm_p.h"
#include "smp_p.h"
#include "kdebug.h"
#include "lock_p.h"
#include "param.h"

#include "proc.h"
#include "trap.h"
#include "ioapic.h"
#include "iobuf.h"

#define SECTOR_SIZE   512

#define IDE_BSY       0x80
#define IDE_DRDY      0x40
#define IDE_DF        0x20
#define IDE_ERR       0x01

#define IDE_CMD_READ  0x20
#define IDE_CMD_WRITE 0x30
#define IDE_CMD_RDMUL 0xc4
#define IDE_CMD_WRMUL 0xc5

#define DEFAULT_DEV 1

int havedisk1;

extern int
iderw(void *b, int len, int blockn , int flags);

static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
    return -1;
  return 0;
}


void
ideinit(void)
{
    int i;

    iobuf_manager_init();

    ioapicenable(IRQ_IDE0, 0);
    idewait(0);

    // Check if disk 1 is present
    outb(0x1f6, 0xe0 | (1<<4));
    for(i=0; i<1000; i++){
        if(inb(0x1f7) != 0){
            havedisk1 = 1;
            break;
        }
    }

    // Switch back to disk 0.
    outb(0x1f6, 0xe0 | (0<<4));
    cprintf("havedisk : %d\n", havedisk1);
}

int debug_start;
// Start the request for b.  Caller must hold idelock.
static void
idestart(iobuf* buf)
{
    if(buf == NULL)
        panic("idestart");
    /*
       if(b->blockno >= FSSIZE)
       panic("incorrect blockno");
       */
    //  int sector_per_block =  1;
    ACQUIRE_IOBUF_M();

    int sector = buf->blockno;

    //note !!!
    int read_cmd =  IDE_CMD_RDMUL;// :  IDE_CMD_RDMUL;
    int write_cmd =  IDE_CMD_WRMUL ; //buf->flags ; : IDE_CMD_WRMUL;
    //if (sector_per_block > 7) panic("idestart");

    idewait(0);
    outb(0x3f6, 0);  // generate interrupt
    outb(0x1f2, 8);  // number of sectors
    outb(0x1f3, sector & 0xff);
    outb(0x1f4, (sector >> 8) & 0xff);
    outb(0x1f5, (sector >> 16) & 0xff);
    outb(0x1f6, 0xe0 | ((DEFAULT_DEV&1)<<4) | ((sector>>24)&0x0f));

    if(buf->flags == B_WRITE)
    {
        outb(0x1f7, write_cmd);
        outsl(0x1f0, buf->buf, IOBUF_SIZE/4);
    }else if(buf->flags == B_READ)
    {
        outb(0x1f7, read_cmd);
    }
    debug_start = buf->blockno;
    RELEASE_IOBUF_M();
}


// Interrupt handler.
void
ideintr(void)
{
    if(idewait(1) >= 0 && CUR_IOBUF->flags == B_READ)
        insl(0x1f0, CUR_IOBUF->buf , IOBUF_SIZE/4);
    wakeup(CUR_IOBUF);
    iobuf *tmp = iobuf_deal_next_data();
    if(tmp)
        idestart((iobuf*)tmp);
}





int
iderw(void *b, int len, int blockn, int flags)
{

    iobuf *tmp;
    assert(len == IOBUF_SIZE);
    if((flags & (B_WRITE|B_READ)) == 0)
        panic("iderw: nothing to do");
    if(!havedisk1)
        panic("iderw: ide disk 1 not present");

    iobuf_acquire_data(b ,len , DEFAULT_DEV, blockn ,flags);
    // Append b to idequeue.
    ACQUIRE_IOBUF_M();

    tmp = CUR_IOBUF;
    // Start disk if necessary.
    if(tmp != NULL)
    {
        RELEASE_IOBUF_M();
        idestart((iobuf*)tmp);
        ACQUIRE_IOBUF_M();
    }
    // Wait for request to finish.
    assert(tmp != NULL);
    while(tmp->flags != B_OK){
        sleep(tmp, IOBUF_LOCK);
    }

    RELEASE_IOBUF_M();
    return 1;
}

int
ide_read(void *b, int blockn)
{
    //do sth 
    return iderw(b, IOBUF_SIZE, blockn, B_READ);    
}
int
ide_write(void *b, int blockn)
{
    //do sth 
    return iderw(b ,IOBUF_SIZE, blockn, B_WRITE);
}
