#include "defs.h"
#include "mmu.h"
#include "param.h"
#include "memlayout.h"
static uint8_t *crt = (uint8_t*)P2V(0xb8000);  // CGA memory

int main()
{
    uint8_t color = (0 << 4) | (15 & 0x0F);
    *crt ++ = 'A' ; *crt ++ = color;
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

