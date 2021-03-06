#ifndef OUT_K
#include "basic_p.h"
#include "kdebug.h"
#include "fs_interface.h"
#include "cpu.h"
#include "stdio.h"
#endif

#include "ext.h"
#include "inode.h"
#include "file.h"
#define FILE_TABLE_MAX 123
file filetable[FILE_TABLE_MAX];

file* find_free_file()
{
    int i = 0;
    for(i = 0 ; i < FILE_TABLE_MAX ; i ++)
    {
        if(filetable[i].type == FD_UNINIT)
            return &filetable[i];
    }
    return NULL;
}
/****************general file******************/
static void flush_minode(minode *m)
{
    inode *n = get_inode(m->real_where); 
    *n = *m;
}

void kcreate(minode *cur_cmd, char* name,i_t file_type)
{
    inode *ninode = NULL;
    if((ninode = dirent_lookup(cur_cmd, name)) != NULL)
    {
        cprintf("%s already exist\n", name);
        return ;
    }
    //create new;
    ninode = alloc_inode_type(file_type);
    dirent_link((inode*)cur_cmd, name ,ninode); 
    if(file_type == INODE_TYPE_DIR)
    {
        dirent_link((inode*)ninode, "." ,ninode); 
        dirent_link((inode*)ninode, ".." ,cur_cmd); 
    }
    //flush cur_cmd
    flush_minode(cur_cmd);        
    SYNC_DISK(); 
}

file* kopen(minode *cur_cmd ,char *name, int flags)
{
    inode* ninode = dirent_lookup(cur_cmd , name);
    if(ninode == NULL) return NULL;
    file* f = find_free_file();

    if(f == NULL)
    {
        cprintf("no enough room to filetable\n");
        return NULL;
    }
    if(f != NULL && ninode != NULL)
    {
        f->ref = 1;
        f->type = FD_INODE;
        f->off = 0;
        f->readable = (flags & 0x1) ? 1 : 0;
        f->writeable = (flags & 0x2) ? 1 : 0;
        f->disk_inode = *ninode;
    }
    return f;    
}
void kclose(file *f)
{
    f->type = FD_UNINIT;
}

int kwrite(file *f, void *buf, uint len)
{
    int ret;
    ret = inode_write(&f->disk_inode, buf, len , f->off );
    flush_minode(&f->disk_inode);
    SYNC_DISK(); 
    return ret;
}


int kread(file *f, void *buf, uint len)
{
    int ret;
    ret = inode_read(&f->disk_inode, buf, len , f->off );
    flush_minode(&f->disk_inode);
    SYNC_DISK(); 
    return ret;
}


void init_filetable()
{
    int i;
    inode *root = get_inode(SP_N->root_inode_where);
    assert(root);
    CUR_PROC->cur_inode = *root;

    for(i = 0 ; i < FILE_TABLE_MAX ; i ++)
    {
        filetable[i].type = FD_UNINIT;
        filetable[i].ref = 0;
        filetable[i].readable = 0;
        filetable[i].writeable = 0;
        filetable[i].off = 0;
        filetable[i].disk_inode.magic_num = 0; 
    }
}


void init_fs()
{
    ext_init(NULL);
    init_filetable();
    cprintf(INITOK"fs system ok!\n");
    SYNC_DISK();
}
