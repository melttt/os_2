#include "defs.h"
#include "trap.h"
#include "kdebug.h"
#include "mmu.h"
#include "stdio.h"
#include "x86.h"
#include "lapic.h"
#include "kbd.h"
#include "vmm.h"
#include "cpu.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers


uint ticks;




void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

//  initlock(&tickslock, "time");
}


void
idtinit(void)
{
  lidt(idt, sizeof(idt));
  cprintf(INITOK"idt init ok!\n");
}


static inline void
print_pgfault(struct trapframe *tf) {
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->err & 4) ? 'U' : 'K',
            (tf->err & 2) ? 'W' : 'R',
            (tf->err & 1) ? "protection fault" : "no page found");
}

extern struct mm_struct *check_mm_struct;
static int
pgfault_handler(struct trapframe *tf) {
    print_pgfault(tf);
    if (check_mm_struct != NULL) {
        return do_pgfault(check_mm_struct, tf->err, rcr2());
    }
    panic("unhandled page fault.\n");
    return 0;
}


void
trap(struct trapframe *tf)
{
    if(tf->trapno == T_SYSCALL){
        /*
           if(proc->killed)
           exit();
           proc->tf = tf;
           syscall();
           if(proc->killed)
           exit();
           */
        return;
    }
    switch(tf->trapno){
        case T_PGFLT:
             pgfault_handler(tf);
            break;
        case T_IRQ0 + IRQ_TIMER:
            if(get_cpu() == 0){
                ticks ++;
//                cprintf("ticks: %d\n",ticks);
                /*
                   acquire(&tickslock);
                   ticks++;
                   wakeup(&ticks);
                   release(&tickslock);
                   */
            }
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE0:
            //ideintr();
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE1:
            //ideintr();
            lapiceoi();

            // Bochs generates spurious IDE1 interrupts.
            break;
        case T_IRQ0 + IRQ_KBD:
            kbd_intr();
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_COM1:
            /*
               uartintr();
               lapiceoi();
               */
            break;
        case T_IRQ0 + 7:
        case T_IRQ0 + IRQ_SPURIOUS:
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
                    get_cpu(), tf->cs, tf->eip);
            lapiceoi();
            break;

            //PAGEBREAK: 13
        default:
            ;
            cprintf("trapno : %d\n",tf->trapno);
            /*
               if(proc == 0 || (tf->cs&3) == 0){
            // In kernel, it must be our mistake.
            cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
            tf->trapno, cpunum(), tf->eip, rcr2());
            panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
            proc->killed = 1;
            */
    }
    /*
       if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
       yield();
       */

    /*
    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

    // Check if the process has been killed since we yielded
    if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
    */
}


