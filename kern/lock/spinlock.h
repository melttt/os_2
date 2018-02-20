#ifndef _KERN_LOCK_H_
#define _KERN_LOCK_H_
#include "defs.h"

struct spinlock {
  uint32_t locked;       // Is the lock held?
  const char *name;        // Name of lock.
  size_t cpu;        // The cpu holding the lock.
};

void push_cli(void);
void pop_cli(void);
void
init_lock(struct spinlock *lk,const char *name);
void
acquire(struct spinlock *lk);

void
release(struct spinlock *lk);
bool 
holding(struct spinlock *lock);
#endif
