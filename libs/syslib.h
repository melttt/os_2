#ifndef _USER_ULIB_ULIB_H_
#define _USER_ULIB_ULIB_H_

#ifndef T_SYSCALL
#define T_SYSCALL 64
#endif
#include "defs.h"
int put(char);
int exit(int status);
int fork();
int show_pid(void);
int user_test(char a, char b, char c, char d, short e);
int exec(char *name, size_t len, char *binary, size_t size);
int wait(void);
int getchar(void);
#endif
