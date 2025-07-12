; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %f = alloca [5 x [1 x i32]], align 4
  %elemPtr = getelementptr [5 x [1 x i32]], [5 x [1 x i32]]* %f, i32 0, i32 0, i32 0
  store i32 0, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [5 x [1 x i32]], [5 x [1 x i32]]* %f, i32 0, i32 1, i32 0
  store i32 0, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [5 x [1 x i32]], [5 x [1 x i32]]* %f, i32 0, i32 2, i32 0
  store i32 0, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [5 x [1 x i32]], [5 x [1 x i32]]* %f, i32 0, i32 3, i32 0
  store i32 0, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [5 x [1 x i32]], [5 x [1 x i32]]* %f, i32 0, i32 4, i32 0
  store i32 0, i32* %elemPtr4, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %elemPtr12 = getelementptr [5 x [1 x i32]], [5 x [1 x i32]]* %f, i32 0, i32 4, i32 1
  %load_lval13 = load i32, i32* %elemPtr12, align 4
  ret i32 %load_lval13

while.stmt:                                       ; preds = %while.cond
  %load_lval5 = load i32, i32* %i, align 4
  %add = add i32 %load_lval5, 1
  %elemPtr6 = getelementptr [5 x [1 x i32]], [5 x [1 x i32]]* %f, i32 0, i32 %add, i32 0
  %load_lval7 = load i32, i32* %i, align 4
  %elemPtr8 = getelementptr [5 x [1 x i32]], [5 x [1 x i32]]* %f, i32 0, i32 %load_lval7, i32 0
  %load_lval9 = load i32, i32* %elemPtr8, align 4
  store i32 %load_lval9, i32* %elemPtr6, align 4
  %load_lval10 = load i32, i32* %i, align 4
  %add11 = add i32 %load_lval10, 1
  store i32 %add11, i32* %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 4
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
