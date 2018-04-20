#ifndef __KERN_FS_FS_INTERFACE_H_
#define __KERN_FS_FS_INTERFACE_H_

#include "fs_ds.h"
#include "lock_p.h"

typedef struct {
    char valid;
    supernode sp;    
    struct spinlock lock;
}_fs_manager;

extern _fs_manager fs_manager;
#define FS_M_SP (&fs_manager.sp)
#define FS_M_VALID (fs_manager.valid)
#define FS_M_LOCK (&fs_manager.lock)
#define ACQUIRE_SP acquire(FS_M_LOCK)
#define RELEASE_SP release(FS_M_LOCK)


fs_low_class* init_low_fs();

#endif
