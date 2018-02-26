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
//    cprintf("sys_put:%x, %c\n", CUR_PROC->tf->ebp + 8, (char)(*(int*)(CUR_PROC->tf->ebp + 8)));
    ch = get_arg_char(0);

    putc_cons(ch);
    putc_uart(ch);
    return 0;
}



