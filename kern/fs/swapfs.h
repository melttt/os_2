#ifndef __KERN_FS_SWAPFS_H__
#define __KERN_FS_SWAPFS_H__
#include "defs.h"
#include "pmm.h"
#include "swap.h"

void swapfs_init(void);
int swapfs_read(swap_entry_t entry, struct page *page);
int swapfs_write(swap_entry_t entry, struct page *page);

#endif /* !__KERN_FS_SWAPFS_H__ */
