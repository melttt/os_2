#ifndef _KERN_PROC_SCHE_H_
#define _KERN_PROC_SCHE_H_

#include "basic_p.h"
#include "proc.h"
#include "spinlock.h"

#define MAX_PROC 40

struct sched_entity;
struct sche_class {
    // the name of sched_class
    const char *name;
    // Init the run queue
    void (*init)(struct sche_entity);
    // put the proc into runqueue, and this function must be called with rq_lock
    void (*enqueue)(struct sche_entity *se, int flag);
    // get the proc out runqueue, and this function must be called with rq_lock
    void (*dequeue)(struct sche_entity *prev, struct sche_entity *se);
    // choose the next runnable task
    struct sche_entity *(*pick_next)();
    // dealer of the time-tick
    void (*proc_tick)(struct sche_entity *se);
};
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
bool change_childs(struct proc* old, struct proc* new);
bool add_child(struct proc* parent, struct proc* child);
struct proc* fetch_child(struct proc* p);
int do_wait();
void wakeup(void *chan);
void sleep(void *chan, struct spinlock *lk);
bool put_proc_sleep(struct proc *proc);
#endif
