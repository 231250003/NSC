; ModuleID = 'my_module'
source_filename = "my_module"

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
  %load_lval = load i32, i32* %x1, align 4
  %mul = mul i32 %load_lval, 2
  store i32 %mul, i32* %x1, align 4
  %load_lval1 = load i32, i32* %x2, align 4
  %mul2 = mul i32 %load_lval1, 2
  store i32 %mul2, i32* %x2, align 4
  %load_lval3 = load i32, i32* %x1, align 4
  %load_lval4 = load i32, i32* %x2, align 4
  %add = add i32 %load_lval3, %load_lval4
  %load_lval5 = load i32, i32* %x3, align 4
  %add6 = add i32 %add, %load_lval5
  %load_lval7 = load i32, i32* %x4, align 4
  %add8 = add i32 %add6, %load_lval7
  ret i32 %add8
}
