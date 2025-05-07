  .data
x:
  .word 56
  .data
y:
  .word 98

  .text
  .globl main
main:
  addi sp, sp, -2044
mainEntry:
  la t0, x
  lw t0, 0(t0)
  mv x3, t0
  mv x1, x3
  la t1, y
  lw t1, 0(t1)
  mv x12, t1
  mv x4, x12
  j while.cond
cur:
  lw t2, null(sp)
  mv x14, t2
  mv x13, x14
  mv x15, x13
  mv a0, x15
  addi sp, sp, 2044
  li a7, 93
  ecall
while.stmt:
  lw t0, null(sp)
  mv x22, t0
  lw t1, null(sp)
  mv x20, t1
  sgt t2, x22, x20
  mv x16, t2
  mv t0, x16
  mv x23, t0
  li t1, 0
  xor t2, x23, t1
  snez t2, t2
  mv x26, t2
  bnez x26, if.then
  j if.else
while.cond:
  lw t0, null(sp)
  mv x10, t0
  li t1, 0
  xor t2, x10, t1
  snez t2, t2
  mv x9, t2
  mv t0, x9
  mv x8, t0
  li t1, 0
  xor t2, x8, t1
  snez t2, t2
  mv x11, t2
  bnez x11, while.stmt
  j cur
merge:
  j while.cond
if.then:
  lw t0, null(sp)
  mv x18, t0
  lw t1, null(sp)
  mv x19, t1
  sub t2, x18, x19
  mv x17, t2
  sw x17, null(sp)
  j merge
if.else:
  lw t0, null(sp)
  mv x25, t0
  lw t1, null(sp)
  mv x24, t1
  sub t2, x25, x24
  mv x21, t2
  sw x21, null(sp)
  j merge
