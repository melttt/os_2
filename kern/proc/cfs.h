#ifndef _KERN_PROC_CFS_H_
#define _KERN_PROC_CFS_H_
#include "basic_p.h"
#include "rbtree.h"
#include "lock_p.h"
#include "proc.h"

struct sche_entity
{
    struct rb_node rb_node;
    int prio;
    uint32_t vruntime;
    uint32_t sum_exec_runtime;
    uint32_t prev_sum_exec_runtime;
    int32_t on_rq;
};

struct cfs{
    uint32_t min_vruntime;
    uint32_t clock;
    struct rb_root rb_root;
    struct rb_node *rb_leftmost;
    uint32_t nr_running;
    struct sche_entity *curr;
    struct spinlock lock;
};

#define ACQUIRE_PROC acquire(&cfs->lock)
#define RELEASE_PROC release(&cfs->lock)



#endif
