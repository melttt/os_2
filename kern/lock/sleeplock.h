#ifndef _KERN_LOCK_SLEEPLOCK_H_
#define _KERN_LOCK_SLEEPLOCK_H_
#include "basic_p.h"
#include "spinlock.h"
// Long-term locks for processes
struct sleeplock {
  bool locked;       // Is the lock held?
  struct spinlock lk; // spinlock protecting this sleep lock
  
  // For debugging:
  char *name;        // Name of lock.
  int pid;           // Process holding lock
};

#endif
