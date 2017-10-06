#ifndef _LIBS_STDIO_H_
#define _LIBS_STDIO_H_
#include "defs.h"
#include "stdarg.h"
int vprintfmt(void (*putch)(char), const char *fmt, va_list ap);

int cprintf(const char *fmt, ...);
int vcprintf(const char *fmt, va_list ap);
#endif
