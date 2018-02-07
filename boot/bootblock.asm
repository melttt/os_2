
./boot/bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
# with %cs=0 %ip=7c00.
.set SMAP,                  0x534d4150
.code16                       # Assemble for 16-bit mode
.globl start
start:
  cli                         # BIOS enabled interrupts; disable
    7c00:	fa                   	cli    

  # Zero data segment registers DS, ES, and SS.
  xorw    %ax,%ax             # Set %ax to zero
    7c01:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c03:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c05:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c07:	8e d0                	mov    %eax,%ss

00007c09 <seta20.1>:

  # Physical address line A20 is tied to zero so that the first PCs 
  # with 2 MB would run software that assumed 1 MB.  Undo that.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c09:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c0b:	a8 02                	test   $0x2,%al
  jnz     seta20.1
    7c0d:	75 fa                	jne    7c09 <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c0f:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
    7c11:	e6 64                	out    %al,$0x64

00007c13 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c13:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
    7c15:	a8 02                	test   $0x2,%al
  jnz     seta20.2
    7c17:	75 fa                	jne    7c13 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c19:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
    7c1b:	e6 60                	out    %al,$0x60

00007c1d <probe_memory>:

probe_memory:
    movl $0, 0x8000
    7c1d:	66 c7 06 00 80       	movw   $0x8000,(%esi)
    7c22:	00 00                	add    %al,(%eax)
    7c24:	00 00                	add    %al,(%eax)
    xorl %ebx, %ebx
    7c26:	66 31 db             	xor    %bx,%bx
    movw $0x8004, %di
    7c29:	bf                   	.byte 0xbf
    7c2a:	04 80                	add    $0x80,%al

00007c2c <start_probe>:
start_probe:
    movl $0xE820, %eax
    7c2c:	66 b8 20 e8          	mov    $0xe820,%ax
    7c30:	00 00                	add    %al,(%eax)
    movl $20, %ecx
    7c32:	66 b9 14 00          	mov    $0x14,%cx
    7c36:	00 00                	add    %al,(%eax)
    movl $SMAP, %edx
    7c38:	66 ba 50 41          	mov    $0x4150,%dx
    7c3c:	4d                   	dec    %ebp
    7c3d:	53                   	push   %ebx
    int $0x15
    7c3e:	cd 15                	int    $0x15
    jnc cont
    7c40:	73 08                	jae    7c4a <cont>
    movw $12345, 0x8000
    7c42:	c7 06 00 80 39 30    	movl   $0x30398000,(%esi)
    jmp finish_probe
    7c48:	eb 0e                	jmp    7c58 <finish_probe>

00007c4a <cont>:
cont:
    addw $20, %di
    7c4a:	83 c7 14             	add    $0x14,%edi
    incl 0x8000
    7c4d:	66 ff 06             	incw   (%esi)
    7c50:	00 80 66 83 fb 00    	add    %al,0xfb8366(%eax)
    cmpl $0, %ebx
    jnz start_probe
    7c56:	75 d4                	jne    7c2c <start_probe>

00007c58 <finish_probe>:
finish_probe:

  # Switch from real to protected mode.  Use a bootstrap GDT that makes
  # virtual addresses map directly to physical addresses so that the
  # effective memory map doesn't change during the transition.
  lgdt    gdtdesc
    7c58:	0f 01 16             	lgdtl  (%esi)
    7c5b:	b4 7c                	mov    $0x7c,%ah
  movl    %cr0, %eax
    7c5d:	0f 20 c0             	mov    %cr0,%eax
  orl     $CR0_PE, %eax
    7c60:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
    7c64:	0f 22 c0             	mov    %eax,%cr0

//PAGEBREAK!
  # Complete the transition to 32-bit protected mode by using a long jmp
  # to reload %cs and %eip.  The segment descriptors are set up with no
  # translation, so that the mapping is still the identity mapping.
  ljmp    $(SEG_KCODE<<3), $start32
    7c67:	ea                   	.byte 0xea
    7c68:	6c                   	insb   (%dx),%es:(%edi)
    7c69:	7c 08                	jl     7c73 <start32+0x7>
	...

00007c6c <start32>:

.code32  # Tell assembler to generate 32-bit code now.
start32:
  # Set up the protected-mode data segment registers
  movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
    7c6c:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c70:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c72:	8e c0                	mov    %eax,%es
  movw    %ax, %ss                # -> SS: Stack Segment
    7c74:	8e d0                	mov    %eax,%ss
  movw    $0, %ax                 # Zero segments not ready for use
    7c76:	66 b8 00 00          	mov    $0x0,%ax
  movw    %ax, %fs                # -> FS
    7c7a:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c7c:	8e e8                	mov    %eax,%gs

  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c7e:	bc 00 7c 00 00       	mov    $0x7c00,%esp
  call    bootmain
    7c83:	e8 ef 00 00 00       	call   7d77 <bootmain>

  # If bootmain returns (it shouldn't), trigger a Bochs
  # breakpoint if running under Bochs, then loop.
  movw    $0x8a00, %ax            # 0x8a00 -> port 0x8a00
    7c88:	66 b8 00 8a          	mov    $0x8a00,%ax
  movw    %ax, %dx
    7c8c:	66 89 c2             	mov    %ax,%dx
  outw    %ax, %dx
    7c8f:	66 ef                	out    %ax,(%dx)
  movw    $0x8ae0, %ax            # 0x8ae0 -> port 0x8a00
    7c91:	66 b8 e0 8a          	mov    $0x8ae0,%ax
  outw    %ax, %dx
    7c95:	66 ef                	out    %ax,(%dx)

