#ifndef __KERN_FS_FILE_H_
#define __KERN_FS_FILE_H_

#include "fs_ds.h"



typedef inode minode;
//    enum{FD_NONE, FD_INODE, FD_OTHER} type;
typedef enum{FD_UNINIT, FD_INODE, FD_OTHER} file_type_t;
typedef struct _file{
    file_type_t type;
    int ref;
    char readable;
    char writeable;
    _off_t off; 
    minode disk_inode; 
}file;

#define FD_R 1
#define FD_W 2
#define RF_RW 3

void init_filetable();
int kread(file *f, void *buf, uint len);
int kwrite(file *f, void *buf, uint len);
void kclose(file *f);
void kcreate(minode *cur_cmd, char* name);
file* kopen(minode *cur_cmd ,char *name, int flags);


#endif
