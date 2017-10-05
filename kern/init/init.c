#include "defs.h"
#include "mmu.h"
#include "param.h"
#include "memlayout.h"
#include "stdio.h"
#include "console.h"
struct e820map{
    int nr_map;
    struct{
        long long addr;
        long long size;
        long type;

    }map[30];
} *emap;
int main()
{
    int i; 
    console_clear();
    cprintf("%s%2c%drl%x\n","Hello",'W',0,13);
    emap = (struct e820map*)P2V(0x8000);
    if(emap->nr_map == 12345)
        cprintf("error!");
    else
    {
        for(i = 0 ; i < emap->nr_map ; i ++) { 
            cprintf("start : %8x ,size : %8x, flag : %x\n",(int)emap->map[i].addr,(int)emap->map[i].size,(int)emap->map[i].type);
        }

    }
    while(1);
    return 0;
}

// The boot page table used in entry.S and entryother.S.
// Page directories (and page tables) must start on page boundaries,
// hence the __aligned__ attribute.
// PTE_PS in a page directory entry enables 4Mbyte pages.

__attribute__((__aligned__(PGSIZE)))
pde_t entrypgdir[NPDENTRIES] = {
  // Map VA's [0, 4MB) to PA's [0, 4MB)
  [0] = (0) | PTE_P | PTE_W | PTE_PS,
  // Map VA's [KERNBASE, KERNBASE+4MB) to PA's [0, 4MB)
  [KERNBASE>>PDXSHIFT] = (0) | PTE_P | PTE_W | PTE_PS,
};

