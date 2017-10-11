#ifndef _KERN_MM_PMM_H_
#define _KERN_MM_PMM_H_
#include "defs.h"
#include "memlayout.h"

struct pmm_manager {
    const char *name;                                 // XXX_pmm_manager's name
    void (*init)(uintptr_t *n, uint32_t *pg_size); //init the pmm 
    uint32_t (*alloc_pages)(size_t n); // allocate >=n pages, depend on the allocation algorithm 
    void (*free_pages)(size_t n);  // free >=n pages with "base" addr of Page descriptor structures(memlayout.h)
    size_t (*nr_free_pages)(void);      // return the number of free pages 
};

void 
init_pmm(void);
void*
alloc_pages(size_t n);
void
free_pages(void *n);

#if 0
// convert list entry to page
#define le2page(le, member)                 \
    to_struct((le), struct Page, member)

static inline void
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline void
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}
#endif

#endif
