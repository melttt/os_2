#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

#include "../kern/fs/fs_ds.h"
#include "../libs/bplustree.h"
#include "mkfs_interface.h"



#define ESTIMATE_LEN (MEXTS*60)
//#define FILE_PATH "../fs.img"
typedef struct{
    int  fd;  
    char *filename;
    uint disk_all_ext_nums;
    uint me_cur;
    node mext[ESTIMATE_LEN];
    int  mext_index;
    supernode sp;
}_mkfs_info;
_mkfs_info mkfs_info;

#define MK_CUR (mkfs_info.me_cur)
#define MK_FILENAME (mkfs_info.filename)
#define MK_INDEX (mkfs_info.mext_index)
#define MK_FD ((mkfs_info.fd))
#define MK_SUM (mkfs_info.disk_all_ext_nums)
#define MK_ARR (mkfs_info.mext)
#define MK_SP (mkfs_info.sp)

/*************************bplustree************************/
static node* malloc_node(node **a)
{
    if(MK_INDEX >= ESTIMATE_LEN)
    {
        printf("malloc_node over extent\n");
        exit(2);
    }

    *a = &MK_ARR[MK_INDEX];
    (*a)->next = NIA;
    (*a)->where = MK_INDEX;

    MK_INDEX ++;

    if(MK_INDEX % MEXTS == 0)
    {
        MK_CUR ++;
    }
    
    MK_SP.me_all_nums ++;
    return (*a);
}

static void free_node(node *a)
{
    a->next = MK_SP.me_free_next_me;
    MK_SP.me_free_next_me = a->where;
    MK_SP.me_free_nums ++;
}
static node* get_node_ptr(_off_t n)
{
    if(n >= 0 && n < ESTIMATE_LEN)
        return &MK_ARR[n];
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

/*************utiles***************/
static uint get_file_size(const char *path)
{
    uint filesize = -1;
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
    ext_num = get_file_size(MK_FILENAME) / EXT_SIZE;
    return ext_num;
}

static void read_n_ext(_off_t n, void *buf)
{
    lseek(MK_FD, n * EXT_SIZE, SEEK_SET);
    read(MK_FD, buf, EXT_SIZE);
}
static void write_n_ext(_off_t n, void *buf)
{
    lseek(MK_FD, n * EXT_SIZE, SEEK_SET);
    write(MK_FD, buf,EXT_SIZE);
    fsync(MK_FD);   
}

static void init_supernode()
{
    MK_SP.magic_num = SUPER_NODE_MAGIC_NUM;
    //meta_extent
    MK_SP.me_st_ext= 1;
    MK_SP.me_root = NIA;
    MK_SP.me_all_nums = 0;
    MK_SP.me_free_nums = 0;
    MK_SP.me_free_next_me = NIA;
    //ext
    MK_SP.e_st_ext = NIA;
    MK_SP.e_all_nums = 0;
    MK_SP.e_free_nums = 0;
    //meta_node
    MK_SP.mn_free_list_nums = 0;
    //data
    MK_SP.fdata_free_list_nums = 0;
    MK_SP.fdata_free_next_ext = 0;
    //inode
    MK_SP.inode_free_list_nums = 0;
    MK_SP.inode_free_next_ext = NIA;
    //other
    MK_SP.root_inode_where = NIA;
}
static int init_mkfs_info()
{
    int ret;
    MK_FD = open(MK_FILENAME, O_RDWR);
    MK_SUM = ret = calc_ext_nums();    
    MK_CUR = 1;
    init_supernode();
    return ret;
}

static void write_fs_to_disk()
{
    int k;
    _off_t st = DEFAULT_MEXT_SEC;
    _off_t ed = st + MK_SP.me_ext_nums;
    //write sp_node
    lseek(MK_FD, 0, SEEK_SET);
    write(MK_FD, &MK_SP, sizeof(MK_SP));
    fsync(MK_FD);   
    for(k = 0 ; st < ed ; st += 1, k += MEXTS )
    {
        write_n_ext(st, &MK_ARR[k]); 
    }
    printf("ok\n");

}

/**************test function******************/
void load_mext()
{
    char buf[EXT_SIZE];
    read_n_ext(0, buf);
    //load supernode
    MK_SP = *((supernode*)buf);

    if(MK_SP.magic_num != SUPER_NODE_MAGIC_NUM)
    {
        printf("supernode wrong num %x\n", MK_SP.magic_num);
        exit(2);
    }

    //load me to cache
    _off_t st = MK_SP.me_st_ext;
    _off_t ed = MK_SP.me_ext_nums + st;

    int k = 0;
    //
    for( ; st < ed ; k += MEXTS , st += 1 )
    {
        read_n_ext(st, &MK_ARR[k]);
    }
    printf("load over\n");
}


void test_mext()
{
    int bg =  MK_SP.e_st_ext;
    int ed = MK_SP.e_all_nums + bg;
    char xx[4096];
    int tmp;

    node *root = get_node_ptr(MK_SP.me_root);
    
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

void mkfs()
{
    init_mkfs_info();
    //init node and extent
    node *root = NULL;
    _off_t cur_ext = MK_SUM - 1;

    extent tmp_extent;
    memset(&tmp_extent, 0, sizeof(extent));
    tmp_extent.magic_num = EXTENT_MAGIC_NUM;
    
    //the kernel of mkfs
    for(;MK_CUR * 5 / 4 < cur_ext ; cur_ext --)
    {
        tmp_extent.e_where = cur_ext;
        root = bpt_insert(root, cur_ext, cur_ext); 
        write_n_ext(cur_ext, &tmp_extent);
        if(bpt_find(root, cur_ext) == cur_ext)
            printf("\b\b\b\b\b\b\b\b\b\b\b\b\bindex:%07d",cur_ext);
        else
            printf("insert error, no find\n");
    }
    //padding the rest of room
    node *t;
    for( ; MK_CUR < cur_ext + 1 ;)
    {
        malloc_node(&t);
        free_node(t);
    }

    //write supernode
    MK_SP.me_st_ext = DEFAULT_MEXT_SEC;
    MK_SP.me_root = root->where;
    MK_SP.me_ext_nums = cur_ext + 1 - DEFAULT_MEXT_SEC ;
    MK_SP.e_st_ext = cur_ext + 1;
    MK_SP.e_free_nums = MK_SP.e_all_nums = MK_SUM - MK_SP.e_st_ext;
    //test_mext();
    write_fs_to_disk();

    printf("mkfs ok....final\n");
    printf("info:\n me_ext_num : %d me_all_num : %d \n e_st : %d e_nums:%d \n all_exts:%d \n",MK_SP.me_ext_nums ,MK_SP.me_all_nums, MK_SP.e_st_ext, MK_SP.e_all_nums ,MK_SUM);
}




int main(int ac, char *av[])
{
    int opt;
    char *addfile[2]; 
    int flag = 0;
    while ((opt = getopt(ac, av, "ltmf:a:")) != -1) {
        switch (opt) {
            case 'a':
                addfile[1] = optarg; 
                break;
            case 't':
                init_mkfs_info();
                load_mext();
                test_mext();
                break;
            case 'm':
                mkfs();
                loadfile(2, addfile); 
                break;
            case 'l':
                loadfile(2, addfile); 
                break;
            case 'f':
                addfile[0] = optarg;
                MK_FILENAME = optarg;
                break;
            default: 
                printf( "Usage: %s [-f filename] [-n] name\n",av[0]);
                exit(EXIT_FAILURE);
        }
    }
    printf("over!\n");
    return 0;

}
