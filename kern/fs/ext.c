#include "basic_p.h"
#include "kmalloc.h"
#include "kdebug.h"
#include "stdio.h"
#include "cache.h"



#include "bplustree.h"
#include "ext.h"

supernode sp;


//m_ext
inline static void get_me(int n, node *buf)
{
    cache_read(sp.me_st_ext + n / MEXTS , n % MEXTS * sizeof(node) , buf , sizeof(buf));
}


static node* malloc_node(node **a)
{
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

void ext_init()
{
        cache_init();
        cache_read(DEFAULT_SUPERNODE_SEC ,0 ,&sp ,sizeof(sp));
        assert(sizeof(node) == 64);
        if(sp.magic_num == SUPER_NODE_MAGIC_NUM)
        {
            cprintf("me_ext_nums : %d\n me_all_nums : %d\n", sp.me_ext_nums, sp.me_all_nums);
            cprintf("ext_st : %d \n ext_all_nums : %d\n", sp.e_st_ext ,sp.e_all_nums);
        }else{
            cprintf("invalid\n");
        }

}







