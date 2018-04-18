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

void
initsleeplock(struct sleeplock *lk, char *name);
void
acquiresleep(struct sleeplock *lk);
void
releasesleep(struct sleeplock *lk);
bool
holdingsleep(struct sleeplock *lk);
#endif
