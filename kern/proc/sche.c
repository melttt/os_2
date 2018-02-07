#include "basic_p.h"
#include "lock_p.h"
#include "proc.h"
#include "list.h"
#include "cpu.h"
#include "kdebug.h"
#include "sche.h"
#include "stdio.h"
#include "mm_p.h"
struct proc_manager proc_manager;
#define LOCK &proc_manager.lock
#define ACQUIRE acquire(LOCK)
#define RELEASE release(LOCK)

void swtch(struct context **a, struct context *b);

struct proc*
find_proc(uint32_t pid){
    ACQUIRE;
    list_entry_t *ready_queue = &proc_manager.ready;
    list_entry_t *sleep_queue = &proc_manager.sleep;
    struct proc* proc = NULL;
    if(IDLE_PROC != NULL && IDLE_PROC->pid == pid)
    {
        proc = IDLE_PROC;
        goto found;
    }
    if(INIT_PROC != NULL && INIT_PROC->pid == pid)
    {
        proc = INIT_PROC;
        goto found;
    }

    list_entry_t *le = ready_queue; 
    while((le = list_next(le)) != ready_queue)
    {
        proc = list2proc(le);
        if(proc->pid == pid)
        {
            goto found;
        }
    }
    le = sleep_queue; 
    while((le = list_next(le)) != sleep_queue)
    {
        proc = list2proc(le);
        if(proc->pid == pid)
        {
            goto found;
        }
    }
    RELEASE;
    assert(proc == NULL);
    return proc;
found:
    RELEASE;
    return proc;

}
struct proc*
get_proc(){
    list_entry_t *head = &proc_manager.ready;
    if(!list_empty(head)){
       struct proc *ret = list2proc(head->next);
       list_del_init(head->next);
       return ret; 
    }
    return NULL;
}

bool
put_proc(struct proc *proc){
    list_entry_t *head = &proc_manager.ready;
    list_del_init(&proc->elm);
    list_add_before(head, &proc->elm);
    return true;
}

bool
put_proc_sleep(struct proc *proc){
    list_entry_t *head = &proc_manager.sleep;
    list_del_init(&proc->elm);
    list_add_before(head, &proc->elm);
    return true;
}


void init_sche()
{
    init_lock(LOCK, "lock");
    list_init(&proc_manager.ready);
    list_init(&proc_manager.sleep);
    proc_manager.n_process = 0;
    proc_manager.cur_use_pid = 0;
}

uint32_t get_pid()
{
    uint32_t ret;
    ACQUIRE;
    ret = proc_manager.cur_use_pid ++;
    RELEASE;
    return ret;
}
void inc_proc_n()
{
    ACQUIRE;
    proc_manager.n_process ++;
    RELEASE;
}
void dec_proc_n()
{
    ACQUIRE;
    proc_manager.n_process --;
    RELEASE;
}

void sche()
{
    ACQUIRE;
    assert(PCPU->ncli == 1);
    struct proc *idleproc = IDLE_PROC;
    struct proc *current = CUR_PROC;
    assert(current && idleproc);
    struct proc *new = get_proc();
    if(new)
    {
        if(current->state == RUNNING || current->state == RUNNABLE)
        {
            put_proc(current);
        }
        else{
            cprintf("CURRENT->state : %d\n", current->state);
            put_proc_sleep(current);
        }
        new->state = RUNNING;
        CUR_PROC = new;
        switchuvm(new);
        swtch(&current->context, new->context);
        switchkvm();
    }else{
        if(current != idleproc)
        {
            new = idleproc;
            if(current->state == RUNNABLE)
            {
                put_proc(current);
            }
            else{
                put_proc_sleep(current);
            }
            new->state = RUNNING;
            switchkvm();
            CUR_PROC = new;
            swtch(&current->context, idleproc->context);
            switchkvm();
        }else{
            ;;;;;;;;;;
        }
    }
    assert(PCPU->ncli == 1);
    RELEASE;
}

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
void
forkret(void) {
    //traprets(current->tf);
    RELEASE;
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

bool
change_childs(struct proc* old, struct proc* new)
{
    assert(old && new);
    ACQUIRE;

    FOR_EACH_LIST(&old->child, le)
    {
        struct proc* child = list2proc(le);        
        add_child(new, child);
    }
    FOR_EACH_END

    RELEASE;
    return true;
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
    if(lk != LOCK){  //DOC: sleeplock0
        ACQUIRE;
        release(lk);
    }

    // Go to sleep.
    proc->chan = chan;
    proc->state = SLEEPING;

    sche();

    // Tidy up.
    proc->chan = 0;

    // Reacquire original lock.
    if(lk != LOCK){  //DOC: sleeplock2
        RELEASE;
        acquire(lk);
    }
}


//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
    FOR_EACH_LIST(&proc_manager.sleep, le)
    {
        struct proc *ret = list2proc(le);
        if(ret->chan == chan)
        {
            ret->state = RUNNABLE;
            list_del_init(le);
            put_proc(ret);
        }
    }
    FOR_EACH_END
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  ACQUIRE;
  wakeup1(chan);
  RELEASE;
}


int
do_wait()
{
    while(1)
    {
        struct proc *proc;
        struct proc *cproc;
        ACQUIRE;
        proc = CUR_PROC;
        cprintf("pid = %d\n",proc->pid);
        if(!has_child(proc))
        {
            cprintf("NO CHILD\n");
            RELEASE;
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
                RELEASE;
                return pid;
            }
        }
        FOR_EACH_END

        sleep(proc, LOCK);
        RELEASE;
    }

    panic("no no no no no you shouldn't be here~_~\n");
    return 1;
}

