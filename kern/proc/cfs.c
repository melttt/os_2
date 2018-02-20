#include "basic_p.h"
#include "driver_p.h"
#include "cfs.h"
#include "kmalloc.h"
#include "sche.h"
#include "stdio.h"
#define MALLOC(m) kmalloc(m)
#define FREE(m) kfree(m)
#define ACQUIRE_PROC acquire(&cfs->lock);
#define RELEASE_PROC release(&cfs->lock);
#define rb_entry2se(p) rb_entry(p, struct sche_entity, rb_node)

int CFS_INFO(const char *msg, ... )
{
#if CFS_DEBUG
    cprintf(CFS_PRE);
    va_list ap;
    int cnt = 0;
    va_start(ap, msg);
    vcprintf(msg, ap);
    va_end(ap);
    return cnt;
#endif
}

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

static inline int se_cmp(struct sche_entity *a, struct sche_entity *b){
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


void init_cfs(struct sche_entity* init_se)
{
    cfs = (struct cfs *)MALLOC(sizeof(struct cfs));
    cfs->min_vruntime = 0;
    cfs->rb_root = RB_ROOT;
    cfs->rb_leftmost = NULL;
    cfs->nr_running = 0;
    cfs->curr = init_se;
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

    if(leftmost)
        cfs->rb_leftmost = &se->rb_node;

    rb_link_node(&se->rb_node, parent, new);
    rb_insert_color(&se->rb_node, &cfs->rb_root);
    
}
void init_entity(struct sche_entity *se, int prio)
{
    se->prio = prio;
    se->on_rq = 0;
    se->vruntime = cfs ? cfs->min_vruntime : 0;
    se->last_time = se->start_time = 0;
}

void enqueue_entity(struct sche_entity *se, int flag)
{
    ACQUIRE_PROC;
    se->vruntime = cfs->min_vruntime;

    //deal flag in the future
    //
    __enqueue_entity(se);
    se->on_rq = 1;
    cfs->nr_running ++;
    RELEASE_PROC;
}

static void __dequeue_entity(struct sche_entity *se)
{
    if(cfs->rb_leftmost == &se->rb_node){
        struct rb_node *next_node;
        next_node = rb_next(&se->rb_node);
        cfs->rb_leftmost = next_node;
    }
    rb_erase(&se->rb_node, &cfs->rb_root);
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


void dequeue_entity(struct sche_entity *prev, struct sche_entity *se)
{
    /*
        prev = curr;
        cfs->curr->prev_sum_exec_runtime = cfs->curr->sum_exec_runtime;

        cfs->curr = left_node;
        dequeue_entity(cfs->curr);
        */
    ACQUIRE_PROC;
    if(prev)
    {
        se->start_time = prev->last_time;
        cfs->curr = se;
    }else{
        se->start_time = get_time();
    }

    __dequeue_entity(se);
    se->on_rq = 0;
    cfs->nr_running --;
    update_min_vruntime();
    RELEASE_PROC;
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
    ACQUIRE_PROC;
    uint32_t now = get_time();
    struct sche_entity *curr = cfs->curr;
    uint32_t delta_time;

    if(!curr) 
    {
        return ;
    }

    delta_time = calc_delta_time(now, se->last_time);

    if(!delta_time)
        return;

    se->last_time = now;
    se->vruntime += calc_delta_fair(delta_time, se);

    update_min_vruntime();
    RELEASE_PROC;
}

static struct sche_entity *pick_first_entity()
{
	struct rb_node *left = cfs->rb_leftmost;

	if (!left)
		return NULL;

	return rb_entry2se(left);

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
    return 0;
}


struct sche_entity*
get_next_se(struct sche_entity* first)
{
    return rb_entry2se( (rb_next(&first->rb_node)) ) ;
}

/*
int cfs_tick()
{
    struct sche_entity *curr = cfs->curr;
    struct sche_entity *prev = NULL;
    struct sche_entity *left_node = __pick_first_entity(cfs);

    //update_cfs_clock();
    update_curr(curr);
    if(check_preempt_tick(curr))
    {
        dequeue_entity(curr, left_node);
        enqueue_entity(curr);
        return 1;
    }
   return 0; 
}
*/

struct sche_class default_sche_class = {
     .name = "cfs",
     .init = init_cfs,
     .enqueue = enqueue_entity,
     .dequeue = dequeue_entity,
     .pick_first = pick_first_entity,
     .proc_tick = update_curr,
     .init_se = init_entity,
     .pick_next = get_next_se,
};
