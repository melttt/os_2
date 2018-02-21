#include "basic_p.h"
#include "list.h"
#include "mm_p.h"
#include "sleep_hash.h"
#include "kdebug.h"
#include "stdio.h"
#include "proc.h"
    //list_entry_t sleep_hash[S_HASH_MAX];
    //
    //

static int hash_f(uintptr_t p)
{
    return (p & 0x000FFF00) >> 8;
}
void init_sleep_hash(list_entry_t **s)
{
    list_entry_t *arr;
    *s = kmalloc(sizeof(list_entry_t) * S_HASH_MAX);
    arr = *s;
    assert(arr != NULL);
    int i;         
    for(i = 0 ; i < S_HASH_MAX ; i ++)
    {
        list_init(arr + i);
    }
}

void put_proc_in_sleep_hash(list_entry_t* arr, void *w_thread, struct proc* proc)
{
    list_entry_t *head;    

    head = &arr[hash_f((uintptr_t)w_thread)];
    assert(proc->state == SLEEPING);
    list_add_before(head, &proc->sleep_elm);
}

struct proc* get_proc_in_sleep_hash_by_ptr(list_entry_t *arr, void *ptr)
{
    list_entry_t *head;    
    struct proc* ret = NULL;
    head = &arr[hash_f((uintptr_t)ptr)];
    if(!list_empty(head->next))
    {
        ret = shlist2proc(head->next);
        list_del_init(head->next);
        assert(ret->state == SLEEPING);
    }
    return ret;
}

