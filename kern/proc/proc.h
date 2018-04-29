
#ifndef __KERN_PROC_2_H_
#define __KERN_PROC_2_H_
#include "defs.h"
#include "list.h"
#include "vmm.h"
#include "x86.h" //struct trapframe
#include "param.h"
#include "cfs.h"
#include "lock_p.h"
#include "fs_ds.h"
#include "file.h"

// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
    uint edi;
    uint esi;
    uint ebx;
    uint ebp;
    uint eip;
};


enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };
enum waitstate { WT_NO, SLEEP };
#define PROC_NAME 16
#define list2proc(ptr) to_struct(ptr, struct proc, elm)
#define clist2proc(ptr) to_struct(ptr, struct proc, plink)
#define has_child(proc) (!list_empty(&proc->child))

#define MAX_PROC 50

struct proc {
    char name[PROC_NAME];               // Process name (debugging)
    enum procstate state;        // Process state
    int32_t pid;                     // Process ID
    int8_t exit_code;
    struct proc *parent;         // Parent process

    struct context* context;     // swtch() here to run process
    struct trapframe *tf;        // Trap frame for current syscall
    pte_t *pgdir;                 // CR3 register: the base addr of Page Directroy Table(PDT)
    uintptr_t cr3;

    char *kstack;                // Bottom of kernel stack for this process
    struct mm_struct *mm;         // Process memlayout
    
    enum waitstate wait_state;
    void *chan;
    list_entry_t elm;
    list_entry_t plink;
    list_entry_t child;
    list_entry_t sleep_elm;
    struct sche_entity se;

    //filesystem
    file *fds[PROC_MAX_FD];
    minode cur_inode;  
};
struct proc_manager{
    struct spinlock lock;
    struct proc *init_proc;
    struct proc *idle_proc;
    uint32_t cur_use_pid;
    
    list_entry_t *sleep_hash;
};

extern struct proc_manager proc_manager;
#define INIT_PROC (proc_manager.init_proc)
#define IDLE_PROC (proc_manager.idle_proc)
#define PROCM_LOCK (&proc_manager.lock)
#define PROCM_ACQUIRE acquire(&proc_manager.lock)
#define PROCM_RELEASE release(&proc_manager.lock)
#define IS_KERN_PROC(p) (p->mm == NULL)

#define clist2proc(ptr) to_struct(ptr, struct proc, plink)
#define has_child(proc) (!list_empty(&proc->child))



void proc_init(void);
int do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf);
bool do_execve(const char *name, size_t len, char *binary, size_t size);
uint8_t do_exit(int8_t error_code);
int do_wait();
struct proc* fetch_child(struct proc* p);
bool change_childs(struct proc* old, struct proc* new);
bool add_child(struct proc* parent, struct proc* child);
void sleep(void *chan, struct spinlock *lk);
void wakeup(void *chan);
minode* get_cur_inode();

#endif
