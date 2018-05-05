#ifndef _USER_ULIB_ULIB_H_
#define _USER_ULIB_ULIB_H_

#ifndef T_SYSCALL
#define T_SYSCALL 64
#endif
#include "defs.h"
int ls(void);
void put(char);
int exit(int status);
int fork();
int show_pid(void);
int user_test(char a, char b, char c, char d, short e);
int exec(char *name);
int wait(void);
int getchar(void);
#endif
