#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include "stddef.h"
#include "assert.h"

#define MIN(a,b) (((a) < (b)) ? (a) : (b))

#include "../kern/fs/fs_ds.h"
#include "../kern/fs/ext.h"
#include "../kern/fs/inode.h"
#include "../libs/bplustree.h"






int valid;
char *disk_in_mem;
uint disk_size;
char *filename;
int fd;
supernode sp;
fs_low_class fs_c;
inode *root;




static void* mapping_disk(uint sec ,uint off);

/*****************************bpt_interface************************/
//m_ext
inline static void* get_me(int n)
{
   return  mapping_disk(sp.me_st_ext + n / MEXTS , n % MEXTS * sizeof(node));
}
static node* malloc_node(node **a)
{
    
    _off_t next_pos;
    
    if(sp.me_free_nums == 0) 
    {
        printf("no enough room for mnode\n");
        exit(3);
    }

    next_pos = sp.me_free_next_me;
    (*a) = get_me(next_pos);    
    sp.me_free_next_me = (*a)->next;
    sp.me_free_nums --;

    (*a)->next = NIA; 
    (*a)->num_keys = 0;
    (*a)->parent = NIA;
}

static void free_node(node *a)
{
    _off_t tmp;
    tmp = sp.me_free_next_me;
    a->next = tmp;
    sp.me_free_next_me = a->where;
    sp.me_free_nums ++;
}

static node* get_node_ptr(_off_t n)
{
    if(n >= sp.me_all_nums)
    {
        if(n != NIA)
        {
            printf("get_node_ptr over extent");
            exit(2);
        }
        return NULL;
    }else{
        return get_me(n);
    }
}


static void* mapping_disk(uint sec ,uint off)
{
    if(valid)
        return (disk_in_mem + EXTENT_SIZE * sec + off) ;
    else
        return NULL;
}

static void begin_op()
{
   
}

static void end_op()
{
    int i = 0;

    sp.root_inode_where = root->real_where;
    memcpy(disk_in_mem ,&sp, sizeof(sp));
    lseek(fd, 0 , SEEK_SET);
    for(i = 0 ; i < disk_size ; i += EXTENT_SIZE)
    {
        write(fd, disk_in_mem + i , EXTENT_SIZE);
    }
    printf("write it to disk over\n");
}

static void insert_ext(_off_t key , _off_t val)
{
    node *root = get_me(sp.me_root);
    root = bpt_insert(root ,key ,val);
    sp.me_root = root->where;
    sp.e_all_nums ++;
    sp.e_free_nums ++;
}
static _off_t find_ext( _off_t sec)
{
    node *root = get_me(sp.me_root);
    return bpt_find(root, sec);
}

static _off_t find_ext_near(_off_t near)
{
    node *root = get_me(sp.me_root);
    return bpt_find_near(root ,near);
}

static void delete_ext(_off_t key)
{
    node *root = get_me(sp.me_root);
    root = bpt_delete(root ,key);
    sp.me_root = root->where;
    sp.e_all_nums --;
    sp.e_free_nums --;
}
/*********************setup*********************/

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

static void setup_disk_in_mem()
{
    disk_size = get_file_size(filename);
    disk_in_mem = malloc(disk_size);     
    printf("disk_in_mem of size : %d\n",disk_size );


    for(uint i = 0 ; i < disk_size ; i += EXTENT_SIZE)
    {
        read(fd, disk_in_mem + i , EXTENT_SIZE);
    }
    printf("read disk to mem over\n");
    memcpy(&sp, disk_in_mem , sizeof(sp));
    printf("ok\n");
    if(sp.magic_num == SUPER_NODE_MAGIC_NUM )
    {
        valid = 1;
        printf("valid disk\n");
    }else{
        printf("invalid disk\n");
        exit(2);
    }    
}
static void setup_interface()
{
    fs_c.name = "halo";
    fs_c.begin_fs_op = begin_op;
    fs_c.end_fs_op = end_op;
    fs_c.map_disk = mapping_disk;
    fs_c.insert_ext = insert_ext;
    fs_c.find_ext = find_ext;
    fs_c.find_ext_near = find_ext_near;
    fs_c.delete_ext = delete_ext;
    fs_c.supernode_p = &sp;
}

char *filtesubstr(char *name)
{
    for(int i = 0 ; i < strlen(name) ; i ++)
    {
        if(name[i] == '.' || name[i] == '/') continue;
        return name;
    }

}
static void write_file(char *name)
{
    int tmpfd = open(name, O_RDWR);
    int file_len;
    char *file_buf;
    int exist = 1;
    inode *tmpnode ; 

    if(tmpfd < 0) 
    {
        printf("%s is not valid file\n", name);
        return;
    }
    if((tmpnode = dirent_lookup(root, name)) == NULL)
    {
        tmpnode = inode_alloc();
        tmpnode->data.type = INODE_TYPE_FILE;
        exist = 0;
    }
    file_len = get_file_size(name);
    file_buf = malloc(file_len);
    read(tmpfd, file_buf , file_len);    
    inode_write(tmpnode, file_buf,file_len ,0);

    if(!exist)
        dirent_link(root ,filtesubstr(name), tmpnode);
    free(file_buf);
    close(tmpfd);
    printf("write file : %s over\n", name);
}


int loadfile(int av, char *ag[])
{
    if(av < 2) return -1;
    filename = ag[0];
    int i;
    fd = open(filename, O_RDWR );    
    setup_disk_in_mem();
    setup_interface();
    ext_init(&fs_c);
    if(sp.root_inode_where == NIA)
    {
        printf("root is none\n");
        root = inode_alloc();//get_inode(0x2e00);
        dirent_link(root ,".", root);
        dirent_link(root ,"..", root);
        root->data.type = INODE_TYPE_DIR;
        printf("root where : %x\n" , root->real_where);
    }else{
        printf("root is exist \n");
        root = get_inode(sp.root_inode_where);
    }
    printf("start write:\n");
    for(i = 1; i < av ; i ++)
    {
        write_file(ag[i]);
    }
    end_op();
    return 0;
}
