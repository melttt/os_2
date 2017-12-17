#ifndef __KERN_MM_KMALLOC_H_
#define __KERN_MM_KMALLOC_H_
#include "defs.h"
#include "slab.h"
void init_slab_allocator():
void kfree(void *n);
void* kmalloc(int32_t n)
#endif