00007c97 <spin>:
spin:
  jmp     spin
    7c97:	eb fe                	jmp    7c97 <spin>
    7c99:	8d 76 00             	lea    0x0(%esi),%esi

00007c9c <gdt>:
	...
    7ca4:	ff                   	(bad)  
    7ca5:	ff 00                	incl   (%eax)
    7ca7:	00 00                	add    %al,(%eax)
    7ca9:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7cb0:	00                   	.byte 0x0
    7cb1:	92                   	xchg   %eax,%edx
    7cb2:	cf                   	iret   
	...

00007cb4 <gdtdesc>:
    7cb4:	17                   	pop    %ss
    7cb5:	00                   	.byte 0x0
    7cb6:	9c                   	pushf  
    7cb7:	7c 00                	jl     7cb9 <gdtdesc+0x5>
	...

00007cba <waitdisk>:
  entry();
}

void
waitdisk(void)
{
    7cba:	55                   	push   %ebp
    7cbb:	89 e5                	mov    %esp,%ebp
} __attribute__ ((packed));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
    7cbd:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cc2:	ec                   	in     (%dx),%al
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
    7cc3:	83 e0 c0             	and    $0xffffffc0,%eax
    7cc6:	3c 40                	cmp    $0x40,%al
    7cc8:	75 f8                	jne    7cc2 <waitdisk+0x8>
    ;
}
    7cca:	5d                   	pop    %ebp
    7ccb:	c3                   	ret    

00007ccc <readsect>:

// Read a single sector at offset into dst.
void
readsect(void *dst, uint32_t offset)
{
    7ccc:	55                   	push   %ebp
    7ccd:	89 e5                	mov    %esp,%ebp
    7ccf:	57                   	push   %edi
    7cd0:	53                   	push   %ebx
    7cd1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  // Issue command.
  waitdisk();
    7cd4:	e8 e1 ff ff ff       	call   7cba <waitdisk>
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
    7cd9:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7cde:	b8 01 00 00 00       	mov    $0x1,%eax
    7ce3:	ee                   	out    %al,(%dx)
    7ce4:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7ce9:	89 d8                	mov    %ebx,%eax
    7ceb:	ee                   	out    %al,(%dx)
    7cec:	89 d8                	mov    %ebx,%eax
    7cee:	c1 e8 08             	shr    $0x8,%eax
    7cf1:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7cf6:	ee                   	out    %al,(%dx)
    7cf7:	89 d8                	mov    %ebx,%eax
    7cf9:	c1 e8 10             	shr    $0x10,%eax
    7cfc:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7d01:	ee                   	out    %al,(%dx)
    7d02:	89 d8                	mov    %ebx,%eax
    7d04:	c1 e8 18             	shr    $0x18,%eax
    7d07:	83 c8 e0             	or     $0xffffffe0,%eax
    7d0a:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7d0f:	ee                   	out    %al,(%dx)
    7d10:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7d15:	b8 20 00 00 00       	mov    $0x20,%eax
    7d1a:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
  outb(0x1F6, (offset >> 24) | 0xE0);
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
    7d1b:	e8 9a ff ff ff       	call   7cba <waitdisk>
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
    return data;
}
static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
    7d20:	8b 7d 08             	mov    0x8(%ebp),%edi
    7d23:	b9 80 00 00 00       	mov    $0x80,%ecx
    7d28:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7d2d:	fc                   	cld    
    7d2e:	f2 6d                	repnz insl (%dx),%es:(%edi)
  insl(0x1F0, dst, SECTSIZE/4);
}
    7d30:	5b                   	pop    %ebx
    7d31:	5f                   	pop    %edi
    7d32:	5d                   	pop    %ebp
    7d33:	c3                   	ret    

