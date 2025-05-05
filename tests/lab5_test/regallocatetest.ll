; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 1
@y = global i32 2
@z = global i32 3
@a = global i32 4
@b = global i32 5
@c = global i32 6
@d = global i32 7
@e = global i32 8
@f = global i32 9
@g = global i32 10
@h = global i32 11
@i = global i32 12
@j = global i32 13
@k = global i32 14
@l = global i32 15
@m = global i32 16
@n = global i32 17
@o = global i32 18
@p = global i32 19
@q = global i32 20

define i32 @main() {
mainEntry:
  %x1 = alloca i32, align 4
  store i32 1, i32* %x1, align 4
  %x2 = alloca i32, align 4
  store i32 2, i32* %x2, align 4
  %x3 = alloca i32, align 4
  store i32 3, i32* %x3, align 4
  %x4 = alloca i32, align 4
  store i32 4, i32* %x4, align 4
  %x5 = alloca i32, align 4
  store i32 5, i32* %x5, align 4
  %x6 = alloca i32, align 4
  store i32 6, i32* %x6, align 4
  %x7 = alloca i32, align 4
  store i32 7, i32* %x7, align 4
  %x8 = alloca i32, align 4
  store i32 8, i32* %x8, align 4
  %x9 = alloca i32, align 4
  store i32 9, i32* %x9, align 4
  %x10 = alloca i32, align 4
  store i32 10, i32* %x10, align 4
  %x11 = alloca i32, align 4
  store i32 11, i32* %x11, align 4
  %x12 = alloca i32, align 4
  store i32 12, i32* %x12, align 4
  %x13 = alloca i32, align 4
  store i32 13, i32* %x13, align 4
  %x14 = alloca i32, align 4
  store i32 14, i32* %x14, align 4
  %x15 = alloca i32, align 4
  store i32 15, i32* %x15, align 4
  %x16 = alloca i32, align 4
  store i32 16, i32* %x16, align 4
  %x17 = alloca i32, align 4
  store i32 17, i32* %x17, align 4
  %x18 = alloca i32, align 4
  store i32 18, i32* %x18, align 4
  %x19 = alloca i32, align 4
  store i32 19, i32* %x19, align 4
  %x20 = alloca i32, align 4
  store i32 20, i32* %x20, align 4
  %load_lval = load i32, i32* %x1, align 4
  %mul = mul i32 %load_lval, 2
  store i32 %mul, i32* %x1, align 4
  %load_lval1 = load i32, i32* %x2, align 4
  %mul2 = mul i32 %load_lval1, 2
  store i32 %mul2, i32* %x2, align 4
  %load_lval3 = load i32, i32* %x3, align 4
  %mul4 = mul i32 %load_lval3, 2
  store i32 %mul4, i32* %x3, align 4
  %load_lval5 = load i32, i32* %x4, align 4
  %mul6 = mul i32 %load_lval5, 2
  store i32 %mul6, i32* %x4, align 4
  %load_lval7 = load i32, i32* %x5, align 4
  %mul8 = mul i32 %load_lval7, 2
  store i32 %mul8, i32* %x5, align 4
  %load_lval9 = load i32, i32* %x6, align 4
  %mul10 = mul i32 %load_lval9, 2
  store i32 %mul10, i32* %x6, align 4
  %load_lval11 = load i32, i32* %x7, align 4
  %mul12 = mul i32 %load_lval11, 2
  store i32 %mul12, i32* %x7, align 4
  %load_lval13 = load i32, i32* %x8, align 4
  %mul14 = mul i32 %load_lval13, 2
  store i32 %mul14, i32* %x8, align 4
  %load_lval15 = load i32, i32* %x9, align 4
  %mul16 = mul i32 %load_lval15, 2
  store i32 %mul16, i32* %x9, align 4
  %load_lval17 = load i32, i32* %x10, align 4
  %mul18 = mul i32 %load_lval17, 2
  store i32 %mul18, i32* %x10, align 4
  %load_lval19 = load i32, i32* %x11, align 4
  %mul20 = mul i32 %load_lval19, 2
  store i32 %mul20, i32* %x11, align 4
  %load_lval21 = load i32, i32* %x12, align 4
  %mul22 = mul i32 %load_lval21, 2
  store i32 %mul22, i32* %x12, align 4
  %load_lval23 = load i32, i32* %x13, align 4
  %mul24 = mul i32 %load_lval23, 2
  store i32 %mul24, i32* %x13, align 4
  %load_lval25 = load i32, i32* %x14, align 4
  %mul26 = mul i32 %load_lval25, 2
  store i32 %mul26, i32* %x14, align 4
  %load_lval27 = load i32, i32* %x15, align 4
  %mul28 = mul i32 %load_lval27, 2
  store i32 %mul28, i32* %x15, align 4
  %load_lval29 = load i32, i32* %x16, align 4
  %mul30 = mul i32 %load_lval29, 2
  store i32 %mul30, i32* %x16, align 4
  %load_lval31 = load i32, i32* %x17, align 4
  %mul32 = mul i32 %load_lval31, 2
  store i32 %mul32, i32* %x17, align 4
  %load_lval33 = load i32, i32* %x18, align 4
  %mul34 = mul i32 %load_lval33, 2
  store i32 %mul34, i32* %x18, align 4
  %load_lval35 = load i32, i32* %x19, align 4
  %mul36 = mul i32 %load_lval35, 2
  store i32 %mul36, i32* %x19, align 4
  %load_lval37 = load i32, i32* %x20, align 4
  %mul38 = mul i32 %load_lval37, 2
  store i32 %mul38, i32* %x20, align 4
  %load_lval39 = load i32, i32* %x1, align 4
  %load_lval40 = load i32, i32* %x2, align 4
  %add = add i32 %load_lval39, %load_lval40
  %load_lval41 = load i32, i32* %x3, align 4
  %add42 = add i32 %add, %load_lval41
  %load_lval43 = load i32, i32* %x4, align 4
  %add44 = add i32 %add42, %load_lval43
  %load_lval45 = load i32, i32* %x5, align 4
  %add46 = add i32 %add44, %load_lval45
  %load_lval47 = load i32, i32* %x6, align 4
  %add48 = add i32 %add46, %load_lval47
  %load_lval49 = load i32, i32* %x7, align 4
  %add50 = add i32 %add48, %load_lval49
  %load_lval51 = load i32, i32* %x8, align 4
  %add52 = add i32 %add50, %load_lval51
  %load_lval53 = load i32, i32* %x9, align 4
  %add54 = add i32 %add52, %load_lval53
  %load_lval55 = load i32, i32* %x10, align 4
  %add56 = add i32 %add54, %load_lval55
  %load_lval57 = load i32, i32* %x11, align 4
  %add58 = add i32 %add56, %load_lval57
  %load_lval59 = load i32, i32* %x12, align 4
  %add60 = add i32 %add58, %load_lval59
  %load_lval61 = load i32, i32* %x13, align 4
  %add62 = add i32 %add60, %load_lval61
  %load_lval63 = load i32, i32* %x14, align 4
  %add64 = add i32 %add62, %load_lval63
  %load_lval65 = load i32, i32* %x15, align 4
  %add66 = add i32 %add64, %load_lval65
  %load_lval67 = load i32, i32* %x16, align 4
  %add68 = add i32 %add66, %load_lval67
  %load_lval69 = load i32, i32* %x17, align 4
  %add70 = add i32 %add68, %load_lval69
  %load_lval71 = load i32, i32* %x18, align 4
  %add72 = add i32 %add70, %load_lval71
  %load_lval73 = load i32, i32* %x19, align 4
  %add74 = add i32 %add72, %load_lval73
  %load_lval75 = load i32, i32* %x20, align 4
  %add76 = add i32 %add74, %load_lval75
  ret i32 %add76
}
