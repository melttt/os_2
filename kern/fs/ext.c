#include "basic_p.h"
#include "kmalloc.h"
#include "kdebug.h"
#include "stdio.h"
#include "cache.h"



#include "bplustree.h"
#include "ext.h"



_ext_manager ext_manager;

//m_ext
inline static void* get_me(int n)
{
   return  mapping_file(EXT_M_SP->me_st_ext + n / MEXTS , n % MEXTS * sizeof(node));
}


    static int need  = 0;
static node* malloc_node(node **a)
{
    _off_t next_pos;
    
    if(EXT_M_SP->me_free_nums == 0) 
        panic("malloc_node no enough room, need : %d\n", need);

    ACQUIRE_SP;
    next_pos = EXT_M_SP->me_free_next_me;
    RELEASE_SP;
    (*a) = get_me(next_pos);    
    ACQUIRE_SP;
//    cprintf("next_pos:%08x\n", next_pos);
    EXT_M_SP->me_free_next_me = (*a)->next;
    EXT_M_SP->me_free_nums --;
    need ++;
    RELEASE_SP;

    (*a)->next = NIA; 
    (*a)->num_keys = 0;
    (*a)->parent = NIA;
    return (*a);
}

int xx = 0;
static void free_node(node *a)
{
    _off_t tmp;
    ACQUIRE_SP;
    xx ++;
    tmp = EXT_M_SP->me_free_next_me;
    a->next = tmp;
    EXT_M_SP->me_free_next_me = a->where;
    EXT_M_SP->me_free_nums ++;
    RELEASE_SP;
}


static node* get_node_ptr(_off_t n)
{
    if(n >= EXT_M_SP->me_all_nums)
    {
        if(n != NIA)
        {
            panic("get_node_ptr over extent:%d\n");
        }
        return NULL;
    }else{
        return get_me(n);
    }
}


typedef struct _extent{
    unsigned int magic_num;
    _off_t e_where;
}_extent;
static void test(int bg, int ed)
{
//    _extent *ex;
//    int i = 0;
    cprintf("find test bg : %d, ed : %d\n", bg, ed);
    int ret;
node *root;
    while(bg < ed)
    {

            begin_op();
            root = get_node_ptr(EXT_M_SP->me_root);
            if(root == NULL)
            {

            }
//            root = bpt_delete(root, bg);
            root = bpt_insert(root ,bg ,bg);
            if((ret = bpt_find(root, bg)) != NIA)
            {
                cprintf("ret:%08d , xx : %d ,need : %d\n", bg, xx ,need);
            }else{
                panic("ret : %d\n",bg);
            }
            if(root)
                EXT_M_SP->me_root = root->where;
            else
                EXT_M_SP->me_root = NIA;
            end_op();
            bg ++;
    }
    cprintf("test ok\n");
}
void ext_init()
{
        cache_init();
        
        begin_op();
        memcpy(EXT_M_SP, mapping_file(0, 0) ,sizeof(supernode));
        end_op();
        init_lock(EXT_M_LOCK, "SP_LOCK");
        EXT_M_VALID = 1; 
        cprintf(INITOK"ext init ok\n");
        
        if(EXT_M_SP->magic_num == SUPER_NODE_MAGIC_NUM)
        {
            cprintf("supernode infomation:\n");
            cprintf("me_ext_nums : %d\nme_all_nums : %d\n", EXT_M_SP->me_ext_nums, EXT_M_SP->me_all_nums);
            cprintf("me_free_nums : %d\n,me_next_pos:%d\n", EXT_M_SP->me_free_nums ,EXT_M_SP->me_free_next_me);
            cprintf("ext_st : %d\n ext_all_nums : %d\n", EXT_M_SP->e_st_ext ,EXT_M_SP->e_all_nums);

//
            test(EXT_M_SP->e_st_ext, EXT_M_SP->e_st_ext + EXT_M_SP->e_all_nums);
//
            
            begin_op();
           // EXT_M_SP->me_free_nums = 0;
           cprintf("xx : %d\n", xx);
            memcpy( mapping_file(0, 0) ,EXT_M_SP,sizeof(supernode));
            end_op();
            
        }else{
            cprintf("invalid\n");
            test(EXT_M_SP->e_st_ext, EXT_M_SP->e_st_ext + EXT_M_SP->e_all_nums);
        }

}






