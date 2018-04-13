#ifndef __KERN_DRIVER_IDE_2_H_
#define __KERN_DRIVER_IDE_2_H_
// Simple PIO-based (non-DMA) IDE driver code.


void ideinit(void);
void ideintr(void);

int ide_read(void *b, int blockn);
int ide_write(void *b, int blockn);
#endif
