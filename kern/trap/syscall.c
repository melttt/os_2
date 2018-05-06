#include "defs.h"
#include "param.h"
#include "syscall.h"
#include "proc.h"
#include "cpu.h"
#include "stdio.h"
#include "kbd.h"
#include "kmalloc.h"
#include "ext.h"
#include "inode.h"

extern int sys_put(void);
extern int sys_exec(void);
extern int sys_exit(void);
extern int sys_pid(void);
extern int sys_test(void);
extern int sys_fork(void);
extern int sys_wait(void);
extern int sys_getchar(void);
extern int sys_ls(void);
extern int sys_get_dirent(void);
extern int sys_mkdir(void);
extern int sys_chdir(void);
extern int sys_createfile(void);
/*
extern int sys_chdir(void);
extern int sys_close(void);
extern int sys_dup(void);
//extern int sys_exec(void);
extern int sys_exit(void);
//extern int sys_fork(void);
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
//extern int sys_wait(void);
extern int sys_write(void);
extern int sys_uptime(void);
*/

static int (*syscalls[])(void) = {
    /*
//[SYS_exit]    sys_exit,
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
[SYS_getchar] sys_getchar,
[SYS_wait]    sys_wait,
[SYS_fork]    sys_fork,
[SYS_exit]    sys_exit,
[SYS_exec]    sys_exec,
[SYS_put]   sys_put,
[SYS_pid]  sys_pid,
[SYS_test] sys_test,
[SYS_ls] sys_ls,
[SYS_get_dirent] sys_get_dirent,
[SYS_mkdir] sys_mkdir,
[SYS_chdir] sys_chdir,
[SYS_createfile] sys_createfile,
};



int sys_createfile(void)
{
    char *name = (char*)get_arg_ptr(0);
    minode *curdir = get_cur_inode();
    kcreate(curdir , name, INODE_TYPE_FILE);
    SYNC_DISK();
    return 1;
}

int sys_chdir(void)
{
    char *name = (char*)get_arg_ptr(0);
    minode *curdir = get_cur_inode(), *newch = NULL;
    if((newch = dirent_lookup(curdir, name)) == NULL)
    {
        cprintf("no such dir\n", name);
        return -1;
    }
    CUR_PROC->cur_inode = *newch;
    SYNC_DISK();
    return 1;
}

int sys_mkdir(void)
{
    char *name = (char*)get_arg_ptr(0);
    minode *curdir = get_cur_inode();
    kcreate(curdir , name, INODE_TYPE_DIR);


    SYNC_DISK();
    return 1;
}
int sys_get_dirent(void)
{
    char *buff = (char*)get_arg_ptr(0);
    int len = get_arg_int(1);
    minode *root = get_cur_inode();
    len = dirent_list(root ,buff , len);
    SYNC_DISK();
    return len;
}

int sys_ls(void)
{
    return 1;
}
int 
sys_exec()
{
    char *name = (char*)get_arg_ptr(0);
    int len = strlen(name);
    char *filemm;
    int file_len;

    minode *root = get_cur_inode();
    file* a = kopen(root , name, 0);
    if(a == NULL) return -1;
    file_len =  a->disk_inode.data.size;
    filemm = kmalloc(a->disk_inode.data.size);
    kread(a, filemm, file_len );
    kclose(a);

    int ret = do_execve(name, len, filemm, file_len);
    return ret;
}

int sys_getchar()
{
    return get_char(); 

}
int 
sys_exit()
{
    int a = get_arg_int(0);
    do_exit(a); 
    return 0;
}

int 
sys_wait()
{
    return do_wait();
}
void
syscall()
{
    int num;
    num = CUR_PROC->tf->eax;
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
        cpus[get_cpu()].cur_proc->tf->eax= syscalls[num]();
    } else {
        cprintf("unknown sys call\n");
    }
}


int sys_pid(void)
{
    static int pidarr[5] ={0};
    pidarr[CUR_PROC->pid] ++;
    //cprintf("pid:%x\n",CUR_PROC->pid);
    cprintf("pid_2:%x,pid_3:%x,pid_4:%x\n", pidarr[2], pidarr[3], pidarr[4] );
    return 0;
}

int sys_fork(void)
{
    struct trapframe *tf = CUR_PROC->tf;
    uintptr_t stack = tf->esp;
    cprintf("do_fork\n");
    return do_fork(0, stack, tf);
}
//int sys_test(int a, int *b, char *c, char d, short e)
int sys_test(void)
{
    char a = get_arg_char(0);
    char b = get_arg_char(1);
    char c = get_arg_char(2);
    char d = get_arg_char(3);
    short e = get_arg_short(4);

    cprintf("a:%c, b:%c, c:%c, d:%c, e:%d\n ", a, b, c, d, e);
    return 0;
}


static void* get_arg_addr(int n)
{
    return (void*)(CUR_PROC->tf->ebp + 8 + 4*n);
}

int get_arg_int(int n)
{
    return *((int*)get_arg_addr(n));
}

char get_arg_char(int n)
{
    return *((char*)get_arg_addr(n));
}

short get_arg_short(int n)
{
    return *((short*)get_arg_addr(n));
}

void* get_arg_ptr(int n)
{
    return *((void**)get_arg_addr(n));
}

