; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %a = alloca i32, align 4
  store i32 0, i32* %a, align 4
  %b = alloca i32, align 4
  store i32 0, i32* %b, align 4
  %c = alloca i32, align 4
  store i32 0, i32* %c, align 4
  %load_lval = load i32, i32* %a, align 4
  %add = add i32 %load_lval, 2
  store i32 %add, i32* %b, align 4
  %load_lval1 = load i32, i32* %b, align 4
  %load_lval2 = load i32, i32* %b, align 4
  %mul = mul i32 %load_lval1, %load_lval2
  store i32 %mul, i32* %c, align 4
  %load_lval3 = load i32, i32* %c, align 4
  %add4 = add i32 %load_lval3, 1
  store i32 %add4, i32* %b, align 4
  %load_lval5 = load i32, i32* %b, align 4
  %load_lval6 = load i32, i32* %a, align 4
  %mul7 = mul i32 %load_lval5, %load_lval6
  ret i32 %mul7
}
