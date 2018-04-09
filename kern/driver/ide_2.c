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

#define SECTOR_SIZE   512

#define IDE_BSY       0x80
#define IDE_DRDY      0x40
#define IDE_DF        0x20
#define IDE_ERR       0x01

#define IDE_CMD_READ  0x20
#define IDE_CMD_WRITE 0x30
#define IDE_CMD_RDMUL 0xc4
#define IDE_CMD_WRMUL 0xc5


static struct spinlock idelock;
int havedisk1;

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

    init_lock(&idelock, "ide");
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







// Start the request for b.  Caller must hold idelock.
void
idestart(void* buf)
{
    if(buf == 0)
        panic("idestart");
    /*
       if(b->blockno >= FSSIZE)
       panic("incorrect blockno");
       */
    //  int sector_per_block =  1;
    int sector = 1;//b->blockno * sector_per_block;
    //int read_cmd =  IDE_CMD_READ;// :  IDE_CMD_RDMUL;
    int write_cmd =  IDE_CMD_WRITE;// : IDE_CMD_WRMUL;
    //if (sector_per_block > 7) panic("idestart");

    idewait(0);
    outb(0x3f6, 0);  // generate interrupt
    outb(0x1f2, 8);  // number of sectors
    outb(0x1f3, sector & 0xff);
    outb(0x1f4, (sector >> 8) & 0xff);
    outb(0x1f5, (sector >> 16) & 0xff);
    outb(0x1f6, 0xe0 | ((1/*b->dev*/&1)<<4) | ((sector>>24)&0x0f));
    outb(0x1f7, write_cmd);
    outsl(0x1f0, buf, 4096/4);

/*
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
  */
}


// Interrupt handler.
void
ideintr(void)
{
    cprintf("ideintr\n");

}


/*
void
iderw(struct buf *b)
{
  struct buf **pp;

 // if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
 // if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
 // if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
    ;

  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
}

*/
