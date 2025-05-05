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
  mv x3, t0
  mv x1, x3
  sw x3, 4(sp)
  la t1, y
  lw t1, 0(t1)
  mv x8, t1
  mv x4, x8
  sw x8, 8(sp)
  mv x9, x1
  li t2, 0
  xor t0, x9, t2
  seqz t0, t0
  mv x10, t0
  sw x9, 12(sp)
  mv t1, x10
  mv x11, t1
  sw x10, 16(sp)
  mv x12, x4
  add t2, x11, x12
  mv x13, t2
  sw x11, 20(sp)
  sw x12, 24(sp)
  li t0, 10
  slt t1, x13, t0
  seqz t1, t1
  mv x14, t1
  sw x13, 28(sp)
  mv t2, x14
  mv x15, t2
  sw x14, 32(sp)
  li t0, 0
  xor t1, x15, t0
  snez t1, t1
  mv x16, t1
  sw x15, 36(sp)
  bnez x16, if.then
  j merge
merge:
  sw x16, 40(sp)
  sw x17, 44(sp)
  j while.cond
if.then:
  mv x20, x1
  li t2, 10
  sgt t0, x20, t2
  seqz t0, t0
  mv x21, t0
  sw x20, 48(sp)
  mv t1, x21
  mv x22, t1
  sw x21, 52(sp)
  li t2, 0
  xor t0, x22, t2
  snez t0, t0
  mv x23, t0
  sw x22, 56(sp)
  bnez x23, if.then9
  j merge5
merge5:
  sw x25, 60(sp)
  sw x23, 64(sp)
  sw x24, 68(sp)
  j merge
if.then9:
  sw x18, 72(sp)
  li t1, 2
  mv a0, t1
  addi sp, sp, 512
  li a7, 93
  ecall
cur:
  j while.cond30
while.stmt:
  mv x27, x1
  li t2, 2
  sub t0, x27, t2
  mv x28, t0
  sw x27, 76(sp)
  mv x1, x28
  sw x28, 80(sp)
  mv x29, x1
  li t1, 45
  xor t2, x29, t1
  seqz t2, t2
  mv x30, t2
  sw x29, 84(sp)
  mv t0, x30
  mv x31, t0
  sw x30, 88(sp)
  li t1, 0
  xor t2, x31, t1
  snez t2, t2
  mv x3, t2
  sw x31, 92(sp)
  bnez x3, if.then16
  j if.else
while.cond:
  sw x3, 96(sp)
  sw x9, 100(sp)
  sw x8, 104(sp)
  li t0, -1
  bnez t0, while.stmt
  j cur
merge12:
  sw x10, 108(sp)
  j while.cond
if.then16:
  sw x19, 112(sp)
  j cur
if.else:
  sw x11, 116(sp)
  mv x12, x1
  li t1, 48
  xor t2, x12, t1
  seqz t2, t2
  mv x13, t2
  sw x12, 120(sp)
  mv t0, x13
  mv x14, t0
  sw x13, 124(sp)
  li t1, 0
  xor t2, x14, t1
  snez t2, t2
  mv x15, t2
  sw x14, 128(sp)
  bnez x15, if.then22
  j merge18
merge18:
  sw x17, 132(sp)
  sw x15, 136(sp)
  j merge12
if.then22:
  sw x20, 140(sp)
  mv x21, x4
  li t0, 3
  sub t1, x21, t0
  mv x22, t1
  sw x21, 144(sp)
  mv x4, x22
  sw x22, 148(sp)
  mv x25, x1
  li t2, 1
  add t0, x25, t2
  mv x23, t0
  sw x25, 152(sp)
  mv x1, x23
  sw x23, 156(sp)
  j merge18
cur28:
  sw x16, 160(sp)
  mv x18, x1
  mv x24, x18
  sw x18, 164(sp)
  mv x27, x24
  sw x24, 168(sp)
  mv a0, x27
  addi sp, sp, 512
  li a7, 93
  ecall
while.stmt29:
  sw x27, 172(sp)
  j while.cond39
while.cond30:
  mv x29, x4
  mv x30, x1
  add t1, x29, x30
  mv x31, t1
  sw x29, 176(sp)
  sw x30, 180(sp)
  li t2, 20
  sgt t0, x31, t2
  mv x3, t0
  sw x31, 184(sp)
  mv t1, x3
  mv x9, t1
  sw x3, 188(sp)
  li t2, 0
  xor t0, x9, t2
  snez t0, t0
  mv x8, t0
  sw x9, 192(sp)
  bnez x8, while.stmt29
  j cur28
cur37:
  sw x19, 196(sp)
  sw x8, 200(sp)
  sw x10, 204(sp)
  j while.cond55
while.stmt38:
  mv x12, x1
  li t1, 40
  sgt t2, x12, t1
  mv x13, t2
  sw x12, 208(sp)
  mv t0, x13
  mv x14, t0
  sw x13, 212(sp)
  li t1, 0
  xor t2, x14, t1
  snez t2, t2
  mv x17, t2
  sw x14, 216(sp)
  bnez x17, if.then48
  j if.else49
while.cond39:
  sw x15, 220(sp)
  sw x20, 224(sp)
  sw x17, 228(sp)
  mv x21, x1
  li t0, 10
  sgt t1, x21, t0
  mv x22, t1
  sw x21, 232(sp)
  mv t2, x22
  mv x25, t2
  sw x22, 236(sp)
  li t0, 0
  xor t1, x25, t0
  snez t1, t1
  mv x23, t1
  sw x25, 240(sp)
  bnez x23, while.stmt38
  j cur37
