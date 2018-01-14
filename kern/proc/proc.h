#ifndef __KERN_PROC_H_
#define __KERN_PROC_H_
#include "defs.h"
#include "list.h"
#include "vmm.h"
#include "x86.h" //struct trapframe
#include "param.h"
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
#define PROC_NAME 16
struct proc {
    char name[PROC_NAME];               // Process name (debugging)
    enum procstate state;        // Process state
    int pid;                     // Process ID
    struct proc *parent;         // Parent process

    struct context* context;     // swtch() here to run process
    struct trapframe *tf;        // Trap frame for current syscall
    pte_t *pgdir;                 // CR3 register: the base addr of Page Directroy Table(PDT)

    char *kstack;                // Bottom of kernel stack for this process
    struct mm_struct *mm;         // Process memlayout
/*
    list_entry_t list_link;                     // Process link list 
    list_entry_t hash_link;                     // Process hash list
    uint sz;                     // Size of process memory (bytes)
    void *chan;                  // If non-zero, sleeping on chan
    int killed;                  // If non-zero, have been killed
    struct file *ofile[NOFILE];  // Open files
    struct inode *cwd;           // Current directory
*/
};


extern struct proc *proc asm("%gs:4");     // cpus[cpunum()].proc


void sche(void);
void proc_init(void);
void do_exit(void);
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags);

int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf);
bool
do_execve(const char *name, size_t len, unsigned char *binary, size_t size);






#endif
