#ifndef _KERN_DEBUG_KDEBUG_H_
#define _KERN_DEBUG_KDEBUG_H_
#include "defs.h"
#include "stabs.h"

void stab_binsearch(struct stab *stabs, int *region_left, int *region_right,
           int type, uint addr);
#endif
