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
#if SCHE_DEBUG
#include "rbtree.h"
#define rb_entry2se(p) rb_entry(p, struct sche_entity, rb_node)
void sche_display()
{
    struct rb_node *node = rb_first(&cfs->rb_root);
    struct proc* proc = CUR_PROC;
    cprintf("++++++++++++++++++++++++++++++++++++++++++++++++\n");
    cprintf("PID_SUM:%x\n", get_proc_num());
    
    cprintf("cur_proc:\n");
    cprintf("pid:%x,vrt:%x,state:%s\n", proc->pid, proc->se.vruntime, sche_state[proc->state]);

    cprintf("ready_proc:\n");
    while(node != NULL)
    {
        proc = se2proc(rb_entry2se(node));
        cprintf("pid:%x,vrt:%x,state:%s\n", proc->pid, proc->se.vruntime, sche_state[proc->state]);
        node = rb_next(node);
    }
    cprintf("END_SUM\n");
    cprintf("++++++++++++++++++++++++++++++++++++++++++++++++\n");
}

#endif

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
put_proc(struct proc* proc, int a)
{
    sche_class->enqueue(&proc->se, a);
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

void 
sche_tick2()
{
    struct proc* proc = CUR_PROC;
    sche_class->proc_tick(&proc->se);
}
void
sche_tick()
{
    struct proc* proc = CUR_PROC;
    sche_class->proc_tick(&proc->se);
#if SCHE_DEBUG
//    sche_display();
#endif
    if(sche_class->is_sche(&proc->se))
    {
        schedule(PROCM_LOCK);
    }
    
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



void schedule(struct spinlock *lock)
{
    if(lock != NULL && lock != PROCM_LOCK) 
        panic("wrong lock:-)");

    if(lock == PROCM_LOCK) PROCM_ACQUIRE;

    assert(PCPU->ncli == 1);
    if(readeflags()&FL_IF)
        panic("sched interruptible");
    struct proc *new = pick_first_proc();
    struct proc *curr = CUR_PROC;


    if(new == NULL)
    {
        if(curr->pid == 0)
        {
            if(lock == PROCM_LOCK) PROCM_RELEASE;
            return;
        }
        cprintf("now pid:%d \n", curr->pid);
        panic("sched no proc");
    }

    if(curr->state == RUNNING)
        curr->state = RUNNABLE;

    get_proc(curr, new);
#if SCHE_DEBUG
    if(curr->state == RUNNABLE )
    {
        put_proc(curr, 1);
    }
#else
    if(curr->state == RUNNABLE)
        put_proc(curr, 1);
#endif

    new->state = RUNNING;
    CUR_PROC = new;
    if(IS_KERN_PROC(new))
    {
        switchkvm();
    }else{
        switchuvm(new);
    }

    int tmp;
    tmp = PCPU->intena;
    assert(PCPU->ncli == 1);
    swtch(&curr->context, new->context); 
    assert(PCPU->ncli == 1);
    PCPU->intena = tmp;

    /*
    new = CUR_PROC; 
    if(IS_KERN_PROC(new))
    {
        switchkvm();
    }else{
        switchuvm(new);
    }
    */

    if(lock == PROCM_LOCK) PROCM_RELEASE;
}




