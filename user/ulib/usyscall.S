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
    int $64; \
    ret

