#include "defs.h"
#include "param.h"
#include "syscall.h"
#include "proc.h"
#include "cpu.h"
#include "stdio.h"

extern int sys_put(void);
extern int sys_exec(void);
/*
extern int sys_chdir(void);
extern int sys_close(void);
extern int sys_dup(void);
//extern int sys_exec(void);
extern int sys_exit(void);
extern int sys_fork(void);
extern int sys_fstat(void);
extern int sys_getpid(void);
extern int sys_kill(void);
extern int sys_link(void);
extern int sys_mkdir(void);
extern int sys_mknod(void);
extern int sys_open(void);
extern int sys_pipe(void);
extern int sys_read(void);
extern int sys_sbrk(void);
extern int sys_sleep(void);
extern int sys_unlink(void);
extern int sys_wait(void);
extern int sys_write(void);
extern int sys_uptime(void);
*/

static int (*syscalls[])(void) = {
    /*
[SYS_fork]    sys_fork,
[SYS_exit]    sys_exit,
[SYS_wait]    sys_wait,
[SYS_pipe]    sys_pipe,
[SYS_read]    sys_read,
[SYS_kill]    sys_kill,
//[SYS_exec]    sys_exec,
[SYS_fstat]   sys_fstat,
[SYS_chdir]   sys_chdir,
[SYS_dup]     sys_dup,
[SYS_getpid]  sys_getpid,
[SYS_sbrk]    sys_sbrk,
[SYS_sleep]   sys_sleep,
[SYS_uptime]  sys_uptime,
[SYS_open]    sys_open,
[SYS_write]   sys_write,
[SYS_mknod]   sys_mknod,
[SYS_unlink]  sys_unlink,
[SYS_link]    sys_link,
[SYS_mkdir]   sys_mkdir,
[SYS_close]   sys_close,
*/
[SYS_exec]    sys_exec,
[SYS_put]   sys_put,
};

int 
sys_exec()
{
    extern char _binary___user_user_test_start[];
    extern char _binary___user_user_test_size[];
    cprintf("sys_exec()\n");
    do_execve(" ", 1, (unsigned char*)_binary___user_user_test_start, (size_t)_binary___user_user_test_size);
    return 0;
}
void
syscall()
{
    int num;
    num = cpus[get_cpu()].cur_proc->tf->eax;
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
        cpus[get_cpu()].cur_proc->tf->eax= syscalls[num]();
    } else {
        cprintf("%d %s: unknown sys call %d\n",
                proc->pid, proc->name, num);
        proc->tf->eax = -1;
    }
}

int
argint(int n, int *ip)
{
   *ip = cpus[get_cpu()].cur_proc->tf->ebx;
   return 0;//cpus[get_cpu()].cur_proc->tf->ebx;
//    return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
/*
int
fetchint(uint32_t addr, int *ip)
{
    //!!!check addr
    *ip = *(int*)(addr);
    return 0;
}
*/
