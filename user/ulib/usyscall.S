/*
#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret
*/
.globl put;
  put: \
    movl $22, %eax; \
    movl $40, %ebx; \
    int $64; \
    ret

.globl exit;
  exit: \
    movl $2, %eax; \
    movl $40, %ebx; \
    int $64; \
    ret

.globl show_pid;
  show_pid: \
    movl $23, %eax; \
    movl $40, %ebx; \
    int $64; \
    ret

.globl sys_test;
  sys_test: \
    movl $24, %eax; \
    movl $40, %ebx; \
    int $64; \
    ret

