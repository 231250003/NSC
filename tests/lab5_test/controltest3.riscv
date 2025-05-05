  .data
x:
  .word 56
  .data
y:
  .word 98

  .text
  .globl main
main:
  addi sp, sp, -512
mainEntry:
  la t0, x
  lw t0, 0(t0)
  sw t0, 8(sp)
  lw t1, 8(sp)
  sw t1, 4(sp)
  la t2, y
  lw t2, 0(t2)
  sw t2, 16(sp)
  lw t0, 16(sp)
  sw t0, 12(sp)
  j while.cond
cur:
  lw t1, 4(sp)
  sw t1, 24(sp)
  lw t2, 24(sp)
  sw t2, 20(sp)
  lw t0, 20(sp)
  sw t0, 28(sp)
  lw t1, 28(sp)
  mv a0, t1
  addi sp, sp, 512
  li a7, 93
  ecall
while.stmt:
  lw t2, 4(sp)
  sw t2, 32(sp)
  lw t0, 12(sp)
  sw t0, 36(sp)
  lw t1, 32(sp)
  lw t2, 36(sp)
  sgt t0, t1, t2
  sw t0, 40(sp)
  lw t1, 40(sp)
  mv t2, t1
  sw t2, 44(sp)
  lw t0, 44(sp)
  li t1, 0
  xor t2, t0, t1
  snez t2, t2
  sw t2, 48(sp)
  lw t0, 48(sp)
  bnez t0, if.then
  j if.else
while.cond:
  lw t1, 12(sp)
  sw t1, 52(sp)
  lw t2, 52(sp)
  li t0, 0
  xor t1, t2, t0
  snez t1, t1
  sw t1, 56(sp)
  lw t2, 56(sp)
  mv t0, t2
  sw t0, 60(sp)
  lw t1, 60(sp)
  li t2, 0
  xor t0, t1, t2
  snez t0, t0
  sw t0, 64(sp)
  lw t1, 64(sp)
  bnez t1, while.stmt
  j cur
merge:
  j while.cond
if.then:
  lw t2, 4(sp)
  sw t2, 68(sp)
  lw t0, 12(sp)
  sw t0, 72(sp)
  lw t1, 68(sp)
  lw t2, 72(sp)
  sub t0, t1, t2
  sw t0, 76(sp)
  lw t1, 76(sp)
  sw t1, 4(sp)
  j merge
if.else:
  lw t2, 12(sp)
  sw t2, 80(sp)
  lw t0, 4(sp)
  sw t0, 84(sp)
  lw t1, 80(sp)
  lw t2, 84(sp)
  sub t0, t1, t2
  sw t0, 88(sp)
  lw t1, 88(sp)
  sw t1, 12(sp)
  j merge
