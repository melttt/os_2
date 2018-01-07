#ifndef _KERN_SMP_LAPIC_H_
#define _KERN_SMP_LAPIC_H_
#include "defs.h"


void
lapicinit(void);

void
lapicstartap(uint8_t, uint32_t);

void
lapiceoi(void);

int
lapicid(void);




#endif
