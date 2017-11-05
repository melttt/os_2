#ifndef _KERN_MM_PMM_H_
#define _KERN_MM_PMM_H_
#include "defs.h"
#include "memlayout.h"
#include "vmm.h"
#include "list.h"

#define ALLOC_FALSE -1
struct page;
struct pmm_manager {
    const char *name;                                 // XXX_pmm_manager's name
    void (*init)(uintptr_t *n, uint32_t *pg_size); //init the pmm 
    uint32_t (*alloc_pages)(size_t n); // allocate >=n pages, depend on the allocation algorithm 
    void (*free_pages)(size_t n);  // free >=n pages with "base" addr of Page descriptor structures(memlayout.h)
    size_t (*nr_free_pages)(void);      // return the number of free pages 
    uint8_t (*change_page_ref)(uint32_t offset, int8_t ch);
    struct page* (*ret_page_addr)(size_t offset); 
};

struct pmm_info{
    uintptr_t start;
    uintptr_t end;
    uint32_t size; // num of PGSIZE
};


struct page{
    uint8_t val;
    uint8_t ref;
    pde_t *pgdir;                  
    uint32_t pra_vaddr;
    list_entry_t pra_page_link;
}__attribute__((packed));

// convert list entry to page
#define le2page(le, member)                 \
    to_struct((le), struct page, member)


extern struct pmm_info pmm_info;
void init_pmm(void);

//alloc and free
void* alloc_pages(size_t n);
void free_pages(void *n);
void *kmalloc(size_t n);
void kfree(void *n);
size_t nr_free_pages(void);
void free_page(struct page* page);
struct page* alloc_page();
void tlb_invalidate(pde_t *pgdir, uintptr_t la);


struct page* kva2page(void *va);
void *page2kva(struct page* page);
uintptr_t page2pa(struct page* page);
struct page* pa2page(uintptr_t pa);




#endif
