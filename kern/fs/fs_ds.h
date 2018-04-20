#ifndef __FS_DATASTRUCT_H_
#define __FS_DATASTRUCT_H_



#ifndef uint
#define uint unsigned int
#endif
#ifndef _off_t
#define _off_t unsigned int
#endif

#define SUPER_NODE_MAGIC_NUM 0x32f490c8
#define EXTENT_MAGIC_NUM 0x8bd94107
#define EXT_SIZE (512*8)
#define NODE_SIZE 64
#define MEXTS (EXT_SIZE / NODE_SIZE)

#ifndef INFS
#define INFS 0xFFFFFFFF
#define NIA (INFS)
#endif

#ifndef NIA
#define NIA (INFS)
#endif


#ifndef _BPT_NODE_
#define _BPT_NODE_

#define ORDER 5
#define KEYLEN ORDER
#define VALLEN (KEYLEN+1)
typedef struct node{
    char type;    //type: 0(general) 1(leaf)
    char num_keys;
    short empty1;
    _off_t parent;
    _off_t keys[KEYLEN];
    _off_t vals[VALLEN];
    _off_t where;
    _off_t next;
    int empty2;
}node ;
#endif

#define DEFAULT_SUPERNODE_SEC 0
#define SP_EXT 0
#define SP_EXT_OFFSET 0
typedef struct supernode{
    char boot_loader[512];
    uint magic_num;
    /****meta_extent****/
    uint me_st_ext;
    uint me_ext_nums;
    _off_t me_root;

    uint me_all_nums; 
    volatile uint me_free_nums;
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

}supernode;



typedef struct {
    char *name;
    void (*begin_fs_op)(void);    
    void  (*end_fs_op)(void);
    void* (*map_disk)(_off_t sec, _off_t off);
    void* (*insert_ext)(void *root, _off_t key, _off_t val);
    _off_t (*find_ext)(void *root, _off_t sec);
    _off_t (*find_ext_near)(void *root, _off_t near);
    void* (*delete_ext)(void *root ,_off_t key);
    supernode* supernode_p;
}fs_low_class;

typedef struct extent{
    uint magic_num;
    _off_t e_where;
}extent;

#endif
