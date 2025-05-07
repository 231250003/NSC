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
  mv x4, t0
  mv x3, x4
  la t1, y
  lw t1, 0(t1)
  mv x15, t1
  mv x9, x15
  mv x12, x3
  li t2, 0
  xor t0, x12, t2
  seqz t0, t0
  mv x17, t0
  mv t1, x17
  mv x8, t1
  mv x14, x9
  add t2, x8, x14
  mv x1, t2
  li t0, 10
  slt t1, x1, t0
  seqz t1, t1
  mv x11, t1
  mv t2, x11
  mv x16, t2
  li t0, 0
  xor t1, x16, t0
  snez t1, t1
  mv x13, t1
  bnez x13, if.then
  j merge
merge:
  j while.cond
if.then:
  lw t2, null(sp)
  mv x10, t2
  li t0, 10
  sgt t1, x10, t0
  seqz t1, t1
  mv x20, t1
  mv t2, x20
  mv x19, t2
  li t0, 0
  xor t1, x19, t0
  snez t1, t1
  mv x18, t1
  bnez x18, if.then9
  j merge5
merge5:
  j merge
if.then9:
  li t2, 2
  mv a0, t2
  addi sp, sp, 2044
  li a7, 93
  ecall
cur:
  j while.cond30
while.stmt:
  lw t0, null(sp)
  mv x1, t0
  li t1, 2
  sub t2, x1, t1
  mv x27, t2
  sw x27, null(sp)
  lw t0, null(sp)
  mv x13, t0
  li t1, 45
  xor t2, x13, t1
  seqz t2, t2
  mv x16, t2
  mv t0, x16
  mv x8, t0
  li t1, 0
  xor t2, x8, t1
  snez t2, t2
  mv x31, t2
  bnez x31, if.then16
  j if.else
while.cond:
  li t0, -1
  bnez t0, while.stmt
  j cur
merge12:
  j while.cond
if.then16:
  j cur
if.else:
  lw t1, null(sp)
  mv x30, t1
  li t2, 48
  xor t0, x30, t2
  seqz t0, t0
  mv x28, t0
  mv t1, x28
  mv x29, t1
  li t2, 0
  xor t0, x29, t2
  snez t0, t0
  mv x4, t0
  bnez x4, if.then22
  j merge18
merge18:
  j merge12
if.then22:
  lw t1, null(sp)
  mv x11, t1
  li t2, 3
  sub t0, x11, t2
  mv x14, t0
  sw x14, null(sp)
  lw t1, null(sp)
  mv x15, t1
  li t2, 1
  add t0, x15, t2
  mv x12, t0
  sw x12, null(sp)
  j merge18
cur28:
  lw t1, null(sp)
  mv x19, t1
  mv x17, x19
  mv x20, x17
  mv a0, x20
  addi sp, sp, 2044
  li a7, 93
  ecall
while.stmt29:
  j while.cond39
while.cond30:
  lw t2, null(sp)
  mv x23, t2
  lw t0, null(sp)
  mv x24, t0
  add t1, x23, x24
  mv x25, t1
  li t2, 20
  sgt t0, x25, t2
  mv x21, t0
  mv t1, x21
  mv x22, t1
  li t2, 0
  xor t0, x22, t2
  snez t0, t0
  mv x26, t0
  bnez x26, while.stmt29
  j cur28
cur37:
  j while.cond55
while.stmt38:
  lw t1, null(sp)
  mv x29, t1
  li t2, 40
  sgt t0, x29, t2
  mv x28, t0
  mv t1, x28
  mv x30, t1
  li t2, 0
  xor t0, x30, t2
  snez t0, t0
  mv x14, t0
  bnez x14, if.then48
  j if.else49
while.cond39:
  lw t1, null(sp)
  mv x1, t1
  li t2, 10
  sgt t0, x1, t2
  mv x18, t0
  mv t1, x18
  mv x10, t1
  li t2, 0
  xor t0, x10, t2
  snez t0, t0
  mv x13, t0
  bnez x13, while.stmt38
  j cur37
merge44:
  j while.cond39
