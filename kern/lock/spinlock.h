#ifndef _KERN_LOCK_H_
#define _KERN_LOCK_H_
#include "defs.h"
#include "proc.h"    //cpu struct

struct spinlock {
  uint32_t locked;       // Is the lock held?
 
  char *name;        // Name of lock.
  struct cpu *cpu;   // The cpu holding the lock.
};



#endif
