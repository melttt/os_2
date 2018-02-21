#ifndef _KERN_PROC_SLEEP_HASH_H_
#define _KERN_PROC_SLEEP_HASH_H_


#define S_HASH_MAX 4096


#define shlist2proc(ptr) to_struct(ptr, struct proc, sleep_elm)

void init_sleep_hash(list_entry_t **s);
void put_proc_in_sleep_hash(list_entry_t* arr, void *w_thread, struct proc* proc);
struct proc* get_proc_in_sleep_hash_by_ptr(list_entry_t *arr, void *ptr);

#endif
