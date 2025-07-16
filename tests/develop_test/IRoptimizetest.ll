; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %x = alloca i32, align 4
  store i32 1, i32* %x, align 4
  %add = add i32 1, 1
  %add2 = add i32 2, 1
  ret i32 3
}
