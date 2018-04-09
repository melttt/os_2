#include "defs.h"
#include "fs.h"
#include "swap.h"
#include "swapfs.h"
#include "mmu.h"
#include "ide.h"
#include "kdebug.h"
#include "pmm.h"
void
swapfs_init(void) {
    /*
    char buf[512] = {0};
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
    buf[256] = SWAP_MAGIC_NUM;
    ide_write_secs(SWAP_DEV_NO, 0, buf,1 );
    */
}

int
swapfs_read(swap_entry_t entry, struct page *page) {
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
}

int
swapfs_write(swap_entry_t entry, struct page *page) {
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
}
