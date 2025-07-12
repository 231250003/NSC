; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %f = alloca [5 x [10 x i32]], align 4
  %elemPtr = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 0, i32 0
  store i32 0, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 0, i32 1
  store i32 0, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 0, i32 2
  store i32 0, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 0, i32 3
  store i32 0, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 0, i32 4
  store i32 0, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 0, i32 5
  store i32 0, i32* %elemPtr5, align 4
  %elemPtr6 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 0, i32 6
  store i32 0, i32* %elemPtr6, align 4
  %elemPtr7 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 0, i32 7
  store i32 0, i32* %elemPtr7, align 4
  %elemPtr8 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 0, i32 8
  store i32 0, i32* %elemPtr8, align 4
  %elemPtr9 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 0, i32 9
  store i32 0, i32* %elemPtr9, align 4
  %elemPtr10 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 1, i32 0
  store i32 0, i32* %elemPtr10, align 4
  %elemPtr11 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 1, i32 1
  store i32 0, i32* %elemPtr11, align 4
  %elemPtr12 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 1, i32 2
  store i32 0, i32* %elemPtr12, align 4
  %elemPtr13 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 1, i32 3
  store i32 0, i32* %elemPtr13, align 4
  %elemPtr14 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 1, i32 4
  store i32 0, i32* %elemPtr14, align 4
  %elemPtr15 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 1, i32 5
  store i32 0, i32* %elemPtr15, align 4
  %elemPtr16 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 1, i32 6
  store i32 0, i32* %elemPtr16, align 4
  %elemPtr17 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 1, i32 7
  store i32 0, i32* %elemPtr17, align 4
  %elemPtr18 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 1, i32 8
  store i32 0, i32* %elemPtr18, align 4
  %elemPtr19 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 1, i32 9
  store i32 0, i32* %elemPtr19, align 4
  %elemPtr20 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 2, i32 0
  store i32 0, i32* %elemPtr20, align 4
  %elemPtr21 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 2, i32 1
  store i32 0, i32* %elemPtr21, align 4
  %elemPtr22 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 2, i32 2
  store i32 0, i32* %elemPtr22, align 4
  %elemPtr23 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 2, i32 3
  store i32 0, i32* %elemPtr23, align 4
  %elemPtr24 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 2, i32 4
  store i32 0, i32* %elemPtr24, align 4
  %elemPtr25 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 2, i32 5
  store i32 0, i32* %elemPtr25, align 4
  %elemPtr26 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 2, i32 6
  store i32 0, i32* %elemPtr26, align 4
  %elemPtr27 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 2, i32 7
  store i32 0, i32* %elemPtr27, align 4
  %elemPtr28 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 2, i32 8
  store i32 0, i32* %elemPtr28, align 4
  %elemPtr29 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 2, i32 9
  store i32 0, i32* %elemPtr29, align 4
  %elemPtr30 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 3, i32 0
  store i32 0, i32* %elemPtr30, align 4
  %elemPtr31 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 3, i32 1
  store i32 0, i32* %elemPtr31, align 4
  %elemPtr32 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 3, i32 2
  store i32 0, i32* %elemPtr32, align 4
  %elemPtr33 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 3, i32 3
  store i32 0, i32* %elemPtr33, align 4
  %elemPtr34 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 3, i32 4
  store i32 0, i32* %elemPtr34, align 4
  %elemPtr35 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 3, i32 5
  store i32 0, i32* %elemPtr35, align 4
  %elemPtr36 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 3, i32 6
  store i32 0, i32* %elemPtr36, align 4
  %elemPtr37 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 3, i32 7
  store i32 0, i32* %elemPtr37, align 4
  %elemPtr38 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 3, i32 8
  store i32 0, i32* %elemPtr38, align 4
  %elemPtr39 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 3, i32 9
  store i32 0, i32* %elemPtr39, align 4
  %elemPtr40 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 4, i32 0
  store i32 0, i32* %elemPtr40, align 4
  %elemPtr41 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 4, i32 1
  store i32 0, i32* %elemPtr41, align 4
  %elemPtr42 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 4, i32 2
  store i32 0, i32* %elemPtr42, align 4
  %elemPtr43 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 4, i32 3
  store i32 0, i32* %elemPtr43, align 4
  %elemPtr44 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 4, i32 4
  store i32 0, i32* %elemPtr44, align 4
  %elemPtr45 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 4, i32 5
  store i32 0, i32* %elemPtr45, align 4
  %elemPtr46 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 4, i32 6
  store i32 0, i32* %elemPtr46, align 4
  %elemPtr47 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 4, i32 7
  store i32 0, i32* %elemPtr47, align 4
  %elemPtr48 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 4, i32 8
  store i32 0, i32* %elemPtr48, align 4
  %elemPtr49 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 4, i32 9
  store i32 0, i32* %elemPtr49, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %elemPtr57 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 4, i32 1
  %load_lval58 = load i32, i32* %elemPtr57, align 4
  ret i32 %load_lval58

while.stmt:                                       ; preds = %while.cond
  %load_lval50 = load i32, i32* %i, align 4
  %add = add i32 %load_lval50, 1
  %elemPtr51 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 %add, i32 1
  %load_lval52 = load i32, i32* %i, align 4
  %elemPtr53 = getelementptr [5 x [10 x i32]], [5 x [10 x i32]]* %f, i32 0, i32 %load_lval52, i32 1
  %load_lval54 = load i32, i32* %elemPtr53, align 4
  store i32 %load_lval54, i32* %elemPtr51, align 4
  %load_lval55 = load i32, i32* %i, align 4
  %add56 = add i32 %load_lval55, 1
  store i32 %add56, i32* %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 4
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
