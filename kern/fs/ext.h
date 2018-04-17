#ifndef __KERN_FS_EXT_H_
#define __KERN_FS_EXT_H_


#ifndef uint
#define uint unsigned int
#endif
#ifndef _off_t
#define _off_t unsigned int
#endif

#define SUPER_NODE_MAGIC_NUM 0x32f490c8
#define EXTENT_MAGIC_NUM 0x8bd94107
#define EXT_SIZE (512*8)
#define MEXTS (EXT_SIZE / sizeof(node))

#ifndef INFS
#define INFS 0xFFFFFFFF
#define NIA (INFS)
#endif

#ifndef NIA
#define NIA (INFS)
#endif

#define DEFAULT_SUPERNODE_SEC 0
typedef struct supernode{
    char boot_loader[512];
    uint magic_num;
    /****meta_extent****/
    uint me_st_ext;
    uint me_ext_nums;
    _off_t me_root;

    uint me_all_nums; 
    uint me_free_nums;
    uint me_free_next_me;
     
    /****ext****/
    _off_t e_st_ext;
    uint e_all_nums;
    uint e_free_nums;

    /****meta_node****/
    uint mn_nums;
    _off_t mn_free_next_ext;

    /****data****/
    uint data_nums;
    _off_t data_free_next_ext;

    /****inode****/
    uint inode_nums;
    _off_t inode_free_next_ext;
    
    //other
    char is_valid;

}supernode;

typedef struct extent{
    uint magic_num;
    _off_t e_where;
}extent;



void ext_init();

#endif
