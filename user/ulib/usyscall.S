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
