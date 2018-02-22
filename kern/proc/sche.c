#include "basic_p.h"

#include "stdio.h"
#include "cpu.h"
#include "cfs.h"
#include "proc.h"
#include "sche.h"
#include "kdebug.h"

#define se2proc(a)  to_struct(a, struct proc, se)   

void swtch(struct context **a, struct context *b);
struct sche_class * sche_class = &default_sche_class;

void
init_se(struct sche_entity *se, int prio)
{
    sche_class->init_se(se, prio);
}
int 
get_proc_num()
{
    return cfs->nr_running + 1;
}
void
init_sche(struct proc* proc)
{
   sche_class->init(&proc->se);  
}

void
put_proc(struct proc* proc)
{
    sche_class->enqueue(&proc->se, 0);
}

void
get_proc(struct proc *prev, struct proc *this)
{
    sche_class->dequeue(&prev->se, &this->se);
}

struct proc*
pick_first_proc()
{
    struct sche_entity *se = sche_class->pick_first();
    return se ? se2proc(se) : NULL; 
}

int
get_proc_prio(struct proc* proc)
{
    return proc->se.prio;
}


int
set_proc_prio(struct proc* proc, int prio)
{
    return proc->se.prio = prio;
}

struct proc*
get_proc_by_pid(int pid)
{
    if(CUR_PROC->pid == pid)
        return CUR_PROC;

    struct sche_entity *se;
    struct proc* proc;
    se = sche_class->pick_first();
    do{
        proc = se2proc(se);
        if(proc->pid == pid)
            return proc;
    }while((se = sche_class->pick_next(se)) != NULL);

    return NULL;
}



#if SCHE_DEBUG
//enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };
char *sche_state[6] = {
    "UNUSED",
    "EMBRYO",
    "SLEEPING",
    "RUNNABLE",
    "RUNNING",
    "ZOMBIE"
};
#endif
void schedule(struct spinlock *lock)
{
    if(lock != NULL && lock != PROCM_LOCK) 
        panic("wrong lock:-)");

    if(lock == PROCM_LOCK) PROCM_ACQUIRE;

    struct proc *new = pick_first_proc();
    struct proc *curr = CUR_PROC;

    if(new == NULL)
        panic("sched no proc");

    if(curr->state == RUNNING)
        curr->state = RUNNABLE;

    get_proc(curr, new);
#if SCHE_DEBUG
    if(curr->state == RUNNABLE && curr->pid != 0)
    {
        put_proc(curr);
        cprintf("pid %x , put", curr->pid);
    }
#else
    if(curr->state == RUNNABLE)
        put_proc(curr);
#endif

    new->state = RUNNING;
    CUR_PROC = new;
#if SCHE_DEBUG
    cprintf(SCHE_MSG"curr proc(pid = %x, state = %s),new proc(pid = %x, state = %s)\n", curr->pid,
            sche_state[curr->state], new->pid, sche_state[new->state]); 
#endif 
    if(IS_KERN_PROC(new))
    {
        switchkvm();
    }else{
        switchuvm(new);
    }
      
    assert(PCPU->ncli == 1);
    swtch(&curr->context, new->context); 
    assert(PCPU->ncli == 1);

    switchkvm();

    if(lock == PROCM_LOCK) PROCM_RELEASE;
}




