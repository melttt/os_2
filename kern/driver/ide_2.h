#ifndef __KERN_DRIVER_IDE_2_H_
#define __KERN_DRIVER_IDE_2_H_
// Simple PIO-based (non-DMA) IDE driver code.

#include "iobuf.h"
void ideinit(void);
void idestart(iobuf* buf);
void ideintr(void);
int iderw(void *b, int len, int blockn, int flags);
#endif
