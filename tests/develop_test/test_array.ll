; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %f = alloca [5 x [6 x i32]], align 4
  %elemPtr1 = getelementptr [5 x [6 x i32]], [5 x [6 x i32]]* %f, i32 0, i32 0, i32 1
  store i32 1, i32* %elemPtr1, align 4
  %elemPtr7 = getelementptr [5 x [6 x i32]], [5 x [6 x i32]]* %f, i32 0, i32 1, i32 1
  store i32 1, i32* %elemPtr7, align 4
  %elemPtr13 = getelementptr [5 x [6 x i32]], [5 x [6 x i32]]* %f, i32 0, i32 2, i32 1
  store i32 0, i32* %elemPtr13, align 4
  %elemPtr19 = getelementptr [5 x [6 x i32]], [5 x [6 x i32]]* %f, i32 0, i32 3, i32 1
  store i32 0, i32* %elemPtr19, align 4
  %elemPtr25 = getelementptr [5 x [6 x i32]], [5 x [6 x i32]]* %f, i32 0, i32 4, i32 1
  store i32 0, i32* %elemPtr25, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %elemPtr37 = getelementptr [5 x [6 x i32]], [5 x [6 x i32]]* %f, i32 0, i32 4, i32 1
  %load_lval38 = load i32, i32* %elemPtr37, align 4
  ret i32 %load_lval38

while.stmt:                                       ; preds = %while.cond
  %load_lval30 = load i32, i32* %i, align 4
  %add = add i32 %load_lval30, 1
  %elemPtr31 = getelementptr [5 x [6 x i32]], [5 x [6 x i32]]* %f, i32 0, i32 %add, i32 1
  %load_lval32 = load i32, i32* %i, align 4
  %elemPtr33 = getelementptr [5 x [6 x i32]], [5 x [6 x i32]]* %f, i32 0, i32 %load_lval32, i32 1
  %load_lval34 = load i32, i32* %elemPtr33, align 4
  store i32 %load_lval34, i32* %elemPtr31, align 4
  %load_lval35 = load i32, i32* %i, align 4
  %add36 = add i32 %load_lval35, 1
  store i32 %add36, i32* %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 4
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
