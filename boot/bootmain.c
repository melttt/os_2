// Boot loader.
//
// Part of the boot block, along with bootasm.S, which calls bootmain().
// bootasm.S has put the processor into protected 32-bit mode.
// bootmain() loads an ELF kernel image from the disk starting at
// sector 1 and then jumps to the kernel entry routine.

#include "defs.h"
#include "elf.h"
#include "x86.h"
#include "fs_ds.h"

#define SECTSIZE  512
#define ELFHDR          ((void*)0x10000)      // scratch space

void
waitdisk(void)
{
    // Wait for disk ready.
    while((inb(0x1F7) & 0xC0) != 0x40)
        ;
}
void
readsect(void *dst, uint32_t offset)
{
    // Issue command.
    waitdisk();
    outb(0x1F2, 1);   // count = 1
    outb(0x1F3, offset);
    outb(0x1F4, offset >> 8);
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

    // Read data.
    waitdisk();
    insl(0x1F0, dst, SECTSIZE/4);
}
void
readseg(uint8_t* pa, uint32_t count, uint32_t offset, uint32_t disk_st)
{
    uint8_t* epa;

    epa = pa + count;
    // Round down to sector boundary.
    pa -= offset % SECTSIZE;
    // Translate from bytes to sectors; kernel starts at sector 1.
    offset = (offset / SECTSIZE) + disk_st;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for(; pa < epa; pa += SECTSIZE, offset++)
        readsect(pa, offset);
}

void
bootmain(void)
{
    struct elfhdr *elf;
    uint kern_st_ext;
    struct proghdr *ph, *eph;
    void (*entry)(void);
    uint8_t* pa;

    elf = ELFHDR;  // scratch space
    // read fs_head
    
    readsect((char*)elf + 512 , 1);
    kern_st_ext = ((supernode*)elf)->kernel_st_e << 3 ;

    // Read 1st page off disk
    readseg((uchar*)elf, EXT_SIZE , 0, kern_st_ext);
    // Is this an ELF executable?
    if(elf->e_magic != ELF_MAGIC)
        return;  // let bootasm.S handle error

    // Load each program segment (ignores ph flags).
    ph = (struct proghdr*)((uint8_t*)elf + elf->e_phoff);
    eph = ph + elf->e_phnum;
    for(; ph < eph; ph++){
        pa = (uint8_t*)ph->p_pa;
        readseg(pa, ph->p_filesz, ph->p_offset, kern_st_ext);
        if(ph->p_memsz > ph->p_filesz)
            stosb(pa + ph->p_filesz, 0, ph->p_memsz - ph->p_filesz);
    }

    // Call the entry point from the ELF header.
    // Does not return!
    entry = (void(*)(void))(elf->e_entry);
    entry();
}


// Read a single sector at offset into dst.

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.


