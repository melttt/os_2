
# TOOLS

TOOLS_DIR := ../tools
TOOLS_INCLUDE := $(addprefix -I,$(shell find $(TOOLS_DIR) -type d))
TOOLS_C_FILE := $(shell find $(TOOLS_DIR) -name "*.c") 
TOOLS_S_FILE := $(shell find $(TOOLS_DIR) -name "*.S")
TOOLS_OBJS := $(patsubst %.c,%.o,$(TOOLS_C_FILE))
TOOLS_OBJS += $(patsubst %.S,%.o,$(TOOLS_S_FILE))
TOOLS_D_FILE := $(patsubst %.o,%.d,$(TOOLS_OBJS)) 

INCLUDEFLAGS:= -I../libs
#CFLAGS :=$(INCLUDEFLAGS)  -fno-pic -static -fno-builtin   -fno-strict-aliasing -O0   -Wall -MD -ggdb -gstabs -m32 -Werror -fno-omit-frame-pointer  -nostdinc -fno-stack-protector -fno-asynchronous-unwind-tables


mkfs : ./mkfs.c 
	gcc  -o $@ ./mkfs.c 

test : mkfs fs.img

fs.img : 
	@echo making fs.img......
	dd if=/dev/zero of=fs.img bs=1M count=512
	@echo fs.img ok!

clean:
	rm -rf $(TOOLS_OBJS)
	rm -rf mkfs 



