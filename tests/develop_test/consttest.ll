; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %a = alloca [3 x [3 x i32]], align 4
  ret i32 3
}
