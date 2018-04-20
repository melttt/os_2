#include "basic_p.h"
#include "kmalloc.h"
#include "kdebug.h"
#include "stdio.h"

#include "ext.h"
#include "fs_ds.h"
#include "fs_interface.h"





fs_low_class* fs_f;

static void *get_node_ptr(_off_t n)
{
    if(n == NIA)
    {
        return NULL;
    }else{
        return fs_f->map_disk(1 + n / MEXTS , n % MEXTS * NODE_SIZE);
    }

}



static void test(int bg, int ed)
{
//    _extent *ex;
//    int i = 0;
    cprintf("find test bg : %d, ed : %d\n", bg, ed);
    int ret;
    void *root;
    cprintf("123456781234");
    while(bg < ed)
    {

            fs_f->begin_fs_op();

            root = get_node_ptr(fs_f->supernode_p->me_root);

//            root = bpt_delete(root, bg);
 //           root = bpt_insert(root ,bg ,bg);
            if((ret = fs_f->find_ext(root, bg)) != NIA)
            {
                cprintf("\b\b\b\b\b\b\b\b\b\b\b\bfid:%08d", bg);
            }else{
                panic("test error : %d\n",bg);
            }
            if(root)
                fs_f->supernode_p->me_root = ((node*)root)->where;
            else
                fs_f->supernode_p->me_root = NIA;

            fs_f->end_fs_op();
            bg ++;
    }
    cprintf("test ok\n");
}

int ext_init()
{
    fs_f = init_low_fs();

#if 1
    test(fs_f->supernode_p->e_st_ext, fs_f->supernode_p->e_st_ext +  fs_f->supernode_p->e_all_nums);

#endif
    return 1;
}


