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

void print_freq()
{
    uint32_t out_var1 = 0;
    uint32_t op = 0x80860007;
    asm volatile( "cpuid"
      : "=a" (out_var1)
      : "a" (op)
     );
    cprintf("---------------freq: %x \n", out_var1);
    while(1);
}
int main() {
    
    asm volatile("cli");
    cprintf("cpu 0 : %d %d \n",cpus[0].ncli, cpus[0].intena);
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
    ide_init();
   /* 
    char test[513];
    int i;
    ide_read_secs(1,0,test,1);
    test[512] = 0;
    for(i = 0 ; i < 512 ; i ++)
    {
        cprintf("%2x",((int)test[i] & 0xff));
    }
    test[0] = 'B';
    ide_write_secs(1,0,test,1);
    cprintf("\n");
   */ 
    check_vmm();

    cprintf("cpunum : %d\n", ncpu);
    cprintf("LAPIC : %x\n",(int)lapic);
    proc_init();
    cprintf("proc init\n");

    cprintf("cpu 0 : %d %d \n",cpus[0].ncli, cpus[0].intena);

    int *c = kmalloc(4);
    *c = 1;
    cprintf("c : %x\n", c);

    asm volatile ("sti");
    while(1)
    {
        cprintf("shce idle\n");
        sche();
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

