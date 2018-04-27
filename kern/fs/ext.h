#ifndef __KERN_FS_EXT_H_
#define __KERN_FS_EXT_H_
#include "fs_ds.h"

/*
struct fs_low_class;
struct mn;
struct inode;
struct fdata;
*/

extern fs_low_class* fs_f;
#define CLEAR_CACHE() fs_f->begin_fs_op()
#define SYNC_DISK() fs_f->end_fs_op()
#define MAP_D(sec ,off) fs_f->map_disk(sec ,off )
#define INSERT_E(where ) fs_f->insert_ext(where, where)
#define FIND_E(key ) fs_f->find_ext(key)
#define FIND_NEAR_E(near) fs_f->find_ext_near(near )
#define DELETE_E(key ) fs_f->delete_ext(key )
#define SP_N fs_f->supernode_p

int ext_init(fs_low_class*);
mn* mn_alloc();
fdata* fdata_alloc();
inode* inode_alloc();


void mn_free(mn*);
void inode_free(inode*);
void fdata_free(fdata*);


mn* get_mn(_off_t);
fdata* get_fdata(_off_t);
inode* get_inode(_off_t );




#ifdef OUT_K
#include <stddef.h>
#define node2mn(a) ((mn*)((char*)(a) - offsetof(mn, data)))
#else
#define node2mn(a) to_struct(a, mn, data)
#endif

#endif
