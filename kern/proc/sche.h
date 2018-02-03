#ifndef _KERN_PROC_SCHE_H_
#define _KERN_PROC_SCHE_H_

#include "basic_p.h"
#include "proc.h"

#define MAX_PROC 40
struct proc* get_proc();
struct proc_manager{
    struct spinlock lock;
    uint32_t n_process;
    list_entry_t ready;
    list_entry_t sleep;
    struct proc *init_proc;
    struct proc *idle_proc;
    uint32_t cur_use_pid;
};
extern struct proc_manager proc_manager;
#define INIT_PROC (proc_manager.init_proc)
#define IDLE_PROC (proc_manager.idle_proc)
#define N_PROC (proc_manager.n_process)
struct proc* get_proc();
bool put_proc(struct proc *proc);
void dec_proc_n();
struct proc* find_proc(uint32_t pid);
void inc_proc_n();
void init_sche();
void forkret(void);
uint32_t get_pid();
void sche();
#endif
