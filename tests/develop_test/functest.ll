; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @f(i32 %x, i32 %y, i32 %z) {
fEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %y, i32* %param1_addr, align 4
  %param2_addr = alloca i32, align 4
  store i32 %z, i32* %param2_addr, align 4
  %load_lval = load i32, i32* %param2_addr, align 4
  %load_lval1 = load i32, i32* %param2_addr, align 4
  %add = add i32 %load_lval, %load_lval1
  store i32 %add, i32* %param2_addr, align 4
  %load_lval2 = load i32, i32* %param0_addr, align 4
  %load_lval3 = load i32, i32* %param0_addr, align 4
  %add4 = add i32 %load_lval2, %load_lval3
  store i32 %add4, i32* %param0_addr, align 4
  %load_lval5 = load i32, i32* %param1_addr, align 4
  %load_lval6 = load i32, i32* %param1_addr, align 4
  %add7 = add i32 %load_lval5, %load_lval6
  store i32 %add7, i32* %param1_addr, align 4
  %load_lval8 = load i32, i32* %param0_addr, align 4
  %load_lval9 = load i32, i32* %param1_addr, align 4
  %add10 = add i32 %load_lval8, %load_lval9
  %load_lval11 = load i32, i32* %param2_addr, align 4
  %add12 = add i32 %add10, %load_lval11
  ret i32 %add12
}

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 30, i32* %x, align 4
  %load_lval = load i32, i32* %x, align 4
  %f = call i32 @f(i32 10, i32 20, i32 %load_lval)
  store i32 %f, i32* %x, align 4
  %load_lval1 = load i32, i32* %x, align 4
  %add = add i32 %load_lval1, 5
  store i32 %add, i32* %x, align 4
  %load_lval2 = load i32, i32* %x, align 4
  ret i32 %load_lval2
}
