#ifndef _LIBS_MEMLAYOUT_H_
#define _LIBS_MEMLAYOUT_H_
// Memory layout


#define EXTMEM  0x100000            // Start of extended memory
//#define PHYSTOP 0xE000000           // Top physical memory
#define DEVSPACE 0xFE000000         // Other devices are at high addresses

// Key addresses for address space layout (see kmap in vm.c for layout)
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked
#define KMEMSIZE            0x38000000 

//#define KMEMSIZE            0x38000000 
#define V2P(a) (((unsigned int) (a)) - KERNBASE)
#define P2V(a) (((void *) (a)) + KERNBASE)

#define V2P_WO(x) ((x) - KERNBASE)    // same as V2P, but without casts
#define P2V_WO(x) ((x) + KERNBASE)    // same as P2V, but without casts


#define USERBASE 0x00000000

#ifndef PAGE
#define PAGE 4096
#define USTACKSIZE (4*PAGE)
#endif

#define USERTOP  0x04000000
#define USER_ACCESS(start, end) \
    (USERBASE <= (start) && (start) < (end) && (end) <= USERTOP)


#ifndef __ASSEMBLER__
#include "defs.h"
#include "list.h"
#include "x86.h"

typedef struct {
    list_entry_t free_list;         // the list header
    unsigned int nr_free;           // # of free pages in this free list
} free_area_t;


#endif

#endif

