#if 0
#include "defs.h"
#include "stdio.h"
#include "stdarg.h"
#include "string.h"
#include "console.h"
#include "uart.h"

static void putch(char ch)
{
   console_putc(ch); 
   uartputc(ch);
}

int vcprintf(const char *fmt, va_list ap)
{
    return vprintfmt(putch,fmt,ap);
}
int cprintf(const char *fmt, ...)
{
    va_list ap;
    int cnt;
    va_start(ap, fmt);
    cnt = vprintfmt(putch,fmt,ap);
    va_end(ap);
    return cnt;
}
#endif
