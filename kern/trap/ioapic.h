#ifndef _KERN_TRAP_IOAPIC_H_
#define _KERN_TRAP_IOAPIC_H_
void            ioapicenable(int irq, int cpu);
void            ioapicinit(void);
#endif
