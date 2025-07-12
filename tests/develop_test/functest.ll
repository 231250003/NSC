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
  %load_lval = load i32, i32* %param0_addr, align 4
  %load_lval1 = load i32, i32* %param1_addr, align 4
  %add = add i32 %load_lval, %load_lval1
  %load_lval2 = load i32, i32* %param2_addr, align 4
  %add3 = add i32 %add, %load_lval2
  ret i32 %add3
}

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 30, i32* %x, align 4
  %f = call i32 @f(i32 10, i32 20, i32 10)
  store i32 %f, i32* %x, align 4
  %load_lval = load i32, i32* %x, align 4
  %add = add i32 %load_lval, 5
  store i32 %add, i32* %x, align 4
  %load_lval1 = load i32, i32* %x, align 4
  ret i32 %load_lval1
}
