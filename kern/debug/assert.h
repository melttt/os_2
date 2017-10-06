#ifndef _KERN_DEBUG_ASSERT_H_
#define _KERN_DEBUG_ASSERT_H_
#include "defs.h"

void __noreturn __panic(const char *file, int line, const char *fmt, ...);
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
