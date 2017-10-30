#include "defs.h"
#include "mmu.h"
#include "param.h"
#include "memlayout.h"
#include "stdio.h"
#include "console.h"
#include "elf.h"
#include "uart.h"
#include "kdebug.h"
#include "mp.h"
#include "pmm.h"
#include "lapic.h"
#include "ioapic.h"
#include "trap.h"
#include "kbd.h"
#include "ide.h"
//#define g(x) #x
int main()
{
    extern char data[],edata[],end[];
    //char test[513];
    //int i;
    console_clear();
    uartinit();
    cprintf("data : %x , edata %x , end %x\n",(int)data,(int)edata,(int)end);
    //cprintf("%x\n",(int)__STABSTR_BEGIN__);
    cprintf("%s%2c%drl%x\n","Hello",'W',0,13);

    init_pmm();

    mpinit();
    lapicinit();
    ioapicinit();
    tvinit();
    idtinit();
    kbd_init();
    ide_init();
    /*
    ide_read_secs(0,0,test,1);
    test[512] = 0;
    for(i = 0 ; i < 512 ; i ++)
    {
        cprintf("%2x",((int)test[i] & 0xff));
    }
    cprintf("\n");
    */
    asm volatile ("sti");
         


    cprintf("cpunum : %d\n", ncpu);
    cprintf("LAPIC : %x\n",(int)lapic);
    /*****test ****/
    void *i,*j;
    i = alloc_pages(1); 
    j = alloc_page();

    cprintf("i : %x, j : %x\n",(uint32_t)(i), (uint32_t)(j));
    free_pages(i);
    free_page(j);
        alloc_page();
        alloc_page();
        alloc_page();
        alloc_page();
        alloc_page();
        i = page2kva(alloc_page());
    j = alloc_pages(1);
    cprintf("i : %x, j : %x\n",(uint32_t)(i), (uint32_t)(j));

//    cprintf("%x\n",*(int*)(0x70000000));
//    *(int*)(0x80109010 - 4) = 0x12345678;
    

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

