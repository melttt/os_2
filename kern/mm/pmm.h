#ifndef _KERN_MM_PMM_H_
#define _KERN_MM_PMM_H_
#include "defs.h"
#include "memlayout.h"


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
