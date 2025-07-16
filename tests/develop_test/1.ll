; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %matrixGrid = alloca [2 x [3 x i32]], align 4
  %elemPtr = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 0, i32 0
  store i32 0, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 0, i32 1
  store i32 0, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 0, i32 2
  store i32 0, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 0
  store i32 0, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 1
  store i32 0, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 2
  store i32 0, i32* %elemPtr5, align 4
  %fixedRow = alloca i32, align 4
  store i32 1, i32* %fixedRow, align 4
  %fixedCol = alloca i32, align 4
  store i32 2, i32* %fixedCol, align 4
  %valueAccessed = alloca i32, align 4
  store i32 64, i32* %valueAccessed, align 4
  %elemPtr6 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 0, i32 1
  store i32 15, i32* %elemPtr6, align 4
  %elemPtr7 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 0
  store i32 25, i32* %elemPtr7, align 4
  %elemPtr8 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 2
  %elemPtr9 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 0, i32 1
  %load_lval = load i32, i32* %elemPtr9, align 4
  %elemPtr10 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 0
  %load_lval11 = load i32, i32* %elemPtr10, align 4
  %add = add i32 %load_lval, %load_lval11
  store i32 %add, i32* %elemPtr8, align 4
  %load_lval12 = load i32, i32* %fixedRow, align 4
  %load_lval13 = load i32, i32* %fixedCol, align 4
  %elemPtr14 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 %load_lval12, i32 %load_lval13
  %load_lval15 = load i32, i32* %elemPtr14, align 4
  store i32 %load_lval15, i32* %valueAccessed, align 4
  %load_lval16 = load i32, i32* %valueAccessed, align 4
  ret i32 %load_lval16
}
