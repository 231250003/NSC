; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @f(i32 %x) {
fEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %f = alloca i32, align 4
  store i32 10, i32* %f, align 4
  %load_lval = load i32, i32* %f, align 4
  %load_lval1 = load i32, i32* %param0_addr, align 4
  %add = add i32 %load_lval, %load_lval1
  ret i32 %add
}

define i32 @main() {
mainEntry:
  %main = alloca i32, align 4
  %f = call i32 @f(i32 2)
  store i32 %f, i32* %main, align 4
  %load_lval = load i32, i32* %main, align 4
  %add = add i32 %load_lval, 10
  %f1 = call i32 @f(i32 10)
  %add2 = add i32 %add, %f1
  store i32 %add2, i32* %main, align 4
  %load_lval3 = load i32, i32* %main, align 4
  %f4 = call i32 @f(i32 3)
  %add5 = add i32 %load_lval3, %f4
  ret i32 %add5
}
