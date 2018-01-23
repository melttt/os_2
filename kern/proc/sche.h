#ifndef _KERN_PROC_SCHE_H_
#define _KERN_PROC_SCHE_H_

#include "basic_p.h"


struct proc* get_proc();

bool put_proc(struct proc *proc);

void init_sche();

void sche();
#endif
