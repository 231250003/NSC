; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 10

define i32 @f(i32 %x) {
fEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %load_lval = load i32, i32* @a, align 4
  %add = add i32 %load_lval, 10
  ret i32 %add
}

define i32 @main() {
mainEntry:
  %f = call i32 @f(i32 10)
  ret i32 %f
}
