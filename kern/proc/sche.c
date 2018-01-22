#include "basic_p.h"
#include "lock_p.h"
#include "proc.h"
#include "list.h"
#define LOCK &proc_manager.lock
struct proc_manager{
    struct spinlock lock;
    list_entry_t *ready;
}proc_manager;




void init_sche()
{
    init_lock(LOCK, "lock");
}

void sche()
{

}




