#include "defs.h"
#include "param.h"
#include "cpu.h"
#include "x86.h"
#include "kdebug.h"
#include "lapic.h"
#include "mmu.h"
#include "spinlock.h"
struct cpu cpus[NCPU];
size_t ncpu = 0;
struct spinlock lock = {
  .locked = 0,
};

size_t get_cpu(void)
{
    int apicid;
    size_t i;

    if(readeflags()&FL_IF)
;//        panic("mycpu called with interrupts enabled\n");


    apicid = lapicid();
    if(apicid == 0)
    {
        return 0;
    }
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
        if (cpus[i].apicid == apicid)
        {
            return i;
        }
    }
    panic("unknown apicid\n");
    return 0;
}





