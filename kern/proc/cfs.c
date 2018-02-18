#include "basic_p.h"
#include "driver_p.h"
#include "cfs.h"
#include "kmalloc.h"
#include "sche.h"
#define MALLOC(m) kmalloc(m)
#define FREE(m) kfree(m)
#define rb_entry2se(p) rb_entry(p, struct sche_entity, rb_node)
uint32_t prio_to_vruntime[] = {
    [0] = 1,
    [1] = 2,
    [2] = 3,
    [3] = 4,
    [4] = 5,
    [5] = 6,
    [6] = 7,
    [7] = 8,
    [8] = 9,
    [9] = 10,
};

struct cfs *cfs;
static void __enqueue_entity(struct sche_entity *se);
static void __dequeue_entity(struct sche_entity *se);
static void update_min_vruntime();

static inline int __se_cmp(struct sche_entity *a, struct sche_entity *b){
    return (int)(a->vruntime - b->vruntime) < 0;
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
    se->on_rq = 0;
    //se->vruntime = ?;
}
void enqueue_entity(struct sche_entity *se, int flag)
{
    se->vruntime = cfs->min_vruntime;
    //deal flag in the future
    __enqueue_entity(se);

    se->on_rq = 1;
    cfs->nr_running ++;
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
    cfs->nr_running -= 1;
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


static inline uint32_t 
calc_delta_fair(uint32_t delta, struct sche_entity *se)
{
    return prio_to_vruntime[se->prio] * delta; 
}

static inline uint32_t
calc_delta_time(uint32_t clock, uint32_t last_time)
{
    return clock > last_time ? (clock - last_time) : (UINT32_MAX - last_time + clock);
}
static void update_curr(struct sche_entity *se)
{
    uint32_t now = cfs->clock;
    struct sche_entity *curr = cfs->curr;
    uint32_t delta_time;

    if(!curr) return;

    delta_time = calc_delta_time(now, se->last_time);

    if(!delta_time)
        return;

    se->last_time += delta_time;
    se->vruntime += calc_delta_fair(delta_time, se);

    update_min_vruntime();
}

static struct sched_entity *pick_first_entity(struct cfs *cfs)
{
	struct rb_node *left = cfs->rb_leftmost;

	if (!left)
		return NULL;

	return (struct sched_entity*)rb_entry2se(left);
}
int check_preempt_tick(struct sche_entity *curr)
{
    uint32_t ideal_runtime, delta_time;
    struct sche_entity *se;
    int32_t delta;

    ideal_runtime = 20;
    delta_time = curr->start_time - curr->last_time;
    if(delta_time > ideal_runtime)
    {
        return 1;
    }

    se = pick_first_entity(cfs);
    delta = curr->vruntime - se->vruntime;

    if(delta < 0)
        return 0;
    if(delta > ideal_runtime)
        return 1;
}

/*
void cfs_tick()
{
    struct sche_entity *curr = cfs->curr;
    struct sche_entity *prev = NULL;
    struct sche_entity *left_node = __pick_first_entity(cfs);

    //update_cfs_clock();
    update_curr(curr);
    if(check_preempt_tick(curr))
    {
        prev = curr;
        cfs->curr->prev_sum_exec_runtime = cfs->curr->sum_exec_runtime;

        cfs->curr = left_node;
        __enqueue_entity(prev);
        cfs->nr_running ++;
        dequeue_entity(cfs->curr);
    }
    
}
*/

struct sched_class default_sched_class = {
     .name = "cfs",
     .init = init_cfs,
     .enqueue = enqueue_entity,
     .dequeue = dequeue_entity,
     .pick_next = NULL,
     .proc_tick = NULL,
};
