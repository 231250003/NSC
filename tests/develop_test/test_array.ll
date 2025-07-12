; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %f = alloca [2 x [6 x i32]], align 4
  %elemPtr = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 0, i32 0
  store i32 0, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 0, i32 1
  store i32 0, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 0, i32 2
  store i32 0, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 0, i32 3
  store i32 0, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 0, i32 4
  store i32 0, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 0, i32 5
  store i32 0, i32* %elemPtr5, align 4
  %elemPtr6 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 1, i32 0
  store i32 0, i32* %elemPtr6, align 4
  %elemPtr7 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 1, i32 1
  store i32 0, i32* %elemPtr7, align 4
  %elemPtr8 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 1, i32 2
  store i32 0, i32* %elemPtr8, align 4
  %elemPtr9 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 1, i32 3
  store i32 0, i32* %elemPtr9, align 4
  %elemPtr10 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 1, i32 4
  store i32 0, i32* %elemPtr10, align 4
  %elemPtr11 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 1, i32 5
  store i32 0, i32* %elemPtr11, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %elemPtr19 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 4, i32 1
  %load_lval20 = load i32, i32* %elemPtr19, align 4
  ret i32 %load_lval20

while.stmt:                                       ; preds = %while.cond
  %load_lval12 = load i32, i32* %i, align 4
  %add = add i32 %load_lval12, 1
  %elemPtr13 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 %add, i32 1
  %load_lval14 = load i32, i32* %i, align 4
  %elemPtr15 = getelementptr [2 x [6 x i32]], [2 x [6 x i32]]* %f, i32 0, i32 %load_lval14, i32 1
  %load_lval16 = load i32, i32* %elemPtr15, align 4
  store i32 %load_lval16, i32* %elemPtr13, align 4
  %load_lval17 = load i32, i32* %i, align 4
  %add18 = add i32 %load_lval17, 1
  store i32 %add18, i32* %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 2
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
