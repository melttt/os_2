#ifndef __KERN_FS_INODE_H_
#define __KERN_FS_INODE_H_

#include "fs_ds.h"

void init_inode();

int inode_write(inode* a, void* buf, uint len , _off_t off);
int inode_read(inode* a, void* buf, uint len ,_off_t off);
inode *dirent_lookup(inode *parent, char* name);
void dirent_link(inode *parent , char* name, inode *newnode );
char* parse_path(char* path, char* ret, int* ret_len);

inode* alloc_inode_type(i_t t);
int dirent_list(inode *parent, void *dst, int len);
#endif
