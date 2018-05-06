#include "basic_p.h"
#include "kmalloc.h"
#include "kdebug.h"
#include "stdio.h"
#include "cache.h"
#include "string.h"

#include "bplustree.h"
#include "fs_interface.h"
_fs_manager fs_manager;


//m_ext
inline static void* get_me(int n)
{
   assert(FS_M_VALID == 1);
   return  mapping_file(FS_M_SP->me_st_ext + n / MEXTS , n % MEXTS * sizeof(node));
}

static node* malloc_node(node **a)
{
    _off_t next_pos;
    
    if(FS_M_SP->me_free_nums == 0) 
        panic("malloc_node no enough room\n");

    ACQUIRE_SP;
    next_pos = FS_M_SP->me_free_next_me;
    RELEASE_SP;
    (*a) = get_me(next_pos);    
    ACQUIRE_SP;
    FS_M_SP->me_free_next_me = (*a)->next;
    FS_M_SP->me_free_nums --;
    RELEASE_SP;

    (*a)->next = NIA; 
    (*a)->num_keys = 0;
    (*a)->parent = NIA;
    return (*a);
}

static void free_node(node *a)
{
    _off_t tmp;
    ACQUIRE_SP;
    tmp = FS_M_SP->me_free_next_me;
    a->next = tmp;
    FS_M_SP->me_free_next_me = a->where;
    FS_M_SP->me_free_nums ++;
    RELEASE_SP;
}


static node* get_node_ptr(_off_t n)
{
    if(n >= FS_M_SP->me_all_nums)
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


//interface:1
static void begin_fs_op()
{

     begin_cache(); 
     if(FS_M_VALID == 0)
         memcpy(FS_M_SP, mapping_file(SP_EXT, SP_EXT_OFFSET),sizeof(supernode));

}

//interface:2
static void end_fs_op()
{

    //update_fs
    memcpy(mapping_file(SP_EXT, SP_EXT_OFFSET) ,FS_M_SP,sizeof(supernode));
    end_cache();
}

//interface:3
static void* map_disk(_off_t sec,_off_t off)
{
    if(FS_M_VALID == 0) panic("map_disk wrong\n");
    return  mapping_file(sec ,off);
}

//interface:4
static void insert_ext(_off_t key , _off_t val)
{
    node *root = get_me(FS_M_SP->me_root);
    root = bpt_insert(root ,key ,val);
    FS_M_SP->me_root = root->where;
    FS_M_SP->e_all_nums ++;
    FS_M_SP->e_free_nums ++;
}

//interface:5
static _off_t find_ext( _off_t sec)
{
    node *root = get_me(FS_M_SP->me_root);
    return bpt_find(root, sec);
}
//interface:6
static _off_t find_ext_near(_off_t near)
{
    node *root = get_me(FS_M_SP->me_root);
    return bpt_find_near(root ,near);
}


//interface:7
static void delete_ext(_off_t key)
{
    node *root = get_me(FS_M_SP->me_root);
    root = bpt_delete(root ,key);
    FS_M_SP->me_root = root->where;
    FS_M_SP->e_all_nums --;
    FS_M_SP->e_free_nums --;
}


static fs_low_class fs_f;
fs_low_class* init_low_fs()
{
    cache_init();
    FS_M_VALID = 0; 

    begin_fs_op();
    init_lock(FS_M_LOCK, "SP_LOCK");
    if(FS_M_SP->magic_num == SUPER_NODE_MAGIC_NUM)
    {
        assert(sizeof(node) == NODE_SIZE);
#if KERN_INFO
        cprintf("supernode infomation:\n");
        cprintf("me_ext_nums:%d\nme_all_nums:%d\n", FS_M_SP->me_ext_nums, FS_M_SP->me_all_nums);
        cprintf("me_free_nums:%d\n,me_next_pos:%d\n", FS_M_SP->me_free_nums ,FS_M_SP->me_free_next_me);
        cprintf("ext_st:%d\next_all_nums:%d\n", FS_M_SP->e_st_ext ,FS_M_SP->e_all_nums);
#endif 
        fs_f.name = "LOW_FS_FUNCTION";
        fs_f.begin_fs_op = begin_fs_op;
        fs_f.end_fs_op = end_fs_op;
        fs_f.map_disk = map_disk;
        fs_f.insert_ext = insert_ext;
        fs_f.find_ext = find_ext;
        fs_f.find_ext_near = find_ext_near;
        fs_f.delete_ext = delete_ext;
        fs_f.supernode_p = FS_M_SP;

        FS_M_VALID = 1; 
        cprintf(INITOK"fs_interface init ok\n");
    }else{
        panic("low_fs_init error!\n");
    }
    end_fs_op();

    return &fs_f;
}



