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
  mv x4, t0
  mv x1, x4
  la t1, y
  lw t1, 0(t1)
  mv x15, t1
  mv x9, x15
  mv x12, x1
  li t2, 0
  xor t0, x12, t2
  seqz t0, t0
  mv x17, t0
  mv t1, x17
  mv x8, t1
  mv x14, x9
  add t2, x8, x14
  mv x3, t2
  li t0, 10
  slt t1, x3, t0
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
  mv x10, x1
  li t2, 10
  sgt t0, x10, t2
  seqz t0, t0
  mv x20, t0
  mv t1, x20
  mv x19, t1
  li t2, 0
  xor t0, x19, t2
  snez t0, t0
  mv x18, t0
  bnez x18, if.then9
  j merge5
merge5:
  j merge
if.then9:
  li t1, 2
  mv a0, t1
  addi sp, sp, 512
  li a7, 93
  ecall
cur:
  j while.cond30
while.stmt:
  mv x21, x1
  li t2, 2
  sub t0, x21, t2
  mv x28, t0
  mv x1, x28
  mv x16, x1
  li t1, 45
  xor t2, x16, t1
  seqz t2, t2
  mv x3, t2
  mv t0, x3
  mv x8, t0
  li t1, 0
  xor t2, x8, t1
  snez t2, t2
  mv x13, t2
  bnez x13, if.then16
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
  mv x31, x1
  li t1, 48
  xor t2, x31, t1
  seqz t2, t2
  mv x29, t2
  mv t0, x29
  mv x30, t0
  li t1, 0
  xor t2, x30, t1
  snez t2, t2
  mv x4, t2
  bnez x4, if.then22
  j merge18
merge18:
  j merge12
if.then22:
  mv x11, x9
  li t0, 3
  sub t1, x11, t0
  mv x14, t1
  mv x9, x14
  mv x15, x1
  li t2, 1
  add t0, x15, t2
  mv x12, t0
  mv x1, x12
  j merge18
cur28:
  mv x19, x1
  mv x17, x19
  mv x20, x17
  mv a0, x20
  addi sp, sp, 512
  li a7, 93
  ecall
while.stmt29:
  j while.cond39
while.cond30:
  mv x24, x9
  mv x25, x1
  add t1, x24, x25
  mv x26, t1
  li t2, 20
  sgt t0, x26, t2
  mv x22, t0
  mv t1, x22
  mv x23, t1
  li t2, 0
  xor t0, x23, t2
  snez t0, t0
  mv x27, t0
  bnez x27, while.stmt29
  j cur28
cur37:
  j while.cond55
while.stmt38:
  mv x8, x1
  li t1, 40
  sgt t2, x8, t1
  mv x30, t2
  mv t0, x30
  mv x29, t0
  li t1, 0
  xor t2, x29, t1
  snez t2, t2
  mv x14, t2
  bnez x14, if.then48
  j if.else49
while.cond39:
  mv x18, x1
  li t0, 10
  sgt t1, x18, t0
  mv x21, t1
  mv t2, x21
  mv x16, t2
  li t0, 0
  xor t1, x16, t0
  snez t1, t1
  mv x10, t1
  bnez x10, while.stmt38
  j cur37
merge44:
  j while.cond39
if.then48:
  mv x4, x1
  li t2, 5
  sub t0, x4, t2
  mv x12, t0
  mv x1, x12
  j cur37
if.else49:
  j cur37
cur53:
  mv x15, x9
  li t1, 3
  sub t2, x15, t1
  mv x29, t2
  mv x9, x29
  mv x8, x1
  li t0, 1
  add t1, x8, t0
  mv x11, t1
  mv x1, x11
  mv x30, x1
  mv x14, x9
  add t2, x30, x14
  mv x10, t2
  li t0, 50
  sgt t1, x10, t0
  mv x17, t1
  mv t2, x17
  mv x19, t2
  li t0, 0
  xor t1, x19, t0
  snez t1, t1
  mv x21, t1
  bnez x21, if.then113
  j merge107
while.stmt54:
  li t2, 30
  mv x18, t2
  j while.cond63
while.cond55:
  mv x31, x9
  li t0, 35
  sgt t1, x31, t0
  mv x3, t1
  mv t2, x3
  mv x28, t2
  li t0, 0
  xor t1, x28, t0
  snez t1, t1
  mv x13, t1
  bnez x13, while.stmt54
  j cur53
cur61:
  mv x4, x9
  li t2, 10
  sub t0, x4, t2
  mv x12, t0
  mv a0, x12
  addi sp, sp, 512
  li a7, 93
  ecall
while.stmt62:
  mv x11, x18
  li t1, 20
  slt t2, x11, t1
  mv x17, t2
  mv t0, x17
  mv x19, t0
  li t1, 0
  xor t2, x19, t1
  snez t2, t2
  mv x30, t2
  bnez x30, if.then68
  j if.else69
while.cond63:
  li t0, -1
  bnez t0, while.stmt62
  j cur61
merge64:
  j cur61
if.then68:
  mv x8, x18
  mv a0, x8
  addi sp, sp, 512
  li a7, 93
  ecall
if.else69:
  mv x14, x18
  li t1, 7
  sub t2, x14, t1
  mv x29, t2
  mv x18, x29
  j merge64
merge76:
  j while.cond55
if.then80:
  mv x15, x9
  li t0, 5
  sub t1, x15, t0
  mv x10, t1
  mv x9, x10
  j while.cond55
if.else81:
  mv x21, x9
  li t2, 50
  sgt t0, x21, t2
  mv x4, t0
  mv t1, x4
  mv x12, t1
  li t2, 0
  xor t0, x12, t2
  snez t0, t0
  mv x29, t0
  bnez x29, if.then89
  j if.else90
merge85:
  j merge76
if.then89:
  mv x8, x9
  li t1, 7
  sub t2, x8, t1
  mv x11, t2
  mv x9, x11
  j merge85
if.else90:
  mv x19, x9
  li t0, 30
  sgt t1, x19, t0
  mv x17, t1
  mv t2, x17
  mv x30, t2
  li t0, 0
  xor t1, x30, t0
  snez t1, t1
  mv x18, t1
  bnez x18, if.then98
  j if.else99
merge94:
  j merge85
if.then98:
  mv x28, x9
  li t2, 1
  sub t0, x28, t2
  mv x14, t0
  mv x9, x14
  j merge94
if.else99:
  li t1, 10
  mv a0, t1
  addi sp, sp, 512
  li a7, 93
  ecall
merge107:
  j while.cond30
if.then113:
  mv x16, x1
  li t2, 10
  sub t0, x16, t2
  mv x20, t0
  mv x1, x20
  j merge107
