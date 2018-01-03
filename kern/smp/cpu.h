#ifndef _KERN_SMP_CPU_H_
#define _KERN_SMP_CPU_H_
#include "defs.h"
#include "param.h"
#include "proc.h"
#include "mmu.h"

struct cpu{
  bool started;       // Has the CPU started?
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  uint8_t apicid;                // Local APIC ID

  uint32_t ncli;                    // Depth of pushcli nesting.
  uint32_t intena;                  // Were interrupts enabled before pushcli?

  // Cpu-local storage variables; see below
  struct cpu *cpu;
  struct proc * cur_proc;           // The currently-running process.
};


extern struct cpu cpus[NCPU];
extern size_t ncpu;
//extern struct cpu *cpu ;       // &cpus[cpunum()]
size_t get_cpu(void);



#endif
