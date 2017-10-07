#ifndef _KERN_DEBUG_KDEBUG_H_
#define _KERN_DEBUG_KDEBUG_H_
#include "defs.h"
#include "stabs.h"

void print_stack_trace();
void print_cur_status();
void  __panic(const char *file, int line, const char *fmt, ...);

#define panic(...)     \
    __panic(__FILE__, __LINE__, __VA_ARGS__)

#define assert(x)                                  \
    do{                                            \
        if(!(x))                                   \
        {                                          \
            panic("assertion failed :%s ",#x);     \
        }                                          \
    }while(0)                                     


    
#endif
