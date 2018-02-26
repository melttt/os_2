#ifndef __KERN_TRAP_SYSCALL_H_
#define __KERN_TRAP_SYSCALL_H_
#include "defs.h"
#include "param.h"
#include "sys_call_num.h"
void syscall();
int get_arg_int(int n);
char get_arg_char(int n);
short get_arg_short(int n);
void* get_arg_ptr(int n);


#endif
