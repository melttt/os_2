
# USER

USER_DIR := ../user
USER_INCLUDE := $(addprefix -I,$(shell find $(USER_DIR) -type d))
USER_C_FILE := $(shell find $(USER_DIR) -name "*.c") 
USER_S_FILE := $(shell find $(USER_DIR) -name "*.S")
USER_OBJS := $(patsubst %.c,%.o,$(USER_C_FILE))
USER_OBJS += $(patsubst %.S,%.o,$(USER_S_FILE))
USER_D_FILE := $(patsubst %.o,%.d,$(USER_OBJS)) 
USER_TEST_FILE := $(USER_DIR)/user_test

INCLUDEFLAGS:=-I./ulib
CFLAGS :=$(INCLUDEFLAGS)  -fno-pic -static -fno-builtin   -fno-strict-aliasing -O0   -Wall -MD -ggdb -gstabs -m32 -Werror -fno-omit-frame-pointer  -nostdinc -fno-stack-protector -fno-asynchronous-unwind-tables
$(USER_TEST_FILE) : $(USER_OBJS)
	@echo 'aha'
	$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $@ $^
