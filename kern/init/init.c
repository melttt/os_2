#include "basic_p.h"
#include "driver_p.h"
#include "smp_p.h"
#include "mm_p.h"
#include "arch_p.h"

#include "ioapic.h"
#include "stdio.h"
#include "elf.h"
#include "kdebug.h"
#include "trap.h"
#include "proc.h"
#include "sche.h"
#include "file.h"

int main() {
    
    init_cons();
    clear_cons();
    init_uart();

    extern char data[],edata[],end[];
    cprintf("%s%2c%drl%x\n","Hello",'W',0,13);
    cprintf("start cpu id = %d\n",get_cpu());
    cprintf("data : %08x , edata %x , end %x\n",(int)data,(int)edata,(int)end);

    init_pmm();

    mpinit();
    lapicinit();
    ioapicinit();


    cprintf("cpu id = %d\n",get_cpu());
    tvinit();
    idtinit();

    kbd_init();
    check_vmm();

    cprintf("cpunum : %d\n", ncpu);
    cprintf("LAPIC : %x\n",(int)lapic);
    proc_init();
    cprintf("proc init\n");
    cprintf("cpu 0 : %d %d \n",cpus[0].ncli, cpus[0].intena);

#if SCHE_DEBUG
    cprintf("****************************\n");
    cprintf(SCHE_MSG" START schedule test\n");
    cprintf("****************************\n");
#endif
    asm volatile ("sti");
    while(1)
    {
        if(get_proc_num() != 0)
        {
            schedule(PROCM_LOCK);
            sche_tick2();
        }

    }
    
    
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
  [1] = (0x400000) | PTE_P | PTE_W | PTE_PS, 
  // Map VA's [KERNBASE, KERNBASE+4MB) to PA's [0, 4MB)
  [KERNBASE>>PDXSHIFT] = (0) | PTE_P | PTE_W | PTE_PS,
  [(KERNBASE>>PDXSHIFT) + 1] = (0x400000) | PTE_P | PTE_W | PTE_PS,
};

