; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %n = alloca i32, align 4
  store i32 6, i32* %n, align 4
  %add = add i32 0, 1
  %add2 = add i32 1, 1
  ret i32 2
}
