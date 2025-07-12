; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %f = alloca [5 x [2 x i32]], align 4
  %elemPtr = getelementptr [5 x [2 x i32]], [5 x [2 x i32]]* %f, i32 0, i32 0, i32 0
  store i32 0, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [5 x [2 x i32]], [5 x [2 x i32]]* %f, i32 0, i32 0, i32 1
  store i32 0, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [5 x [2 x i32]], [5 x [2 x i32]]* %f, i32 0, i32 1, i32 0
  store i32 0, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [5 x [2 x i32]], [5 x [2 x i32]]* %f, i32 0, i32 1, i32 1
  store i32 0, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [5 x [2 x i32]], [5 x [2 x i32]]* %f, i32 0, i32 2, i32 0
  store i32 0, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [5 x [2 x i32]], [5 x [2 x i32]]* %f, i32 0, i32 2, i32 1
  store i32 0, i32* %elemPtr5, align 4
  %elemPtr6 = getelementptr [5 x [2 x i32]], [5 x [2 x i32]]* %f, i32 0, i32 3, i32 0
  store i32 0, i32* %elemPtr6, align 4
  %elemPtr7 = getelementptr [5 x [2 x i32]], [5 x [2 x i32]]* %f, i32 0, i32 3, i32 1
  store i32 0, i32* %elemPtr7, align 4
  %elemPtr8 = getelementptr [5 x [2 x i32]], [5 x [2 x i32]]* %f, i32 0, i32 4, i32 0
  store i32 0, i32* %elemPtr8, align 4
  %elemPtr9 = getelementptr [5 x [2 x i32]], [5 x [2 x i32]]* %f, i32 0, i32 4, i32 1
  store i32 0, i32* %elemPtr9, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %elemPtr17 = getelementptr [5 x [2 x i32]], [5 x [2 x i32]]* %f, i32 0, i32 4, i32 1
  %load_lval18 = load i32, i32* %elemPtr17, align 4
  ret i32 %load_lval18

while.stmt:                                       ; preds = %while.cond
  %load_lval10 = load i32, i32* %i, align 4
  %add = add i32 %load_lval10, 1
  %elemPtr11 = getelementptr [5 x [2 x i32]], [5 x [2 x i32]]* %f, i32 0, i32 %add, i32 1
  %load_lval12 = load i32, i32* %i, align 4
  %elemPtr13 = getelementptr [5 x [2 x i32]], [5 x [2 x i32]]* %f, i32 0, i32 %load_lval12, i32 1
  %load_lval14 = load i32, i32* %elemPtr13, align 4
  store i32 %load_lval14, i32* %elemPtr11, align 4
  %load_lval15 = load i32, i32* %i, align 4
  %add16 = add i32 %load_lval15, 1
  store i32 %add16, i32* %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 4
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
