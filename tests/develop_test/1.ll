; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %matrixGrid = alloca [2 x [3 x i32]], align 4
  %valueAccessed = alloca i32, align 4
  store i32 0, i32* %valueAccessed, align 4
  %elemPtr14 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 2
  %load_lval15 = load i32, i32* %elemPtr14, align 4
  store i32 %load_lval15, i32* %valueAccessed, align 4
  %load_lval16 = load i32, i32* %valueAccessed, align 4
  ret i32 %load_lval16
}
