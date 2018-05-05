#include "basic_p.h"
#include "syslib.h"
#include "sys_call_num.h"

#define SYSCALL(name, ret) \
    asm volatile(                   \
            "int %1;"               \
            : "=a" (ret)                       \
            : "i" (T_SYSCALL),"a" (SYS_ ## name)    \
            : "memory")                            


int ls(void)
{
    int ret;
    SYSCALL(ls, ret);
    return ret;
}
int getchar(void)
{
    int ret;
    SYSCALL(getchar,ret);
    return ret;
}
void put(char c)
{
    int ret;
    SYSCALL(put, ret);
}
int exit(int status)
{
    int ret;
    SYSCALL(exit, ret);
    return ret;
}
int show_pid(void)
{
    int ret;
    SYSCALL(pid, ret);
    return ret;
}
int user_test(char a, char b, char c, char d, short e)
{
    int ret;
    SYSCALL(test, ret);
    return ret;
}

int fork()
{
    int ret;
    SYSCALL(fork, ret);
    return ret;
}

int exec(char *name)
{
    int ret;
    SYSCALL(exec, ret);
    return ret;
}

int wait()
{
    int ret;
    SYSCALL(wait, ret);
    return ret;
}
