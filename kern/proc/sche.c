#include "basic_p.h"
#include "lock_p.h"
#include "proc.h"
#include "list.h"
#include "cpu.h"
#include "kdebug.h"
#include "sche.h"
#include "stdio.h"
#define LOCK &proc_manager.lock
#define ACQUIRE acquire(LOCK)
#define RELEASE release(LOCK)
struct proc_manager proc_manager;

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
       list_del(head->next);
       return ret; 
    }
    return NULL;
}

bool
put_proc(struct proc *proc){
    list_entry_t *head = &proc_manager.ready;
    list_add_before(head, &proc->elm);
    return true;
}


void init_sche()
{
    init_lock(LOCK, "lock");
    list_init(&proc_manager.ready);
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
        struct proc *idleproc = IDLE_PROC;
        struct proc *current = CUR_PROC;
        assert(current && idleproc);
        struct proc *new = get_proc();
        cprintf("new : %d\n", new->pid);
        cprintf("current : %d\n", current->pid);
        if(new)
        {
            current->state = RUNNABLE;
            if(current != IDLE_PROC && current != INIT_PROC)
                put_proc(current);

            new->state = RUNNING;
            CUR_PROC = new;
            switchuvm(new);
            swtch(&current->context, new->context);
            switchkvm();
        }else{
            if(current != idleproc)
            {
                current->state = RUNNABLE;
                put_proc(current);
                new->state = RUNNING;
                switchuvm(new);
                CUR_PROC = new;
                swtch(&current->context, idleproc->context);
                switchkvm();
            }else{
                ;;;;;;;;;;

            }
        }
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

