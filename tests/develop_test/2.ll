; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %matrixGrid = alloca [2 x [3 x i32]], align 4
  ret i32 40
}
