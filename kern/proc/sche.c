#include "basic_p.h"
#include "lock_p.h"
#include "proc.h"
#include "list.h"
#include "cpu.h"
#include "kdebug.h"
#define LOCK &proc_manager.lock
#define ACQUIRE acquire(LOCK)
#define RELEASE release(LOCK)

void swtch(struct context **a, struct context *b);
struct proc_manager{
    struct spinlock lock;
    list_entry_t ready;
}proc_manager;

struct proc*
get_proc(){
    list_entry_t *head = &proc_manager.ready;
    if(!list_empty(head)){
       struct proc *ret = list2proc(head->next);
       RELEASE;
       return ret; 
    }
    return NULL;
}

bool
put_proc(struct proc *proc){
    list_entry_t *head = &proc_manager.ready;
    list_add_before(head, &proc->ready_elm);
    return true;
}


void init_sche()
{
    init_lock(LOCK, "lock");
    list_init(&proc_manager.ready);
}


void sche()
{
    
    while(1)
    {
        asm volatile("sti");
        ACQUIRE;
        struct proc *idleproc = PCPU->idle_proc;
        struct proc *current = PCPU->cur_proc;
        assert(current && idleproc);
        volatile struct proc *new = get_proc();
        if(new)
        {
            current->state = RUNNABLE;
            put_proc(current);
            new->state = RUNNING;
            swtch(&current->context, new->context);
        }else{
            if(current != idleproc)
            {
                current->state = RUNNABLE;
                put_proc(current);
                new->state = RUNNING;
                swtch(&current->context, idleproc->context);
            }else{
                ;;;;;;;;;;
            }
        }
        RELEASE;
    }
}