merge44:
  sw x16, 244(sp)
  sw x23, 248(sp)
  j while.cond39
if.then48:
  sw x28, 252(sp)
  mv x24, x1
  li t2, 5
  sub t0, x24, t2
  mv x27, t0
  sw x24, 256(sp)
  mv x1, x27
  sw x27, 260(sp)
  j cur37
if.else49:
  j cur37
cur53:
  sw x18, 264(sp)
  mv x29, x4
  li t1, 3
  sub t2, x29, t1
  mv x30, t2
  sw x29, 268(sp)
  mv x4, x30
  sw x30, 272(sp)
  mv x31, x1
  li t0, 1
  add t1, x31, t0
  mv x3, t1
  sw x31, 276(sp)
  mv x1, x3
  sw x3, 280(sp)
  mv x9, x1
  mv x19, x4
  add t2, x9, x19
  mv x8, t2
  sw x19, 284(sp)
  sw x9, 288(sp)
  li t0, 50
  sgt t1, x8, t0
  mv x10, t1
  sw x8, 292(sp)
  mv t2, x10
  mv x12, t2
  sw x10, 296(sp)
  li t0, 0
  xor t1, x12, t0
  snez t1, t1
  mv x13, t1
  sw x12, 300(sp)
  bnez x13, if.then113
  j merge107
while.stmt54:
  sw x14, 304(sp)
  sw x13, 308(sp)
  li t2, 30
  mv x20, t2
  j while.cond63
while.cond55:
  sw x17, 312(sp)
  mv x21, x4
  li t0, 35
  sgt t1, x21, t0
  mv x22, t1
  sw x21, 316(sp)
  mv t2, x22
  mv x25, t2
  sw x22, 320(sp)
  li t0, 0
  xor t1, x25, t0
  snez t1, t1
  mv x16, t1
  sw x25, 324(sp)
  bnez x16, while.stmt54
  j cur53
cur61:
  sw x23, 328(sp)
  sw x28, 332(sp)
  sw x16, 336(sp)
  mv x24, x4
  li t2, 10
  sub t0, x24, t2
  mv x27, t0
  sw x24, 340(sp)
  mv a0, x27
  addi sp, sp, 512
  li a7, 93
  ecall
while.stmt62:
  sw x27, 344(sp)
  mv x18, x20
  li t1, 20
  slt t2, x18, t1
  mv x29, t2
  sw x18, 348(sp)
  mv t0, x29
  mv x30, t0
  sw x29, 352(sp)
  li t1, 0
  xor t2, x30, t1
  snez t2, t2
  mv x31, t2
  sw x30, 356(sp)
  bnez x31, if.then68
  j if.else69
while.cond63:
  sw x19, 360(sp)
  sw x31, 364(sp)
  sw x3, 368(sp)
  li t0, -1
  bnez t0, while.stmt62
  j cur61
merge64:
  sw x9, 372(sp)
  j cur61
if.then68:
  sw x8, 376(sp)
  mv x10, x20
  mv a0, x10
  addi sp, sp, 512
  li a7, 93
  ecall
if.else69:
  sw x10, 380(sp)
  mv x12, x20
  li t1, 7
  sub t2, x12, t1
  mv x14, t2
  sw x12, 384(sp)
  mv x20, x14
  sw x14, 388(sp)
  sw x20, 392(sp)
  j merge64
merge76:
  sw x13, 396(sp)
  j while.cond55
if.then80:
  mv x17, x4
  li t0, 5
  sub t1, x17, t0
  mv x21, t1
  sw x17, 400(sp)
  mv x4, x21
  sw x21, 404(sp)
  j while.cond55
if.else81:
  sw x11, 408(sp)
  mv x22, x4
  li t2, 50
  sgt t0, x22, t2
  mv x25, t0
  sw x22, 412(sp)
  mv t1, x25
  mv x23, t1
  sw x25, 416(sp)
  li t2, 0
  xor t0, x23, t2
  snez t0, t0
  mv x28, t0
  sw x23, 420(sp)
  bnez x28, if.then89
  j if.else90
merge85:
  sw x28, 424(sp)
  sw x16, 428(sp)
  sw x24, 432(sp)
  j merge76
if.then89:
  sw x27, 436(sp)
  mv x18, x4
  li t1, 7
  sub t2, x18, t1
  mv x29, t2
  sw x18, 440(sp)
  mv x4, x29
  sw x29, 444(sp)
  j merge85
if.else90:
  mv x19, x4
  li t0, 30
  sgt t1, x19, t0
  mv x31, t1
  sw x19, 448(sp)
  mv t2, x31
  mv x3, t2
  sw x31, 452(sp)
  li t0, 0
  xor t1, x3, t0
  snez t1, t1
  mv x9, t1
  sw x3, 456(sp)
  bnez x9, if.then98
  j if.else99
merge94:
  sw x9, 460(sp)
  sw x8, 464(sp)
  sw x10, 468(sp)
  j merge85
if.then98:
  sw x30, 472(sp)
  mv x12, x4
  li t2, 1
  sub t0, x12, t2
  mv x14, t0
  sw x12, 476(sp)
  mv x4, x14
  sw x4, 480(sp)
  sw x14, 484(sp)
  j merge94
if.else99:
  sw x20, 488(sp)
  li t1, 10
  mv a0, t1
  addi sp, sp, 512
  li a7, 93
  ecall
merge107:
  j while.cond30
if.then113:
  sw x26, 492(sp)
  mv x13, x1
  li t2, 10
  sub t0, x13, t2
  mv x17, t0
  sw x13, 496(sp)
  mv x1, x17
  sw x17, 500(sp)
  sw x1, 504(sp)
  j merge107
