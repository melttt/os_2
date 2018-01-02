#include "defs.h"
#include "proc.h"
#include "list.h"
#include "kmalloc.h"
#include "kdebug.h"
#include "string.h"
#include "x86.h"
#include "mmu.h"
#include "error.h"
#include "stdio.h"
#include "cpu.h"


// the process set's list
list_entry_t proc_list;
extern uint32_t hash32(uint32_t, uint32_t); 
#define HASH_SHIFT          10
#define HASH_LIST_SIZE      (1 << HASH_SHIFT)
#define pid_hashfn(x)       (hash32(x, HASH_SHIFT))
// has list for process set based on pid
static list_entry_t hash_list[HASH_LIST_SIZE];


// idle proc
struct proc *idleproc = NULL;
// init proc
struct proc *initproc = NULL;
// current proc
struct proc *current = NULL;


static int nr_process = 0;
extern void __traprets(void);

void swtch(struct context **a, struct context *b);
void kernel_thread_entry(void);
void traprets(struct trapframe *tf);
void sche(void)
{
    assert(current && idleproc);
    cprintf("sche\n");
    asm volatile("cli");
    if(current == idleproc)
    {
    cprintf("sche _ go\n");
        swtch(&idleproc->context, initproc->context);
    }
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
        proc->parent = NULL;
        proc->context = NULL;
        proc->tf = NULL;
        proc->pgdir = NULL;
        proc->kstack = NULL;
        proc->mm = NULL;
    }
    return proc;
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, "init");
    cprintf("To U: \"%s\".\n", (const char *)arg);
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
    while(100);
    return 0;
}


// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->context = kmalloc(sizeof(struct context));
    idleproc->pid = 0;
    //warning
    //idleproc->kstack =  (char*)stack; 
    //idleproc->need_resched = 1;
    strcpy(idleproc->name, "idle");
    idleproc->state = RUNNABLE;
    nr_process ++;

    current = idleproc;

    int pid = kernel_thread(init_main, "Hello world!!", 0);
    if (pid <= 0) {
        panic("create init_main failed.\n");
    }

    //initproc = find_proc(pid);
    //set_proc_name(initproc, "init");
    strcpy(idleproc->name, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
    assert(initproc != NULL && initproc->pid == 1);
}


// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
    //traprets(current->tf);
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
    tf.eip = (uint32_t)kernel_thread_entry;
    return do_fork(clone_flags, 0, &tf);
}


static int
copy_mm(uint32_t clone_flags, struct proc *proc) {
    assert(current->mm == NULL);
    /* do nothing in this project */
    return 0;
}

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc *proc, uintptr_t esp, struct trapframe *tf) {
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZES) - 1;
    *(proc->tf) = *tf;
    proc->tf->eax = 0;
    proc->tf->esp = (int)(proc->kstack + 2048);
    proc->tf->eflags |= FL_IF;
    cprintf("proc->tf : %x\n",proc->tf);
    *((int*)(proc->tf) - 1) = (int)__traprets;
    cprintf("trapret : %x\n",kernel_thread_entry);
    proc->context = (struct context*)((int*)(proc->tf) - 1) - 1;
    proc->context->eip = (uintptr_t)forkret;
}


void
wakeup_proc(struct proc *proc) {
    assert(proc->state != RUNNABLE && proc->state != ZOMBIE);
    proc->state = RUNNABLE;
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
    if (nr_process >= 20) {
        goto fork_out;
    }

    ret = -E_NO_MEM;
    if ((proc = alloc_proc()) == NULL) {
        goto fork_out;
    }

    proc->parent = current;

    if ((proc->kstack = kmalloc(KSTACKSIZE)) == NULL) {
        goto bad_fork_cleanup_proc;
    }

    if (copy_mm(clone_flags, proc) != 0) {
        goto bad_fork_cleanup_kstack;
    }

    copy_thread(proc, stack, tf);

    //bool intr_flag;
    //local_intr_save(intr_flag);
    //asm volatile("sti");
    //{
    proc->pid = 1;
    //hash_proc(proc);
//    list_add(&proc_list, &(proc->list_link));
    nr_process ++;
    //}
    //local_intr_restore(intr_flag);
    initproc = proc;

    wakeup_proc(proc);

    ret = proc->pid;
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    //put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}

void do_exit(void)
{
    
}
