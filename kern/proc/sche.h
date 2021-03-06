#ifndef _KERN_PROC_SCHE_2_H_
#define _KERN_PROC_SCHE_2_H_
#include "basic_p.h"
struct sche_class {
    // the name of sched_class
    const char *name;
    // Init the run queue
    void (*init)(struct sche_entity* se);
    // put the proc into runqueue, and this function must be called with rq_lock
    void (*enqueue)(struct sche_entity *se, int flag);
    // get the proc out runqueue, and this function must be called with rq_lock
    void (*dequeue)(struct sche_entity *prev, struct sche_entity *se);
    // choose the next runnable task
    struct sche_entity *(*pick_first)(void);
    // dealer of the time-tick
    void (*proc_tick)(struct sche_entity *se);


    struct sche_entity* (*pick_next)(struct sche_entity *se);

    void (*init_se)(struct sche_entity *se, int prio);
    int (*is_sche)(struct sche_entity *curr);
};

struct proc;
void init_sche(struct proc* proc);
void init_se(struct sche_entity *se, int prio);
void put_proc(struct proc* proc, int a);
int set_proc_prio(struct proc* proc, int prio);
int get_proc_prio(struct proc* proc);
int get_proc_num();
struct proc* get_proc_by_pid(int pid);
void get_proc(struct proc *prev, struct proc *thi);
void schedule(struct spinlock *lock);
void sche_tick();
void 
sche_tick2();
#if SCHE_DEBUG
void sche_display();
#endif
#endif
