DIR := $(shell pwd)
BOOTLOADER_DIR := ./boot
TOOLS_DIR := ./tools
KERN_DIR := ./kern
LIBS_DIR := ./libs
KERN_LD := ./tools/kernel.ld
INCLUDEFLAGS := $(addprefix -I,$(shell find $(DIR)/kern -type d)) -I$(DIR)/libs -I$(DIR)/boot 
C_OBJS = $(shell find $(KERN_DIR) -name "*.c")
S_OBJS := $(shell find $(KERN_DIR) -name "*.S")
LIBS_OBJS = $(shell find $(LIBS_DIR) -name "*.c") 
C_PATH =./$(addprefix :,$(shell find ./kern -type d)):./libs:./boot:./user:./user/ulib
OBJS := $(patsubst %.c,%.o,$(C_OBJS))
OBJS += $(patsubst %.S,%.o,$(S_OBJS))
OBJS += $(patsubst %.c,%.o,$(LIBS_OBJS))
OBJS_EXTRA := ./kern/trap/vectors.o


# USER
USER_DIR := ./user
USER_INCLUDE := $(addprefix -I,$(shell find $(USER_DIR) -type d))
USER_C_FILE := $(shell find $(USER_DIR) -name "*.c") 
USER_S_FILE := $(shell find $(USER_DIR) -name "*.S")
USER_OBJS := $(patsubst %.c,%.o,$(USER_C_FILE))
USER_OBJS += $(patsubst %.S,%.o,$(USER_S_FILE))
USER_D_FILE := $(patsubst %.o,%.d,$(USER_OBJS)) 
USER_TEST_FILE := $(USER_DIR)/user_test


ifeq ($(findstring $(OBJS_EXTRA),$(OBJS)),)
OBJS += $(OBJS_EXTRA)	
endif
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

CFLAGS :=$(INCLUDEFLAGS) $(USER_INCLUDE) -fno-pic -static -fno-builtin   -fno-strict-aliasing -O0   -Wall -MD -ggdb -gstabs -m32 -Werror -fno-omit-frame-pointer  -nostdinc -fno-stack-protector -fno-asynchronous-unwind-tables -Wno-error=char-subscripts -Wno-error=unused-function
BOOTCFLAGS :=$(INCLUDEFLAGS) $(USER_INCLUDE) -fno-pic -static -fno-builtin   -fno-strict-aliasing  -Os -Wall -MD  -m32 -Werror -fno-omit-frame-pointer  -nostdinc -fno-stack-protector -fno-asynchronous-unwind-tables -Wno-error=char-subscripts -Wno-error=unused-function

ASFLAGS = -m32 -gdwarf-2 -Wa,-divide $(INCLUDEFLAGS)
# FreeBSD ld wants ``elf_i386_fbsd''
LDFLAGS += -m $(shell $(LD) -V | grep elf_i386 2>/dev/null | head -n 1)

all: mkfs 
	
#os.img: $(BOOTLOADER_DIR)/bootblock $(KERN_DIR)/kernel fs.img
#dd if=/dev/zero of=os.img count=10000
#	dd if=$(BOOTLOADER_DIR)/bootblock of=os.img conv=notrunc
#	dd if=$(KERN_DIR)/kernel of=os.img seek=1 conv=notrunc

$(BOOTLOADER_DIR)/bootblock: $(BOOTLOADER_DIR)/bootasm.S $(BOOTLOADER_DIR)/bootmain.c 
	$(CC) $(BOOTCFLAGS) -fno-pic -Os  -nostdinc $(INCLUDEFLAGS) -c $(BOOTLOADER_DIR)/bootmain.c -o $(BOOTLOADER_DIR)/bootmain.o 
	$(CC) $(BOOTCFLAGS) -fno-pic -nostdinc $(INCLUDEFLAGS) -c $(BOOTLOADER_DIR)/bootasm.S -o $(BOOTLOADER_DIR)/bootasm.o
	$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 -o $(BOOTLOADER_DIR)/bootblock.o $(BOOTLOADER_DIR)/bootasm.o $(BOOTLOADER_DIR)/bootmain.o
	$(OBJDUMP) -S $(BOOTLOADER_DIR)/bootblock.o > $(BOOTLOADER_DIR)/bootblock.asm
	$(OBJCOPY) -S -O binary -j .text $(BOOTLOADER_DIR)/bootblock.o $(BOOTLOADER_DIR)/bootblock
	$(BOOTLOADER_DIR)/sign.pl $(BOOTLOADER_DIR)/bootblock

$(KERN_DIR)/kernel: $(OBJS) $(KERN_LD)  #$(USER_TEST_FILE)
	$(LD) $(LDFLAGS) -T $(KERN_LD) -o $@  $(OBJS)  
	$(OBJDUMP) -S $@ > $@.asm
	$(OBJDUMP) -t $@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $@.sym 


./kern/trap/vectors.S: $(TOOLS_DIR)/vectors.pl
	perl $< > $@




mkfs : $(BOOTLOADER_DIR)/bootblock $(KERN_DIR)/kernel fs.img
	$(MAKE) -C ./tools
	$(MAKE) -C ./user
	
#$(USER_TEST_FILE) : $(USER_OBJS)
#	$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $@ $^

	
ifndef CPUS
CPUS := 4
endif


fs.img : 
#	dd if=/dev/zero of=$@ bs=1K count=2880
	dd if=/dev/zero of=$@ bs=1M count=5

GDBPORT = $(shell expr `id -u` % 5000 + 25000)
#QEMUOPTS =  -drive file=os.img,index=0,media=disk,format=raw -smp $(CPUS) -m 512 $(QEMUEXTRA) -drive file=fs.img,media=disk,cache=writeback 
QEMUOPTS =  -drive file=fs.img,index=0,media=disk,format=raw -smp $(CPUS) -m 512 $(QEMUEXTRA) 

QEMUGDB = $(shell if $(QEMU) -help | grep -q '^-gdb'; \
	then echo "-gdb tcp::$(GDBPORT)"; \
	else echo "-s -p $(GDBPORT)"; fi)

qemu:  fs.img
	$(QEMU)  -serial mon:stdio $(QEMUOPTS)  
qemu2:
	$(QEMU)  -serial mon:stdio $(QEMUOPTS)

qemu-gdb:   fs.img $(TOOLS_DIR)/.gdbinit
	@echo "*** Now run 'gdb'." 1>&2
	$(QEMU) -serial mon:stdio $(QEMUOPTS) -S $(QEMUGDB)
define f_clean
	rm -f $(BOOTLOADER_DIR)/*.o $(BOOTLOADER_DIR)/*.asm $(BOOTLOADER_DIR)/*.d $(BOOTLOADER_DIR)/bootblock
	rm -f os.img fs.img
	rm -f ./kern/kernel ./kern/*.sym ./kern/*.asm
	rm -f $(OBJS) $(D_OBJS)
	rm -f $(USER_OBJS) $(USER_D_FILE) $(USER_TEST_FILE)
	rm -f ./kern/trap/vectors.*
	rm -f ./tags
endef
clean: 
	$(MAKE) clean -C ./tools
	$(MAKE) clean -C ./user
	$(f_clean)

.ONESHELL:

SHELL := /bin/bash
msg:=""
git:
ifneq ($(msg),"")
	$(f_clean)
	git add -A
	git commit -m "$(msg)"
	git push origin master
else
	@echo "commit string should not be empty ==>make git msg=\"your string\""
endif
test :
	@echo $(INCLUDEFLAGS)
ifeq ($(msg),"")
	echo "eq";
else
	echo "nonono";
endif

