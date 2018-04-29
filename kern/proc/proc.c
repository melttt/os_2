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
#include "sleep_hash.h"
#include "syslib.h"

#include "inode.h"
static int
load_icode(char *binary, size_t size);

static int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags);

static int
user_main(void *arg);

static int
init_main(void *arg);

struct proc_manager proc_manager;
static void init_proc_manager()
{
    init_lock(&proc_manager.lock, "proc_manager");
    proc_manager.cur_use_pid = 0;
    proc_manager.init_proc = NULL;
    proc_manager.idle_proc = NULL;
    init_sleep_hash(&proc_manager.sleep_hash);
}
static uint32_t
get_pid()
{
    uint32_t ret;
    PROCM_ACQUIRE;
    ret = proc_manager.cur_use_pid ++;
    PROCM_RELEASE;
    return ret;
}

struct proc*
fetch_child(struct proc* p)
{
    list_entry_t *head = &p->child;
    if(head->next != NULL)
    {
        struct proc *ret = list2proc(head->next);
        list_del_init(head->next);
        return ret;
    }
    return NULL;
}


bool
change_childs(struct proc* old, struct proc* new)
{
    assert(old && new);
    PROCM_ACQUIRE;

    FOR_EACH_LIST(&old->child, le)
    {
        struct proc* child = list2proc(le);        
        add_child(new, child);
    }
    FOR_EACH_END

    PROCM_RELEASE;
    return true;
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
        int i ;
        for(i = 0 ; i < PROC_MAX_FD ; i ++) proc->fds[i] = NULL;
        proc->cur_inode.magic_num = 0;

        list_init(&proc->elm);
        list_init(&proc->sleep_elm);
        list_init(&proc->child);
        list_init(&proc->plink);
        init_se(&(proc->se), MIN_PRIO);
    }
    return proc;
}

void
make_proc_runnable(struct proc *proc) {
    assert(proc->state != RUNNABLE && proc->state != ZOMBIE);
    proc->state = RUNNABLE;
    put_proc(proc, 0); 
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

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to
//       proc->tf in do_fork-->copy_thread function
static int
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

dirent dirs[10];
int dir_len;
static int
user_main(void *arg){
    struct proc *current = CUR_PROC;
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, "user");
    assert(PCPU->ncli == 0);
    char *user_test_buf;
    int user_test_buf_len;

    minode *root = get_cur_inode();
    cprintf("list file\n");
    dir_len = dirent_list(root ,dirs , sizeof(dirs));
    for(int i = 0 ; i < dir_len ; i ++)
    {
        cprintf("%s\n", dirs[i].name);
    }
    cprintf("\n");
    file* a = kopen(root , "user_test", 0);
    user_test_buf_len =  a->disk_inode.data.size;
    user_test_buf = kmalloc(a->disk_inode.data.size);
    kread(a, user_test_buf, user_test_buf_len);
    exec(" ", 1, (char*)user_test_buf, (size_t)user_test_buf_len);
    panic("should not at here\n");
    return 1;
}


// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
    struct proc *current = CUR_PROC;
    assert(PCPU->ncli == 0);

    cprintf("%x\n", current);
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, "init");
    cprintf("To U: \"%s\".\n", (const char *)arg);

    init_fs();

    int pid = kernel_thread(user_main, "one", 0);
    if (pid <= 0) {
        panic("create first USER failed.\n");
    }
    schedule(PROCM_LOCK);

    while((pid = do_wait()) != -1)
    {
       cprintf("get a child,pid:%x\n", pid);
    }

    panic("proc init shouldn't be closed\n");

    return 0;
}
void
proc_init(void){
    init_proc_manager();

    if ((IDLE_PROC = alloc_proc()) == NULL) {
        panic("cannot alloc idleproc.\n");
    }

    IDLE_PROC->context =  kmalloc(sizeof(struct context));
    IDLE_PROC->pid = get_pid();
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
    cprintf(INITOK"proc_init ok!\n");

    assert(IDLE_PROC != NULL && (IDLE_PROC)->pid == 0);
    assert(INIT_PROC != NULL && (INIT_PROC)->pid == 1);
    assert(get_proc_num() == 2);
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
    proc->cur_inode = proc->parent->cur_inode;
    copy_thread(proc, stack, tf);
    proc->pid = get_pid();
    set_proc_prio(proc, MAX_PRIO);
    make_proc_runnable(proc);

    ret = proc->pid;

#if SCHE_DEBUG
    cprintf(SCHE_MSG"pid : %x, fork ,pid : %x\n",proc->parent->pid, proc->pid);
#endif
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
uint8_t
do_exit(int8_t error_code)
{
    struct proc *current = CUR_PROC;
    struct proc *idleproc = IDLE_PROC;
    struct proc *initproc = INIT_PROC;

    if (current == idleproc) {
        panic("idleproc exit.\n");
    }
    if (current == initproc) {
        panic("initproc exit.\n");
    }
    //release mm struct
    struct mm_struct *mm = current->mm;
    if (mm != NULL) {
        lcr3(V2P(kpgdir));
        if (mm_count_dec(mm) == 0) {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        current->mm = NULL;
    }

    change_childs(current, current->parent); 
    current->exit_code = error_code;
    current->state = ZOMBIE;
    wakeup(current->parent);
#if SCHE_DEBUG
    cprintf(SCHE_MSG"pid : %x, to_exit\n", current->pid);
#endif
    schedule(PROCM_LOCK);
    return 1;
}


int
do_wait(void)
{
    struct proc *proc;
    struct proc *cproc;
    while(1)
    {
        PROCM_ACQUIRE;
        proc = CUR_PROC;
        if(!has_child(proc))
        {
            PROCM_RELEASE;
            return -1;
        }
        FOR_EACH_LIST(&proc->child, le)
        {
            cproc = clist2proc(le); 
            if(cproc->state == ZOMBIE)
            {
                int32_t pid = cproc->pid;            
                put_kstack(cproc);
                kfree(cproc);
                list_del_init(le);
                PROCM_RELEASE;
                return pid;
            }
        }
        FOR_EACH_END

        sleep(proc, PROCM_LOCK);
        PROCM_RELEASE;
    }

    panic("no no no no no you shouldn't be here~_~\n");
    return 1;
}

bool
do_execve(const char *name, size_t len, char *binary, size_t size)
{
    struct proc *proc = CUR_PROC; 
    struct mm_struct *mm = proc->mm;

    if(!(user_mem_check(mm, (uintptr_t)name, len, 0)))
    {
        return false;
    }

    if(len > PROC_NAME)
    {
        len = PROC_NAME;
    }
    strcpy(IDLE_PROC->name, name);


    if(mm != NULL)
    {
        lcr3(V2P(kpgdir));
        if (mm_count_dec(mm) == 0) {
            exit_mmap(mm);
            put_pgdir(mm);
            mm_destroy(mm);
        }
        proc->mm = NULL;
    }

    int ret;
    if((ret = load_icode(binary, size)) != 0){
        panic("go to execve_exit");
    }
    return 0;
}

static int
load_icode(char *binary, size_t size)
{
    struct proc *current = CUR_PROC;
    if(current->mm != NULL){
        panic("load_icode: current->mm must be empty.\n");
    }

    int ret = -E_NO_MEM;
    struct mm_struct *mm;
    //(1) create a new mm for current process
    if((mm = mm_create()) == NULL)
    {
        goto bad_mm;
    }

    //(2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
    if(mm_setup_pgdir(mm) ==false)
    {
        goto bad_pgdir_cleanup_mm;
    }

    //(3) copy TEXT/DATA section, build BSS parts in binary to memory space of process
    struct page *page;
    struct elfhdr *elf = (struct elfhdr *)binary;
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
    //(3.1) This program is valid? 
    if(elf->e_magic != ELF_MAGIC){
        ret = -E_INVAL_ELF;
        goto bad_elf_cleanup_pgdir;
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
    for(; ph < ph_end ;ph ++)
    {
        //(3.2) find every program section headers
        if (ph->p_type != ELF_PROG_LOAD) {
            continue ;
        }
        if (ph->p_filesz > ph->p_memsz) {
            ret = -E_INVAL_ELF;
            goto bad_cleanup_mmap;
        }
        if (ph->p_filesz == 0) {
            continue ;
        }

        //(3.3) call mm_map fun to setup the new vma ( ph->p_va, ph->p_memsz)
        vm_flags = 0, perm = PTE_U;
        if (ph->p_flags & ELF_PROG_FLAG_EXEC) vm_flags |= VM_EXEC;
        if (ph->p_flags & ELF_PROG_FLAG_WRITE) vm_flags |= VM_WRITE;
        if (ph->p_flags & ELF_PROG_FLAG_READ) vm_flags |= VM_READ;
        if (vm_flags & VM_WRITE) perm |= PTE_W;
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
            goto bad_cleanup_mmap;
        }

        char *from = binary + ph->p_offset;
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);

        ret = -E_NO_MEM;


        //(3.4) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
        //(3.4.1) copy TEXT/DATA section of bianry program
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
            if (end < la) {
                size -= la - end;
            }
            memcpy(page2kva(page) + off, from, size);
            start += size, from += size;
        }

        //(3.4.2) build BSS section of binary program
        end = ph->p_va + ph->p_memsz;
        if (start < la) {
            /* ph->p_memsz == ph->p_filesz */
            if (start == end) {
                continue ;
            }
            off = start + PGSIZE - la, size = PGSIZE - off;
            if (end < la) {
                size -= la - end;
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }

        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
            if (end < la) {
                size -= la - end;
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
        }
    }

    vm_flags = VM_READ | VM_WRITE | VM_STACK;
    if ((ret = mm_map(mm, USERTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
        goto bad_cleanup_mmap;
    }

    pgdir_alloc_page(mm->pgdir, USERTOP - USTACKSIZE, (PTE_U | PTE_W | PTE_P));
    pgdir_alloc_page(mm->pgdir, USERTOP - USTACKSIZE + 4096, (PTE_U | PTE_W | PTE_P));
    pgdir_alloc_page(mm->pgdir, USERTOP - USTACKSIZE + 4096*2, (PTE_U | PTE_W | PTE_P));
    pgdir_alloc_page(mm->pgdir, USERTOP - USTACKSIZE + 4096*3, (PTE_U | PTE_W | PTE_P));


    //(5) set current process's mm, sr3, and set CR3 reg = physical addr of Page Directory
    mm_count_inc(mm);
    current->mm = mm;
    current->cr3 = V2P(mm->pgdir);
    lcr3(V2P(mm->pgdir));

    //(6) setup trapframe for user environment
    struct trapframe *tf = current->tf;
    memset(tf, 0, sizeof(struct trapframe));
    tf->cs = SEG_UCODE << 3 | DPL_USER;
    tf->ds = tf->es = tf->ss = SEG_UDATA << 3 | DPL_USER;
    tf->esp = USERTOP - 4;
    tf->eip = elf->e_entry;

    tf->eflags |= FL_IF;
    load_tss(current);

    ret = 0;
    return ret;
bad_mm:
bad_pgdir_cleanup_mm:
bad_elf_cleanup_pgdir:
bad_cleanup_mmap:
    panic("exec wrong\n");
    return ret;
}


// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// should add ptable.lock before and after the sleep
void
sleep(void *chan, struct spinlock *lk)
{
    struct proc *proc = CUR_PROC;
    if(proc == 0)
        panic("sleep in no proc");

    if(lk == 0)
        panic("sleep without lk");

    // Must acquire ptable.lock in order to
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != PROCM_LOCK){  //DOC: sleeplock0
        PROCM_ACQUIRE;
        release(lk);
    }

    // Go to sleep.
    proc->chan = chan;
    proc->state = SLEEPING;
#if SCHE_DEBUG
    cprintf(SCHE_MSG"pid : %x, to_sleep\n", proc->pid);
#endif
    put_proc_in_sleep_hash(proc_manager.sleep_hash, chan, proc);
    schedule(NULL);

    // Tidy up.
    proc->chan = 0;

    // Reacquire original lock.
    if(lk != PROCM_LOCK){  //DOC: sleeplock2
        PROCM_RELEASE;
        acquire(lk);
    }
}


// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
    struct proc *proc = NULL;
    PROCM_ACQUIRE;
    while((proc = get_proc_in_sleep_hash_by_ptr(proc_manager.sleep_hash, chan)) != NULL)
    {
#if SCHE_DEBUG
    cprintf(SCHE_MSG"pid : %x, to_wakeup\n", proc->pid);
#endif
        proc->state = RUNNABLE;
        put_proc(proc, 1);
    }
    PROCM_RELEASE;
}


minode* get_cur_inode()
{
    minode *p = &CUR_PROC->cur_inode;
    if(p->magic_num != INODE_MAGIC_NUM)
        p = NULL;
    return p; 
}
