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
#define MEXT_SIZE (512*8)
#define MEXTS (MEXT_SIZE / sizeof(node))

#ifndef INFS
#define INFS 0xFFFFFFFF
#endif




typedef struct supernode{
    char boot_loader[512];
    unsigned int magic_num;
    /****meta_extent_num****/
    _off_t mext_st;
    _off_t mext_nums;
    _off_t where_mext_root;

    _off_t mext_free_nums;
    _off_t where_mext_free_next;


    /****ext****/
    _off_t ext_st;
    /****inode****/
    _off_t ext_inode_nums;
    _off_t where_ext_inode_free_next;

    /****data****/
    _off_t ext_data_nums;
    _off_t where_ext_data_free_next;

    /****meta_node****/
    _off_t ext_mnode_nums;
    _off_t where_ext_mnode_free_next;

}supernode;
supernode fs_supernode;

typedef struct extent{
    unsigned int magic_num;
    _off_t where;
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

extern int calc_ext_nums();
inline int calc_ext_nums()
{
    int ext_num;
    ext_num = get_file_size("fs.img") / MEXT_SIZE;
    return ext_num;
}



//global variates
_off_t ext_nums;
int fd;
_off_t mext_id = 1;
_off_t mext_st;
#define _TRY (MEXTS*1800)
node mext[_TRY];
int mext_c = 0;

void read_n_ext(_off_t n, void *buf)
{
    lseek(fd, n * MEXT_SIZE, SEEK_SET);
    read(fd, buf, MEXT_SIZE);
}
void write_n_ext(_off_t n, void *buf)
{
    lseek(fd, n * MEXT_SIZE, SEEK_SET);
    write(fd, buf, MEXT_SIZE);
    fsync(fd);   
}

node* malloc_node(node **a)
{
    if(mext_c >= _TRY)
    {
        printf("malloc_node over extent\n");
        exit(2);
    }

    *a = &mext[mext_c];
    (*a)->where = mext_c;

    mext_c ++;

    if(mext_c % MEXTS == 0)
    {
        mext_id ++;
    }
    
    return (*a);
}

node* free_node(node *a)
{
    a->next = fs_supernode.where_mext_free_next;
    fs_supernode.where_mext_free_next = a->where;
    fs_supernode.mext_free_nums ++;
}

node* get_node_ptr(_off_t n)
{
    if(n >= 0 && n < _TRY)
        return &mext[n];
    else
    {
        if(n == INFS)
            return NULL;
        else{
            printf("get_node_ptr over extent , %d\n", n);
            exit(2);
        }
    }
}

void init_supernode(supernode *a)
{
    fs_supernode.magic_num = SUPER_NODE_MAGIC_NUM;
    fs_supernode.mext_st = 1;
    fs_supernode.mext_nums = 0;

    fs_supernode.where_mext_root = INFS;
    fs_supernode.mext_free_nums = 0;
    fs_supernode.where_mext_free_next = INFS;

    fs_supernode.ext_st = INFS;

    fs_supernode.ext_inode_nums = 0;
    fs_supernode.where_ext_inode_free_next = INFS;

    fs_supernode.ext_data_nums = 0;
    fs_supernode.where_ext_data_free_next = INFS;

    fs_supernode.ext_mnode_nums = 0;
    fs_supernode.where_ext_mnode_free_next = INFS;
    
}


void check_write(_off_t len)
{
    _off_t st = fs_supernode.mext_st;
    int k = 0;
    write_n_ext(0, &fs_supernode);
    while(st < len)
    {
        write_n_ext(st, &mext[k]); 
        k += MEXTS;
        st += 1;
    }
    printf("k : %d, ac_k : %d\n", k , mext_c);
//    for(int i = fs_supernode.mext_st ; i < )    
}

void load_mext()
{
    char xx[4096];
    supernode *fs_supernodes = (supernode*)xx;
//    supernode *fs_supernodes = (supernode*)malloc(4096);
    read_n_ext(0, fs_supernodes);
    fs_supernode = *fs_supernodes;
    //memcpy(&fs_supernode, fs_supernodes, sizeof(fs_supernode));
    if(fs_supernodes->magic_num != SUPER_NODE_MAGIC_NUM)
    {
        printf("supernode wrong num\n");
        exit(2);
    }

    _off_t st = fs_supernodes->mext_st;
    int len = fs_supernodes->ext_st;
    int k = 0;

    while(st < len)
    {
        read_n_ext(st, &mext[k]); 
        k += MEXTS;
        st += 1;
    }
}


void test_mext()
{
    int i =  fs_supernode.ext_st;
    char xx[4096];
    int tmp;
    node *root = get_node_ptr(fs_supernode.where_mext_root);
    while(i < ext_nums)
    {
        if((tmp = bpt_find(root, i)) == -1)
        {
            printf("%d find error\n", i);
            exit(2);
        }else{
            read_n_ext(tmp, xx);

            if(((extent*)xx)->magic_num == EXTENT_MAGIC_NUM)
                printf("find :%d! where : %x\n", i, ((extent*)xx)->where);
        }

        i ++;
    }
    printf("pass !\n");

}

void mkfs(char cmd)
{
    fd = open("fs.img", O_RDWR);
    ext_nums = calc_ext_nums();  
    printf("ext_nums : %d\n", ext_nums);

    if(cmd == 'm')
    {
        init_supernode(&fs_supernode);

        off_t cur_ext_id = ext_nums - 1;
        node *root = NULL;
        extent *tmp_extent = malloc(MEXT_SIZE);
        memset(tmp_extent, 0, MEXT_SIZE);

        tmp_extent->magic_num = EXTENT_MAGIC_NUM;

        while(mext_id < cur_ext_id)
        {

            tmp_extent->where = cur_ext_id;
            root = bpt_insert(root, cur_ext_id , cur_ext_id); 
            write_n_ext(cur_ext_id, tmp_extent);

            printf("insert %d ok\n", cur_ext_id);
            cur_ext_id --;
        }

        //easy test
        int i = cur_ext_id + 1;
        while(i < ext_nums)
        {
            if(bpt_find(root, i) == -1)
            {
                printf("%d find error\n", i);
                exit(2);
            }
            i ++;
        }
        printf("mkfs 1...ok!\n");
        printf("cur_ext_id + 1 : %d,  mext_id : %d\n", cur_ext_id + 1, mext_id);

        fs_supernode.ext_st = cur_ext_id + 1;
        fs_supernode.where_mext_root = root->where;
        check_write(fs_supernode.ext_st);
        printf("mkfs ok....final\n");

    }else{
        load_mext();
        test_mext();

    }

    
}

int main(int ac ,char *av)
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
        printf("size of node :%d \n", sizeof(node));

        mkfs(av[1]);

    }

    return 0;
}
