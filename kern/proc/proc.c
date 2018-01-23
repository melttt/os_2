#include "basic_p.h"
#include "driver_p.h"
#include "mm_p.h"
#include "smp_p.h"
#include "arch_p.h"

#include "proc.h"
#include "sche.h"
#include "list.h"
#include "kdebug.h"
#include "string.h"
#include "error.h"
#include "stdio.h"
#include "syscall.h"
#include "trap.h"
#include "elf.h"




// the process set's list
list_entry_t proc_list;
extern uint32_t hash32(uint32_t, uint32_t); 
#define HASH_SHIFT          10
#define HASH_LIST_SIZE      (1 << HASH_SHIFT)
#define pid_hashfn(x)       (hash32(x, HASH_SHIFT))
// has list for process set based on pid
static list_entry_t hash_list[HASH_LIST_SIZE];






static int nr_process = 0;
extern void __traprets(void);

void kernel_thread_entry(void);
void traprets(struct trapframe *tf);
// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
    struct proc *current = PCPU->cur_proc;
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, "init");
    cprintf("To U: \"%s\".\n", (const char *)arg);
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
     asm volatile (
        "int %0;"
        : 
        : "i" (T_SYSCALL),"b" ('q'),"a" (SYS_put)
        : "memory");
     asm volatile (
        "int %0;"
        : 
        : "i" (T_SYSCALL),"b" ('q'),"a" (SYS_exec)
        : "memory");
    while(100);
    return 0;
}
/*
void sche(void)
{
    struct proc *idleproc = PCPU->idle_proc;
    struct proc *initproc = PCPU->init_proc;
    struct proc *current = PCPU->cur_proc;
    assert(current && idleproc);
    cprintf("sche\n");
    //asm volatile("cli");
    if(current == idleproc)
    {
    cprintf("sche _ go\n");
    cprintf("%x\n",init_main);
        swtch(&idleproc->context, initproc->context);
    }
}
*/


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



// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
    int i;
    struct proc **idleproc = &PCPU->idle_proc;
    struct proc **initproc = &PCPU->init_proc;
    struct proc **curproc = &PCPU->cur_proc;
    list_init(&proc_list);

    init_sche();
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
        list_init(hash_list + i);
    }

    if ((*idleproc = alloc_proc()) == NULL) {
        panic("cannot alloc idleproc.\n");
    }

    (*idleproc)->context = kmalloc(sizeof(struct context));
    (*idleproc)->pid = 0;
    //warning
    //idleproc->kstack =  (char*)stack; 
    //idleproc->need_resched = 1;
    strcpy((*idleproc)->name, "idle");
    (*idleproc)->state = RUNNABLE;
    nr_process ++;

    *curproc = *idleproc;
    


    int pid = kernel_thread(init_main, "Hello world!!", 0);
    if (pid <= 0) {
        panic("create init_main failed.\n");
    }

    //initproc = find_proc(pid);
    //set_proc_name(initproc, "init");
    strcpy((*idleproc)->name, "init");

    assert((*idleproc) != NULL && (*idleproc)->pid == 0);
    assert(*initproc != NULL && (*initproc)->pid == 1);
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
    
    
    struct proc *current = PCPU->cur_proc;
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
    *((int*)(proc->tf) - 1) = (int)__traprets;
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
    struct proc **initproc = &PCPU->init_proc;
    struct proc *current = PCPU->cur_proc;
    struct proc *proc;
    if (nr_process >= 20) {
        goto fork_out;
    }

    ret = -E_NO_MEM;
    if ((proc = alloc_proc()) == NULL) {
        goto fork_out;
    }

    proc->parent = current;

    if ((proc->kstack = kmalloc(KSTACKSIZES)) == NULL) {
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
    //list_add(&proc_list, &(proc->list_link));
    nr_process ++;
    //}
    //local_intr_restore(intr_flag);
    *initproc = proc;

    wakeup_proc(proc);
    put_proc(proc); 

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


static int
load_icode(unsigned char *binary, size_t size);

bool
do_execve(const char *name, size_t len, unsigned char *binary, size_t size)
{
   struct proc *proc = PCPU->cur_proc; 
   struct mm_struct *mm = proc->mm;

   if(!(user_mem_check(mm, (uintptr_t)name, len, 0)))
   {
       return false;
   }

    if(len > PROC_NAME)
    {
        len = PROC_NAME;
    }

    if(mm != NULL)
    {
        panic("no achieve now!\n");
    }

    int ret;
    if((ret = load_icode(binary, size)) != 0){
        panic("go to execve_exit");
    }


    return 0;

}


/* load_icode - load the content of binary program(ELF format) as the new content of current process
 * @binary:  the memory addr of the content of binary program
 * @size:  the size of the content of binary program
 */
static int
load_icode(unsigned char *binary, size_t size)
{
    struct proc *current = PCPU->cur_proc;
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

        unsigned char *from = binary + ph->p_offset;
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
//    mm_count_inc(mm);
    current->mm = mm;
    current->cr3 = V2P(mm->pgdir);
    lcr3(V2P(mm->pgdir));

    //(6) setup trapframe for user environment
    struct trapframe *tf = current->tf;
    memset(tf, 0, sizeof(struct trapframe));
    /* LAB5:EXERCISE1 YOUR CODE
     * should set tf_cs,tf_ds,tf_es,tf_ss,tf_esp,tf_eip,tf_eflags
     * NOTICE: If we set trapframe correctly, then the user level process can return to USER MODE from kernel. So
     *          tf_cs should be USER_CS segment (see memlayout.h)
     *          tf_ds=tf_es=tf_ss should be USER_DS segment
     *          tf_esp should be the top addr of user stack (USTACKTOP)
     *          tf_eip should be the entry point of this binary program (elf->e_entry)
     *          tf_eflags should be set to enable computer to produce Interrupt
     */
    tf->cs = SEG_UCODE << 3 | 3;
    tf->ds = tf->es = tf->ss = SEG_UDATA << 3 | 3;
    tf->esp = USERTOP - 4;
    tf->eip = elf->e_entry;

    tf->eflags = FL_IF;
    
    
    ret = 0;
    return ret;
bad_mm:
bad_pgdir_cleanup_mm:
bad_elf_cleanup_pgdir:
bad_cleanup_mmap:
    panic("exec wrong\n");
    return ret;
}
