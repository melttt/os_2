#include "defs.h"
#include "param.h"
#include "x86.h"
#include "uart.h"

#define COM1    0x3f8

static int is_uart;    // is there a uart?

    void
init_uart(void)
{
    char *p;

    // Turn off the FIFO
    outb(COM1+2, 0);

    // 9600 baud, 8 data bits, 1 stop bit, parity off.
    outb(COM1+3, 0x80);    // Unlock divisor
    outb(COM1+0, 115200/9600);
    outb(COM1+1, 0);
    outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
    outb(COM1+4, 0);
    outb(COM1+1, 0x01);    // Enable receive interrupts.

    // If status is 0xFF, no serial port.
    if(inb(COM1+5) == 0xFF)
        return;
    is_uart = 1;

    // Acknowledge pre-existing interrupt conditions;
    // enable interrupts.
    inb(COM1+2);
    inb(COM1+0);
    //  picenable(IRQ_COM1);
    //  ioapicenable(IRQ_COM1, 0);

    // Announce that we're here.
    for(p=INITOK"uart ok!\n"; *p; p++)
        putc_uart(*p);
}

static void
delay(void) {
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}

    void
putc_uart(int c)
{
    int i;

    if(!is_uart)
        return;
    for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
        delay();
    outb(COM1+0, c);
}


