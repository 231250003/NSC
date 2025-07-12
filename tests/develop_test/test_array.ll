; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %f = alloca [2 x [10 x i32]], align 4
  %elemPtr = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 0, i32 0
  store i32 0, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 0, i32 1
  store i32 0, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 0, i32 2
  store i32 0, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 0, i32 3
  store i32 0, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 0, i32 4
  store i32 0, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 0, i32 5
  store i32 0, i32* %elemPtr5, align 4
  %elemPtr6 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 0, i32 6
  store i32 0, i32* %elemPtr6, align 4
  %elemPtr7 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 0, i32 7
  store i32 0, i32* %elemPtr7, align 4
  %elemPtr8 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 0, i32 8
  store i32 0, i32* %elemPtr8, align 4
  %elemPtr9 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 0, i32 9
  store i32 0, i32* %elemPtr9, align 4
  %elemPtr10 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 1, i32 0
  store i32 0, i32* %elemPtr10, align 4
  %elemPtr11 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 1, i32 1
  store i32 0, i32* %elemPtr11, align 4
  %elemPtr12 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 1, i32 2
  store i32 0, i32* %elemPtr12, align 4
  %elemPtr13 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 1, i32 3
  store i32 0, i32* %elemPtr13, align 4
  %elemPtr14 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 1, i32 4
  store i32 0, i32* %elemPtr14, align 4
  %elemPtr15 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 1, i32 5
  store i32 0, i32* %elemPtr15, align 4
  %elemPtr16 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 1, i32 6
  store i32 0, i32* %elemPtr16, align 4
  %elemPtr17 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 1, i32 7
  store i32 0, i32* %elemPtr17, align 4
  %elemPtr18 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 1, i32 8
  store i32 0, i32* %elemPtr18, align 4
  %elemPtr19 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 1, i32 9
  store i32 0, i32* %elemPtr19, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %elemPtr27 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 1, i32 1
  %load_lval28 = load i32, i32* %elemPtr27, align 4
  ret i32 %load_lval28

while.stmt:                                       ; preds = %while.cond
  %load_lval20 = load i32, i32* %i, align 4
  %add = add i32 %load_lval20, 1
  %elemPtr21 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 %add, i32 1
  %load_lval22 = load i32, i32* %i, align 4
  %elemPtr23 = getelementptr [2 x [10 x i32]], [2 x [10 x i32]]* %f, i32 0, i32 %load_lval22, i32 1
  %load_lval24 = load i32, i32* %elemPtr23, align 4
  store i32 %load_lval24, i32* %elemPtr21, align 4
  %load_lval25 = load i32, i32* %i, align 4
  %add26 = add i32 %load_lval25, 1
  store i32 %add26, i32* %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
