#include "basic_p.h"
#include "cfs.h"
#include "kmalloc.h"
#define MALLOC(m) kmalloc(m)
#define FREE(m) kfree(m)
#define rb_entry2se(p) rb_entry(p, struct sche_entity, rb_node)

struct cfs *cfs;
static void __enqueue_entity(struct sche_entity *se);

static void __dequeue_entity(struct sche_entity *se);
static void update_min_vruntime();
static inline int __se_cmp(struct sche_entity *a, struct sche_entity *b){
    return (int)(a->vruntime - b->vruntime) < 0;
}
void init_cfs()
{
    cfs = (struct cfs *)MALLOC(sizeof(struct cfs));
    cfs->min_vruntime = 0;
    cfs->clock = 0;
    cfs->rb_root = RB_ROOT;
    cfs->rb_leftmost = NULL;
    cfs->nr_running = 0;
    init_lock(&cfs->lock, "cfs sche");
}
static void __enqueue_entity(struct sche_entity *se)
{
    struct rb_node **new = &cfs->rb_root.rb_node;
    struct rb_node *parent = NULL;
    struct sche_entity *this;

    int leftmost = 1;
    while(*new)
    {
        parent = *new;
        this = rb_entry2se(parent);

        if(se_cmp(se, this))
        {
            new = &parent->rb_left;
        }else{
            new = &parent->rb_right;
            leftmost = 0;
        }
    }

    ACQUIRE_PROC;
    if(leftmost)
        cfs->rb_leftmost = &se->rb_node;

    rb_link_node(&se->rb_node, parent, new);
    rb_insert_color(&se->rb_node, &cfs->rb_root);
    
    RELEASE_PROC;
}
void init_entity(struct sche_entity *se, int prio)
{
    se->prio = prio;
    se->sum_exec_runtime = 0;
    se->prev_sum_exec_runtime = 0;
    se->on_rq = 1;
    //se->vruntime = ?;
}
void enqueue_entity(struct sche_entity *se, int flag)
{
    //deal flag in the future
    __enqueue_entity(se);

    se->on_rq = 1;
}

static void __dequeue_entity(struct sche_entity *se)
{
    if(cfs->rb_leftmost == &se->rb_node){
        struct rb_node *next_node;
        
        next_node = rb_next(&se->rb_node);
        cfs->rb_leftmost = next_node;
    }
    ACQUIRE_PROC;
    rb_erase(&se->rb_node, &cfs->rb_root);
    RELEASE_PROC;
    cfs->nr_running += 1;

} 

static inline uint32_t min_vruntime(uint32_t min_vruntime, uint32_t vruntime)
{
	int32_t delta = (int32_t)(vruntime - min_vruntime);
	if (delta < 0)
		min_vruntime = vruntime;

	return min_vruntime;
}

static inline uint32_t max_vruntime(uint32_t min_vruntime, uint32_t vruntime)
{
	int32_t delta = (int32_t)(vruntime - min_vruntime);
	if (delta > 0)
	{
		min_vruntime = vruntime;
    }
	return min_vruntime;
}

static void update_min_vruntime()
{
    uint32_t vruntime = cfs->min_vruntime;

    if(cfs->curr)
    {
        vruntime = cfs->curr->vruntime;
    }

    if(cfs->rb_leftmost)
    {
        struct sche_entity *se = rb_entry2se(cfs->rb_leftmost);

        if(!cfs->curr){
            vruntime = se->vruntime;
        }else{
            vruntime = min_vruntime(vruntime, se->vruntime);
        }
    }

    cfs->min_vruntime = max_vruntime(cfs->min_vruntime, vruntime);
}


void dequeue_entity(struct sche_entity *se)
{
    __dequeue_entity(se);
    se->on_rq = 0;

    update_min_vruntime();
}



