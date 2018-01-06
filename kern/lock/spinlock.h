#ifndef _KERN_LOCK_H_
#define _KERN_LOCK_H_
#include "defs.h"
#include "proc.h"    //cpu struct

struct spinlock {
  uint32_t locked;       // Is the lock held?
  char *name;        // Name of lock.
  size_t cpu;        // The cpu holding the lock.
};

void
init_lock(struct spinlock *lk, char *name);
void
acquire(struct spinlock *lk);

void
release(struct spinlock *lk);
bool 
holding(struct spinlock *lock);
#endif
