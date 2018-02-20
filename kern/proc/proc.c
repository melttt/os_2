#include "basic_p.h"
#include "driver_p.h"
#include "lock_p.h"
#include "mm_p.h"
#include "smp_p.h"
#include "arch_p.h"

#include "list.h"
#include "kdebug.h"
#include "string.h"
#include "error.h"
#include "stdio.h"
#include "syscall.h"
#include "trap.h"
#include "elf.h"
#include "cfs.h"
#include "proc.h"
#include "sche.h"


struct proc_manager proc_manager;
static void init_proc_manager()
{
    init_lock(&proc_manager.lock, "proc_manager");
    proc_manager.cur_use_pid = 0;
    proc_manager.init_proc = NULL;
    proc_manager.idle_proc = NULL;
}
static uint32_t
get_pid_2()
{
    uint32_t ret;
    PROCM_ACQUIRE;
    ret = proc_manager.cur_use_pid ++;
    PROCM_RELEASE;
    return ret;
}


static struct proc*
alloc_proc(void)
{
    struct proc *proc = kmalloc(sizeof(struct proc));
    if(proc)
    {
        memset(proc->name, 0, sizeof(proc->name));
        proc->state = EMBRYO;
        proc->pid = -1;
        proc->exit_code = 0;
        proc->parent = NULL;
        proc->context = NULL;
        proc->tf = NULL;
        proc->pgdir = NULL;
        proc->kstack = NULL;
        proc->mm = NULL;
        proc->wait_state = WT_NO;
        list_init(&proc->elm);
        list_init(&proc->child);
        list_init(&proc->plink);
        init_se(&(proc->se), MIN_PRIO);
    }
    return proc;
}

bool
add_child(struct proc* parent, struct proc* child)
{
    assert(parent && child);
    list_del_init(&child->plink); 
    child->parent = parent;
    list_add_before(&parent->child, &child->plink);
    return true;
}
void
make_proc_runable(struct proc *proc) {
    assert(proc->state != RUNNABLE && proc->state != ZOMBIE);
    proc->state = RUNNABLE;
    put_proc(proc); 
}

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
void
forkret(void) {
    //traprets(current->tf);
    PROCM_RELEASE;
}
// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc *proc, uintptr_t esp, struct trapframe *tf) {
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZES) - 1;
    *(proc->tf) = *tf;
    proc->tf->eax = 0;
    proc->tf->esp = esp;//(int)(proc->kstack + PGSIZE);
    proc->tf->eflags |= FL_IF;
    extern char __traprets[];
    *((int*)(proc->tf) - 1) = (int)__traprets;
    proc->context = (struct context*)((int*)(proc->tf) - 1) - 1;
    proc->context->eip = (uintptr_t)forkret;
}

/* do_fork -     parent process for a new child process
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc *proc;
    if (get_proc_num() >= MAX_PROC) {
        goto fork_out;
    }

    ret = -E_NO_MEM;
    if ((proc = alloc_proc()) == NULL) {
        goto fork_out;
    }

    add_child(CUR_PROC, proc);
    if ((proc->kstack = kmalloc(KSTACKSIZES)) == NULL) {
        goto bad_fork_cleanup_proc;
    }

    if (mm_copy(clone_flags, proc) != 0) {
        goto bad_fork_cleanup_kstack;
    }

    proc->pgdir = proc->parent->pgdir;
    copy_thread(proc, stack, tf);
    proc->pid = get_pid_2();
    set_proc_prio(proc, get_proc_prio(proc->parent));
    make_proc_runable(proc);

    ret = proc->pid;
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
    tf.cs = SEG_KCODE << 3;
    tf.ds = tf.es = tf.ss = SEG_KDATA << 3;
    tf.ebx = (uint32_t)fn;
    tf.edx = (uint32_t)arg;
    extern char kernel_thread_entry[];
    tf.eip = (uint32_t)kernel_thread_entry;
    return do_fork(clone_flags, 0, &tf);
}
// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
    struct proc *current = CUR_PROC;
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, "init");
    cprintf("To U: \"%s\".\n", (const char *)arg);
    asm volatile (
            "int %0;"
            : 
            : "i" (T_SYSCALL),"b" ('q'),"a" (SYS_put)
            : "memory");
    assert(cfs->nr_running == 1);
    while(1);
    /*
    size_t before = nr_free_pages();
    int pid = kernel_thread(user_main, "first USER program", 0);
    cprintf("CUR_PID : %d\n", current->pid);
    if (pid <= 0) {
        panic("create first USER failed.\n");
    }
    sche();

    struct proc* chi = find_proc(2);
    cprintf("pid == %d , status : %d parent_pid : %d \n",chi->pid, chi->state, chi->parent->pid);
    while(do_wait() != -1)
    {
       cprintf("get a child\n");
    }
    assert(before == nr_free_pages());

    panic("now no wait function\n");

    while(100);
    */
    return 0;
}
void
proc_init(void){
    init_proc_manager();

    if ((IDLE_PROC = alloc_proc()) == NULL) {
        panic("cannot alloc idleproc.\n");
    }

    IDLE_PROC->context =  kmalloc(sizeof(struct context));
    IDLE_PROC->pid = get_pid_2();
    strcpy(IDLE_PROC->name, "idle");
    IDLE_PROC->state = RUNNABLE;
    IDLE_PROC->pgdir = kpgdir;
    extern char _boot_stack[];
    IDLE_PROC->kstack = (char*)_boot_stack;
    init_se(&IDLE_PROC->se, MIN_PRIO);

    init_sche(IDLE_PROC);

    CUR_PROC = IDLE_PROC;
    int pid = kernel_thread(init_main, "Hello world!!", 0);
    
    INIT_PROC = get_proc_by_pid(pid);
    strcpy((INIT_PROC)->name, "init");
    cprintf("proc_init ok!\n");

    assert(IDLE_PROC != NULL && (IDLE_PROC)->pid == 0);
    assert(INIT_PROC != NULL && (INIT_PROC)->pid == 1);
    assert(get_proc_num() == 2);
}

int do_exit(int a)
{
    return 0;
}
