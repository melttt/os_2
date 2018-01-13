#include "defs.h"
#include "param.h"
#include "uart.h"
#include "console.h"
#include "syscall.h"

int
sys_put(void)
{
    int ch;
    argint(0, &ch);
    putc_cons(ch);
    putc_uart(ch);
    return 0;
}



