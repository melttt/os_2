#ifndef __FS_DATASTRUCT_H_
#define __FS_DATASTRUCT_H_


#ifndef NULL
#define NULL ((void*)0)
#endif

#ifndef uint
#define uint unsigned int
#endif
#ifndef _off_t
#define _off_t unsigned int
#endif

#define SUPER_NODE_MAGIC_NUM 0x32f490c8
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
#define DEFAULT_MEXT_SEC 1

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
    uint mn_free_list_nums;
    _off_t mn_free_next_ext;

    /****data****/
    uint fdata_free_list_nums;
    _off_t fdata_free_next_ext;

    /****inode****/
    uint inode_free_list_nums;
    _off_t inode_free_next_ext;

}supernode;



typedef struct {
    char *name;
    void (*begin_fs_op)(void);    
    void  (*end_fs_op)(void);
    void* (*map_disk)(_off_t sec, _off_t off);
    void (*insert_ext)( _off_t key, _off_t val);
    _off_t (*find_ext)( _off_t sec);
    _off_t (*find_ext_near)( _off_t near);
    void (*delete_ext)(_off_t key);
    supernode* supernode_p;
}fs_low_class;

#define CALC_REAL_WHERE(h,l) (h << 8 | l)
#define GET_REAL_WEHRE_HIGHT(a) (a >> 8)
#define GET_REAL_WHERE_LOW(a) (a & (0xFF))


#define EXTENT_DATA_MAX_LEN 50 
typedef enum{E_TYPE_mn = 0, E_TYPE_fdata, E_TYPE_inode, E_TYPE_invalid} e_type_t;
#define EXTENT_MAGIC_NUM 0x8bd94107
#define EXTENT_SIZE 4096
#define ST_EXTENT_MAX_SIZE 512
typedef struct extent{
    uint magic_num;
    _off_t e_where;
    e_type_t  e_type;
    _off_t e_next_e;

    uint e_size;
    uint e_data_off;
    uint e_nums;
    char e_valid[EXTENT_DATA_MAX_LEN];
    char e_len;
    
}extent;



#define MN_MAGIC_NUM 0x5d4329aa
//meta_node
typedef struct _mn{
    uint magic_num;  
    _off_t real_where;
    node data; 
}mn;


typedef enum{ INODE_TYPE_INVALID, INODE_TYPE_DIR ,INODE_TYPE_FILE,INODE_TYPE_DEV } i_t;
typedef struct{
    i_t type;    
    short nlink;
    _off_t size;
    _off_t root_rwhere;
}rinode_t;

#define INODE_MAGIC_NUM 0xb4385c7f
typedef struct _inode{
    uint magic_num; 
    _off_t real_where;
    rinode_t data;
}inode;


#define FDATA_MAGIC_NUM 0x90fcc345
#define FDATA_SIZE 512
#define FDATA_VALID(a) (a->magic_num == FDATA_MAGIC_NUM)
typedef struct _fdata{
    uint magic_num; 
    _off_t real_where;

    _off_t file_off;
    _off_t valid_len;
    char off_t[512];
}fdata;






#endif
