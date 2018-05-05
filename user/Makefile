
USER_DIR := $(shell pwd)
USER_INCLUDE := $(addprefix -I,$(shell find $(USER_DIR) -type d))
USER_C_FILE := $(shell find $(USER_DIR) -name "*.c") 
USER_S_FILE := $(shell find $(USER_DIR) -name "*.S")
USER_OBJS := $(patsubst %.c,%.o,$(USER_C_FILE))
USER_OBJS += $(patsubst %.S,%.o,$(USER_S_FILE))
USER_D_FILE := $(patsubst %.o,%.d,$(USER_OBJS)) 
OUTPUT_FILES := $(filter-out $(USER_DIR)/ulib/umain, $(basename $(USER_C_FILE)))


LDFLAGS += -m $(shell $(LD) -V | grep elf_i386 2>/dev/null | head -n 1)
INCLUDEFLAGS:=-I./ulib -I../libs
CFLAGS :=$(INCLUDEFLAGS)  -fno-pic -static -fno-builtin   -fno-strict-aliasing -O0   -Wall -MD -ggdb -gstabs -m32 -Werror -fno-omit-frame-pointer  -nostdinc -fno-stack-protector -fno-asynchronous-unwind-tables -c

all: $(OUTPUT_FILES) 
	for target in $(notdir $(OUTPUT_FILES)); \
	do		\
	../tools/mkfs -f ../fs.img -a $$target -l ;\
	done

$(OUTPUT_FILES): % : %.o  ../libs/syslib.o ./ulib/umain.o ../libs/string.o ../libs/printfmt.o
	$(LD) $(LDFLAGS) -N -e umain -Ttext 0 -o $@ $^

%.o : %.c
	cc $(CFLAGS) $< -c -o $@


test :
	@echo $(OUTPUT_FILES)
	for target in $(notdir $(OUTPUT_FILES)); \
	do		\
	echo  $$target;	\
	done	



clean :
	rm -rf $(USER_D_FILE) $(USER_OBJS)
	rm -rf $(OUTPUT_FILES)
