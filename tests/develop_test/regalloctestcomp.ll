; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 1
@y = global i32 2
@z = global i32 3

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
  %load_lval = load i32, i32* @x, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* @x, align 4
  %load_lval1 = load i32, i32* @y, align 4
  %add2 = add i32 %load_lval1, 2
  store i32 %add2, i32* @y, align 4
  %load_lval3 = load i32, i32* @z, align 4
  %add4 = add i32 %load_lval3, 3
  store i32 %add4, i32* @z, align 4
  %load_lval5 = load i32, i32* %x1, align 4
  %mul = mul i32 %load_lval5, 2
  store i32 %mul, i32* %x1, align 4
  %load_lval6 = load i32, i32* %x2, align 4
  %mul7 = mul i32 %load_lval6, 2
  store i32 %mul7, i32* %x2, align 4
  %load_lval8 = load i32, i32* %x3, align 4
  %mul9 = mul i32 %load_lval8, 2
  store i32 %mul9, i32* %x3, align 4
  %load_lval10 = load i32, i32* %x4, align 4
  %mul11 = mul i32 %load_lval10, 2
  store i32 %mul11, i32* %x4, align 4
  %load_lval12 = load i32, i32* %x1, align 4
  %load_lval13 = load i32, i32* %x2, align 4
  %add14 = add i32 %load_lval12, %load_lval13
  %load_lval15 = load i32, i32* %x3, align 4
  %add16 = add i32 %add14, %load_lval15
  %load_lval17 = load i32, i32* %x4, align 4
  %add18 = add i32 %add16, %load_lval17
  %load_lval19 = load i32, i32* @x, align 4
  %add20 = add i32 %add18, %load_lval19
  %load_lval21 = load i32, i32* @y, align 4
  %add22 = add i32 %add20, %load_lval21
  %load_lval23 = load i32, i32* @z, align 4
  %add24 = add i32 %add22, %load_lval23
  ret i32 %add24
}