00007d34 <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
void
readseg(uint8_t* pa, uint32_t count, uint32_t offset)
{
    7d34:	55                   	push   %ebp
    7d35:	89 e5                	mov    %esp,%ebp
    7d37:	57                   	push   %edi
    7d38:	56                   	push   %esi
    7d39:	53                   	push   %ebx
    7d3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
    7d3d:	8b 75 10             	mov    0x10(%ebp),%esi
  uint8_t* epa;

  epa = pa + count;
    7d40:	89 df                	mov    %ebx,%edi
    7d42:	03 7d 0c             	add    0xc(%ebp),%edi

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
    7d45:	89 f0                	mov    %esi,%eax
    7d47:	25 ff 01 00 00       	and    $0x1ff,%eax
    7d4c:	29 c3                	sub    %eax,%ebx

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
    7d4e:	c1 ee 09             	shr    $0x9,%esi
    7d51:	83 c6 01             	add    $0x1,%esi

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d54:	39 df                	cmp    %ebx,%edi
    7d56:	76 17                	jbe    7d6f <readseg+0x3b>
    readsect(pa, offset);
    7d58:	56                   	push   %esi
    7d59:	53                   	push   %ebx
    7d5a:	e8 6d ff ff ff       	call   7ccc <readsect>
  offset = (offset / SECTSIZE) + 1;

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d5f:	81 c3 00 02 00 00    	add    $0x200,%ebx
    7d65:	83 c6 01             	add    $0x1,%esi
    7d68:	83 c4 08             	add    $0x8,%esp
    7d6b:	39 df                	cmp    %ebx,%edi
    7d6d:	77 e9                	ja     7d58 <readseg+0x24>
    readsect(pa, offset);
}
    7d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d72:	5b                   	pop    %ebx
    7d73:	5e                   	pop    %esi
    7d74:	5f                   	pop    %edi
    7d75:	5d                   	pop    %ebp
    7d76:	c3                   	ret    

00007d77 <bootmain>:
#define ELFHDR          ((struct elfhdr *)0x10000)      // scratch space
void readseg(uchar*, uint, uint);

void
bootmain(void)
{
    7d77:	55                   	push   %ebp
    7d78:	89 e5                	mov    %esp,%ebp
    7d7a:	57                   	push   %edi
    7d7b:	56                   	push   %esi
    7d7c:	53                   	push   %ebx
    7d7d:	83 ec 0c             	sub    $0xc,%esp
  uint8_t* pa;

  elf = ELFHDR;  // scratch space

  // Read 1st page off disk
  readseg((uchar*)elf, SECTSIZE * 8, 0);
    7d80:	6a 00                	push   $0x0
    7d82:	68 00 10 00 00       	push   $0x1000
    7d87:	68 00 00 01 00       	push   $0x10000
    7d8c:	e8 a3 ff ff ff       	call   7d34 <readseg>

  // Is this an ELF executable?
  if(elf->e_magic != ELF_MAGIC)
    7d91:	83 c4 0c             	add    $0xc,%esp
    7d94:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d9b:	45 4c 46 
    7d9e:	75 50                	jne    7df0 <bootmain+0x79>
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uint8_t*)elf + elf->e_phoff);
    7da0:	a1 1c 00 01 00       	mov    0x1001c,%eax
    7da5:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
  eph = ph + elf->e_phnum;
    7dab:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
    7db2:	c1 e6 05             	shl    $0x5,%esi
    7db5:	01 de                	add    %ebx,%esi
  for(; ph < eph; ph++){
    7db7:	39 f3                	cmp    %esi,%ebx
    7db9:	73 2f                	jae    7dea <bootmain+0x73>
    pa = (uint8_t*)ph->p_pa;
    7dbb:	8b 7b 0c             	mov    0xc(%ebx),%edi
    readseg(pa, ph->p_filesz, ph->p_offset);
    7dbe:	ff 73 04             	pushl  0x4(%ebx)
    7dc1:	ff 73 10             	pushl  0x10(%ebx)
    7dc4:	57                   	push   %edi
    7dc5:	e8 6a ff ff ff       	call   7d34 <readseg>
    if(ph->p_memsz > ph->p_filesz)
    7dca:	8b 4b 14             	mov    0x14(%ebx),%ecx
    7dcd:	8b 43 10             	mov    0x10(%ebx),%eax
    7dd0:	83 c4 0c             	add    $0xc,%esp
    7dd3:	39 c1                	cmp    %eax,%ecx
    7dd5:	76 0c                	jbe    7de3 <bootmain+0x6c>
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port));
}
static inline void
stosb(void *addr, int32_t data, int32_t cnt)
{
  asm volatile("cld; rep stosb" :
    7dd7:	01 c7                	add    %eax,%edi
    7dd9:	29 c1                	sub    %eax,%ecx
    7ddb:	b8 00 00 00 00       	mov    $0x0,%eax
    7de0:	fc                   	cld    
    7de1:	f3 aa                	rep stos %al,%es:(%edi)
    return;  // let bootasm.S handle error

  // Load each program segment (ignores ph flags).
  ph = (struct proghdr*)((uint8_t*)elf + elf->e_phoff);
  eph = ph + elf->e_phnum;
  for(; ph < eph; ph++){
    7de3:	83 c3 20             	add    $0x20,%ebx
    7de6:	39 de                	cmp    %ebx,%esi
    7de8:	77 d1                	ja     7dbb <bootmain+0x44>
  }

  // Call the entry point from the ELF header.
  // Does not return!
  entry = (void(*)(void))(elf->e_entry);
  entry();
    7dea:	ff 15 18 00 01 00    	call   *0x10018
}
    7df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7df3:	5b                   	pop    %ebx
    7df4:	5e                   	pop    %esi
    7df5:	5f                   	pop    %edi
    7df6:	5d                   	pop    %ebp
    7df7:	c3                   	ret    