if.then48:
  lw t1, null(sp)
  mv x4, t1
  li t2, 5
  sub t0, x4, t2
  mv x12, t0
  sw x12, null(sp)
  j cur37
if.else49:
  j cur37
cur53:
  lw t1, null(sp)
  mv x10, t1
  li t2, 3
  sub t0, x10, t2
  mv x20, t0
  sw x20, null(sp)
  lw t1, null(sp)
  mv x28, t1
  li t2, 1
  add t0, x28, t2
  mv x15, t0
  sw x15, null(sp)
  lw t1, null(sp)
  mv x14, t1
  lw t2, null(sp)
  mv x30, t2
  add t0, x14, x30
  mv x13, t0
  li t1, 50
  sgt t2, x13, t1
  mv x19, t2
  mv t0, x19
  mv x11, t0
  li t1, 0
  xor t2, x11, t1
  snez t2, t2
  mv x18, t2
  bnez x18, if.then113
  j merge107
while.stmt54:
  li t0, 30
  mv x1, t0
  j while.cond63
while.cond55:
  lw t1, null(sp)
  mv x8, t1
  li t2, 35
  sgt t0, x8, t2
  mv x16, t0
  mv t1, x16
  mv x27, t1
  li t2, 0
  xor t0, x27, t2
  snez t0, t0
  mv x31, t0
  bnez x31, while.stmt54
  j cur53
cur61:
  lw t1, null(sp)
  mv x4, t1
  li t2, 10
  sub t0, x4, t2
  mv x12, t0
  mv a0, x12
  addi sp, sp, 2044
  li a7, 93
  ecall
while.stmt62:
  lw t1, null(sp)
  mv x11, t1
  li t2, 20
  slt t0, x11, t2
  mv x15, t0
  mv t1, x15
  mv x19, t1
  li t2, 0
  xor t0, x19, t2
  snez t0, t0
  mv x14, t0
  bnez x14, if.then68
  j if.else69
while.cond63:
  li t1, -1
  bnez t1, while.stmt62
  j cur61
merge64:
  j cur61
if.then68:
  lw t2, null(sp)
  mv x28, t2
  mv a0, x28
  addi sp, sp, 2044
  li a7, 93
  ecall
if.else69:
  lw t0, null(sp)
  mv x30, t0
  li t1, 7
  sub t2, x30, t1
  mv x20, t2
  sw x20, null(sp)
  j merge64
merge76:
  j while.cond55
if.then80:
  lw t0, null(sp)
  mv x10, t0
  li t1, 5
  sub t2, x10, t1
  mv x13, t2
  sw x13, null(sp)
  j while.cond55
if.else81:
  lw t0, null(sp)
  mv x1, t0
  li t1, 50
  sgt t2, x1, t1
  mv x20, t2
  mv t0, x20
  mv x28, t0
  li t1, 0
  xor t2, x28, t1
  snez t2, t2
  mv x11, t2
  bnez x11, if.then89
  j if.else90
merge85:
  j merge76
if.then89:
  lw t0, null(sp)
  mv x15, t0
  li t1, 7
  sub t2, x15, t1
  mv x12, t2
  sw x12, null(sp)
  j merge85
if.else90:
  lw t0, null(sp)
  mv x14, t0
  li t1, 30
  sgt t2, x14, t1
  mv x4, t2
  mv t0, x4
  mv x18, t0
  li t1, 0
  xor t2, x18, t1
  snez t2, t2
  mv x19, t2
  bnez x19, if.then98
  j if.else99
merge94:
  j merge85
if.then98:
  lw t0, null(sp)
  mv x27, t0
  li t1, 1
  sub t2, x27, t1
  mv x30, t2
  sw x30, null(sp)
  j merge94
if.else99:
  li t0, 10
  mv a0, t0
  addi sp, sp, 2044
  li a7, 93
  ecall
merge107:
  j while.cond30
if.then113:
  lw t1, null(sp)
  mv x29, t1
  li t2, 10
  sub t0, x29, t2
  mv x17, t0
  sw x17, null(sp)
  j merge107
