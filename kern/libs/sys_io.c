#include "defs.h"
#include "param.h"
#include "uart.h"
#include "console.h"
#include "syscall.h"
#include "stdio.h"
#include "cpu.h"


int
sys_put(void)
{
    int ch;
    ch = get_arg_char(0);
    putc_cons(ch);
    putc_uart(ch);
    return 0;
}



