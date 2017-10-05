BOOTLOADER_DIR := ./boot
TOOLS_DIR := ./tools
KERN_DIR := ./kern
LIBS_DIR := ./libs
KERN_LD := ./tools/kernel.ld
INCLUDEFLAGS := $(addprefix -I,$(shell find ./kern -type d)) -I./libs
C_OBJS = $(shell find $(KERN_DIR) -name "*.c")
S_OBJS = $(shell find $(KERN_DIR) -name "*.S")
LIBS_OBJS = $(shell find $(LIBS_DIR) -name "*.c") 
OBJS := $(patsubst %.c,%.o,$(C_OBJS))
OBJS += $(patsubst %.S,%.o,$(S_OBJS))
OBJS += $(patsubst %.c,%.o,$(LIBS_OBJS))
D_OBJS := $(patsubst %o,%d,$(OBJS))


ifndef QEMU
QEMU = $(shell if which qemu > /dev/null; \
	then echo qemu; exit; \
	elif which qemu-system-i386 > /dev/null; \
	then echo qemu-system-i386; exit; \
	elif which qemu-system-x86_64 > /dev/null; \
	then echo qemu-system-x86_64; exit; \
	else \
	qemu=/Applications/Q.app/Contents/MacOS/i386-softmmu.app/Contents/MacOS/i386-softmmu; \
	if test -x $$qemu; then echo $$qemu; exit; fi; fi; \
	echo "***" 1>&2; \
	echo "*** Error: Couldn't find a working QEMU executable." 1>&2; \
	echo "*** Is the directory containing the qemu binary in your PATH" 1>&2; \
	echo "*** or have you tried setting the QEMU variable in Makefile?" 1>&2; \
	echo "***" 1>&2; exit 1)
endif

CC = $(TOOLPREFIX)gcc
AS = $(TOOLPREFIX)gas
LD = $(TOOLPREFIX)ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump
CFLAGS = $(INCLUDEFLAGS) -fno-pic -static -fno-builtin   -fno-strict-aliasing   -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer
#CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing -fvar-tracking -fvar-tracking-assignments -O0 -g -Wall -MD -gdwarf-2 -m32 -Werror -fno-omit-frame-pointer
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
ASFLAGS = -m32 -gdwarf-2 -Wa,-divide $(INCLUDEFLAGS)
# FreeBSD ld wants ``elf_i386_fbsd''
LDFLAGS += -m $(shell $(LD) -V | grep elf_i386 2>/dev/null | head -n 1)


xv6.img: $(BOOTLOADER_DIR)/bootblock $(KERN_DIR)/kernel
	dd if=/dev/zero of=xv6.img count=10000
	dd if=$(BOOTLOADER_DIR)/bootblock of=xv6.img conv=notrunc
	dd if=$(KERN_DIR)/kernel of=xv6.img seek=1 conv=notrunc

$(BOOTLOADER_DIR)/bootblock: $(BOOTLOADER_DIR)/bootasm.S $(BOOTLOADER_DIR)/bootmain.c
	$(CC) $(CFLAGS) -fno-pic -O  -nostdinc $(INCLUDEFLAGS) -c $(BOOTLOADER_DIR)/bootmain.c -o $(BOOTLOADER_DIR)/bootmain.o 
	$(CC) $(CFLAGS) -fno-pic -nostdinc $(INCLUDEFLAGS) -c $(BOOTLOADER_DIR)/bootasm.S -o $(BOOTLOADER_DIR)/bootasm.o
	$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 -o $(BOOTLOADER_DIR)/bootblock.o $(BOOTLOADER_DIR)/bootasm.o $(BOOTLOADER_DIR)/bootmain.o
	$(OBJDUMP) -S $(BOOTLOADER_DIR)/bootblock.o > $(BOOTLOADER_DIR)/bootblock.asm
	$(OBJCOPY) -S -O binary -j .text $(BOOTLOADER_DIR)/bootblock.o $(BOOTLOADER_DIR)/bootblock
	$(BOOTLOADER_DIR)/sign.pl $(BOOTLOADER_DIR)/bootblock


$(KERN_DIR)/kernel: $(OBJS) $(KERN_LD) 
	$(LD) $(LDFLAGS) -T $(KERN_LD) -o $@  $(OBJS) 
	$(OBJDUMP) -S $@ > $@.asm
	$(OBJDUMP) -t $@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $@.sym 
ifndef CPUS
CPUS := 2
endif
GDBPORT = $(shell expr `id -u` % 5000 + 25000)
QEMUOPTS =  -drive file=xv6.img,index=0,media=disk,format=raw -smp $(CPUS) -m 512 $(QEMUEXTRA)
QEMUGDB = $(shell if $(QEMU) -help | grep -q '^-gdb'; \
	then echo "-gdb tcp::$(GDBPORT)"; \
	else echo "-s -p $(GDBPORT)"; fi)

qemu: xv6.img 
	$(QEMU)  -serial mon:stdio $(QEMUOPTS)  

qemu-gdb:  xv6.img  $(TOOLS_DIR)/.gdbinit
	@echo "*** Now run 'gdb'." 1>&2
	$(QEMU) -serial mon:stdio $(QEMUOPTS) -S $(QEMUGDB)

clean: 
	rm -f $(BOOTLOADER_DIR)/*.o $(BOOTLOADER_DIR)/*.asm $(BOOTLOADER_DIR)/*.d $(BOOTLOADER_DIR)/bootblock
	rm -f xv6.img
	rm -f ./kern/kernel ./kern/*.sym ./kern/*.asm
	rm -f $(OBJS) $(D_OBJS)
