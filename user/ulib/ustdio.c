#include "ustdio.h"
#include "syslib.h"


int uprintf(const char *fmt, ...)
{
    va_list ap;
    int cnt;
    va_start(ap, fmt);
    cnt = vprintfmt(put,fmt,ap);
    va_end(ap);
    return cnt;
}
