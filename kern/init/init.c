#include "defs.h"
#include "mmu.h"
#include "param.h"
#include "memlayout.h"
#include "stdio.h"
#include "console.h"
#include "elf.h"
#include "uart.h"
#include "kdebug.h"
#define g(x) #x

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
    extern char __STABSTR_BEGIN__[],__STAB_BEGIN__[],__STAB_END__[];
    struct stab *sts,*ste;
    int left,right;
    console_clear();
    uartinit();

    cprintf("%x\n",(int)__STABSTR_BEGIN__);
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
    sts = (struct stab*)__STAB_BEGIN__; 
    sts += 1;
    ste = (struct stab*)__STAB_END__;
    left = 0;
    right = (ste - sts) - 1;
    cprintf("total : %d\n", right);
    stab_binsearch(sts,&left,&right,N_SO,0x80100190);
    cprintf("left : %d , right : %d",left, right); 
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

