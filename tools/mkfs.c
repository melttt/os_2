#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

#include "bplustree.h"
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


#define FILE_PATH "fs.img"
typedef unsigned int uint;
#define DEFAULE_ME_START_SEC 1
#define DEFAULT_SP_START_SEC 0
typedef struct supernode{
    char boot_loader[512];
    unsigned int magic_num;
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
supernode fs_supernode;

typedef struct extent{
    unsigned int magic_num;
    _off_t e_where;
}extent;


//get file size
size_t get_file_size(const char *path)
{
    size_t filesize = -1;
    struct stat statbuf;
    if(stat(path, &statbuf) < 0)
    {
        return filesize;
    }

    filesize = statbuf.st_size;
    return filesize;
}

int calc_ext_nums();
inline int calc_ext_nums()
{
    int ext_num;
    ext_num = get_file_size(FILE_PATH) / EXT_SIZE;
    return ext_num;
}


//global variates
typedef struct{
    uint ext_nums;
    int fd;  
    uint me_now;

}_mkfs_info;
_mkfs_info mkfs_info;
#define ME_NOW (mkfs_info.me_now)


#define MKFS_FD ((mkfs_info.fd))

_off_t mext_id = 1;
_off_t mext_st;
#define ESTIMATE_LEN (MEXTS*1800)
node mext[ESTIMATE_LEN];
int mext_c = 0;

static void read_n_ext(_off_t n, void *buf)
{
    lseek(MKFS_FD, n * EXT_SIZE, SEEK_SET);
    read(MKFS_FD, buf, EXT_SIZE);
}
static void write_n_ext(_off_t n, void *buf)
{
    lseek(MKFS_FD, n * EXT_SIZE, SEEK_SET);
    write(MKFS_FD, buf,EXT_SIZE);
    fsync(MKFS_FD);   
}

static node* malloc_node(node **a)
{
    static uint pos = 0;
    if(mext_c >= ESTIMATE_LEN)
    {
        printf("malloc_node over extent\n");
        exit(2);
    }

    *a = &mext[pos];
    (*a)->where = pos;

    pos ++;

    if(pos % MEXTS == 0)
    {
        ME_NOW ++;
    }
    
    fs_supernode.me_all_nums ++;
    return (*a);
}

static void free_node(node *a)
{
    a->next = fs_supernode.me_free_next_me;
    fs_supernode.me_free_next_me = a->where;
    fs_supernode.me_free_nums ++;
}


static node* get_node_ptr(_off_t n)
{
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
}


void init_supernode()
{
    fs_supernode.magic_num = SUPER_NODE_MAGIC_NUM;
    //meta_extent
    fs_supernode.me_st_ext= 1;
    fs_supernode.me_root = NIA;

    fs_supernode.me_all_nums = 0;
    fs_supernode.me_free_nums = 0;
    fs_supernode.me_free_next_me = NIA;


    //ext
    fs_supernode.e_st_ext = NIA;
    fs_supernode.e_all_nums = 0;
    fs_supernode.e_free_nums = 0;

    //meta_node
    fs_supernode.mn_nums = 0;
    fs_supernode.mn_free_next_ext = NIA;

    //data
    fs_supernode.data_nums = 0;
    fs_supernode.data_free_next_ext = NIA;

    //inode
    fs_supernode.inode_nums = 0;
    fs_supernode.inode_free_next_ext = NIA;
    
    //other
    fs_supernode.is_valid = 1;
}


void write_fs_to_disk()
{
    int k;
    _off_t st = DEFAULE_ME_START_SEC;
    _off_t ed = st + fs_supernode.me_ext_nums;
    write_n_ext(DEFAULT_SP_START_SEC, &fs_supernode);

    printf("start write to disk");
    for(k = 0 ; st < ed ; st += 1, k += MEXTS )
    {
        write_n_ext(st, &mext[k]); 
    }

}

void load_mext()
{
    char buf[EXT_SIZE];
    read_n_ext(0, buf);

        //printf("asd\n");
    //load supernode
    fs_supernode = *((supernode*)buf);

    if(fs_supernode.magic_num != SUPER_NODE_MAGIC_NUM)
    {
        printf("supernode wrong num %x\n", fs_supernode.magic_num);
        exit(2);
    }

    //load me to cache
    _off_t st = fs_supernode.me_st_ext;
    _off_t ed = fs_supernode.me_ext_nums + st; 

    int k = 0;
    //
    for( ; st < ed ; k += MEXTS , st += 1 )
    {
        read_n_ext(st, &mext[k]); 
    }
    printf("load over\n");
}


void test_mext()
{
    int bg =  fs_supernode.e_st_ext;
    int ed = fs_supernode.e_all_nums + bg;
    char xx[4096];
    int tmp;

    node *root = get_node_ptr(fs_supernode.me_root);

    for( ; bg < ed ; bg ++)
    {
        if((tmp = bpt_find(root, bg)) == -1)
        {
            printf("%d find error\n", bg);
            exit(2);
        }else{
            read_n_ext(tmp, xx);

            if(((extent*)xx)->magic_num == EXTENT_MAGIC_NUM)
                printf("find :%d! where : %x\n", bg, ((extent*)xx)->e_where);
        }
    }

    printf("pass test!\n");
}

int init_mkfs_info()
{
    int ret;
    mkfs_info.fd = open(FILE_PATH, O_RDWR);
    mkfs_info.ext_nums = ret = calc_ext_nums();    
    ME_NOW = 1;


    printf("filename :%s , ext_nums : %d\n",FILE_PATH, mkfs_info.ext_nums);
    return ret;
}



void mkfs(char* cmd)
{

    int exts;
    exts =  init_mkfs_info();
    if(strcmp(cmd, "m") == 0)
    {
        init_supernode();

        //init node and extent
        node *root = NULL;
        extent *tmp_extent = malloc(EXT_SIZE);
        memset(tmp_extent, 0, EXT_SIZE);
        tmp_extent->magic_num = EXTENT_MAGIC_NUM;

        //end of ext
        off_t cur_ext = exts - 1;

        //insert node
        for(;ME_NOW < cur_ext ; cur_ext --)
        {
            tmp_extent->e_where = cur_ext;
            root = bpt_insert(root, cur_ext , cur_ext); 
            write_n_ext(cur_ext, tmp_extent);
            if(bpt_find(root, cur_ext) == cur_ext)
                printf("\b\b\b\b\b\b\b\b%08d", cur_ext);
        }
        printf("\n");

        
        //write supernode
        fs_supernode.me_st_ext = DEFAULE_ME_START_SEC;
        fs_supernode.me_root = root->where;
        fs_supernode.me_ext_nums = cur_ext + 1 - DEFAULE_ME_START_SEC ;

        fs_supernode.e_st_ext = cur_ext + 1;
        fs_supernode.e_free_nums = fs_supernode.e_all_nums = exts - fs_supernode.e_st_ext;


//        test_mext();

        write_fs_to_disk();
        printf("mkfs ok....final\n");
        printf("info:\n me_ext_num : %d me_all_num : %d \n e_st : %d  e_nums : %d \n all_exts : %d \n",fs_supernode.me_ext_nums ,fs_supernode.me_all_nums, fs_supernode.e_st_ext, fs_supernode.e_all_nums ,exts );

    }else{
        load_mext();
        test_mext();

    }

    
}

int main(int ac ,char **av)
{
    if(ac != 2)
    {
        printf("mkfs t(test) or mkfs m(make fs)");
        exit(2);
        
    }else{
        if(sizeof(node) > 64 || sizeof(supernode) > 4096)
        {
            printf("error size of node or supernode\n exit ...");
            return 1;
        }
        printf("size of node :%d %s\n", sizeof(node), av[1]);
        
        mkfs(av[1]);

    }

    return 0;
}
