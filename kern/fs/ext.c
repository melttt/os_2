#include "basic_p.h"
#include "kmalloc.h"
#include "kdebug.h"
#include "stdio.h"
#include "cache.h"



#include "bplustree.h"
#include "ext.h"

supernode sp;
#if 1

//m_ext
inline static void* get_me(int n)
{
   return  mapping_file(sp.me_st_ext + n / MEXTS , n % MEXTS * sizeof(node));
}


static node* malloc_node(node **a)
{
    panic("malloc_node\n");
    static uint pos = 0;
    if(pos >= 0x140000)
    {
        panic("malloc_node over extent\n");
    }

    *a = kmalloc(sizeof(node));
    (*a)->where = pos;

    pos ++;
    
    sp.me_all_nums ++;
    return (*a);
}

static node* get_node_ptr(_off_t n)
{
    return (node*)get_me(n);
    /*
    if(n >= 0 && n < ESTIMATE_LEN)
        return &mext[n];
    else
    {
        if(n == NIA)
            return NULL;
        else{
            printf("get_node_ptr over extent , %d\n", n);
            exit(2);
        }
    }
    */
}

static void free_node(node * a)
{
    
}
#endif
typedef struct _extent{
    unsigned int magic_num;
    _off_t e_where;
}_extent;

static void test(int bg, int ed)
{
//    _extent *ex;
//    int i = 0;
    cprintf("123456781234");
    while(bg < ed)
    {
            begin_op();
            node *root = get_node_ptr(sp.me_root);
            int ret = bpt_find_near(root, bg);
            end_op();
            if(ret == bg)
            {
                cprintf("\b\b\b\b\b\b\b\b\b\b\b\bret:%08d", ret);
            }else{
                panic("ret : %d\n", ret);
            }
            bg ++;
/*
        if(i % 1000 == 0)
        begin_op();
        ex = mapping_file(bg, 0);
        if(ex->magic_num == 0x8bd94107) 
            cprintf("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b%08x->%08x",bg ,ex->e_where);
        else{
            panic("ex->magic_num:%x\n", ex->magic_num);
        }
        bg ++;
        i ++;
        if(i % 1000 == 0)
        end_op();
        */
    }
}
void ext_init()
{
        cache_init();

        begin_op();
        memcpy(&sp, mapping_file(0, 0) ,sizeof(sp));
        end_op();
        //assert(sizeof(node) == 64);
        
        if(sp.magic_num == SUPER_NODE_MAGIC_NUM)
        {
            cprintf("me_ext_nums : %d\n me_all_nums : %d\n", sp.me_ext_nums, sp.me_all_nums);
            cprintf("ext_st : %d \n ext_all_nums : %d\n", sp.e_st_ext ,sp.e_all_nums);
            test(sp.e_st_ext, sp.e_st_ext + sp.e_all_nums);
            
        }else{
            cprintf("invalid\n");
        }

}






