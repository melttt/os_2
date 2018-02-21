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
    return se2proc(sche_class->pick_first()); 
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


void sche()
{
    PROCM_ACQUIRE;
    assert(PCPU->ncli == 1);
    struct proc *idleproc = IDLE_PROC;
    struct proc *current = CUR_PROC;
    assert(current && idleproc);
    struct proc *new = pick_first_proc(); 

    if(new)
    {
        cprintf(TEST_MSG"try put pid\n", current->pid);
        if(current->pid != 0 )
            put_proc(current);

        new->state = RUNNING;
        CUR_PROC = new;
        switchuvm(new);
        get_proc(current ,new);
        swtch(&current->context, new->context);
        switchkvm();
    }else{
        assert("now not\n");
        if(current != idleproc)
        {
            new = idleproc;
            if(current->state == RUNNABLE)
            {
                put_proc(current);
            }
            new->state = RUNNING;
            switchkvm();
            CUR_PROC = new;
            get_proc(current ,new);
            swtch(&current->context, idleproc->context);
            switchkvm();
        }else{
            ;;;;;;;;;;
        }
    }
      
    
    assert(PCPU->ncli == 1);
    PROCM_RELEASE;
}




