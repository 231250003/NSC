; ModuleID = 'my_module'
source_filename = "my_module"

@ROWS_A = global i32 2
@COLS_A = global i32 3
@ROWS_B = global i32 3
@COLS_B = global i32 2

define void @matrix_multiply([2 x [3 x i32]]* %a, [3 x [2 x i32]]* %b, [2 x [2 x i32]]* %result) {
matrix_multiplyEntry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

cur:                                              ; preds = %for.cond
  ret void

for.stmt:                                         ; preds = %for.cond
  %j = alloca i32, align 4
  store i32 0, i32* %j, align 4
  br label %for.cond4

for.cond:                                         ; preds = %cur2, %matrix_multiplyEntry
  %load_lval = load i32, i32* %i, align 4
  %load_lval1 = load i32, i32* @ROWS_A, align 4
  %cmp = icmp slt i32 %load_lval, %load_lval1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %for.stmt, label %cur

cur2:                                             ; preds = %for.cond4
  %load_lval21 = load i32, i32* %i, align 4
  %add22 = add i32 %load_lval21, 1
  store i32 %add22, i32* %i, align 4
  br label %for.cond

for.stmt3:                                        ; preds = %for.cond4
  %load_lval10 = load i32, i32* %i, align 4
  %load_lval11 = load i32, i32* %j, align 4
  %elemPtr = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 %load_lval10, i32 %load_lval11
  store i32 0, i32* %elemPtr, align 4
  %load_lval12 = load i32, i32* %i, align 4
  %load_lval13 = load i32, i32* %j, align 4
  %elemPtr14 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 %load_lval12, i32 %load_lval13
  %load_lval15 = load i32, i32* %i, align 4
  %load_lval16 = load i32, i32* %j, align 4
  %elemPtr17 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 %load_lval15, i32 %load_lval16
  %load_lval18 = load i32, i32* %elemPtr17, align 4
  %add = add i32 %load_lval18, 1
  store i32 %add, i32* %elemPtr14, align 4
  %load_lval19 = load i32, i32* %j, align 4
  %add20 = add i32 %load_lval19, 1
  store i32 %add20, i32* %j, align 4
  br label %for.cond4

for.cond4:                                        ; preds = %for.stmt3, %for.stmt
  %load_lval5 = load i32, i32* %j, align 4
  %load_lval6 = load i32, i32* @COLS_B, align 4
  %cmp7 = icmp slt i32 %load_lval5, %load_lval6
  %zext_to_i328 = zext i1 %cmp7 to i32
  %to_bool9 = icmp ne i32 %zext_to_i328, 0
  br i1 %to_bool9, label %for.stmt3, label %cur2
}

define i32 @main() {
mainEntry:
  %matrix_a = alloca [2 x [3 x i32]], align 4
  %elemPtr = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrix_a, i32 0, i32 0, i32 0
  store i32 1, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrix_a, i32 0, i32 0, i32 1
  store i32 2, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrix_a, i32 0, i32 0, i32 2
  store i32 3, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrix_a, i32 0, i32 1, i32 0
  store i32 4, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrix_a, i32 0, i32 1, i32 1
  store i32 5, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrix_a, i32 0, i32 1, i32 2
  store i32 6, i32* %elemPtr5, align 4
  %matrix_b = alloca [3 x [2 x i32]], align 4
  %elemPtr6 = getelementptr [3 x [2 x i32]], [3 x [2 x i32]]* %matrix_b, i32 0, i32 0, i32 0
  store i32 7, i32* %elemPtr6, align 4
  %elemPtr7 = getelementptr [3 x [2 x i32]], [3 x [2 x i32]]* %matrix_b, i32 0, i32 0, i32 1
  store i32 8, i32* %elemPtr7, align 4
  %elemPtr8 = getelementptr [3 x [2 x i32]], [3 x [2 x i32]]* %matrix_b, i32 0, i32 1, i32 0
  store i32 9, i32* %elemPtr8, align 4
  %elemPtr9 = getelementptr [3 x [2 x i32]], [3 x [2 x i32]]* %matrix_b, i32 0, i32 1, i32 1
  store i32 10, i32* %elemPtr9, align 4
  %elemPtr10 = getelementptr [3 x [2 x i32]], [3 x [2 x i32]]* %matrix_b, i32 0, i32 2, i32 0
  store i32 11, i32* %elemPtr10, align 4
  %elemPtr11 = getelementptr [3 x [2 x i32]], [3 x [2 x i32]]* %matrix_b, i32 0, i32 2, i32 1
  store i32 12, i32* %elemPtr11, align 4
  %result = alloca [2 x [2 x i32]], align 4
  %elemPtr12 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 0, i32 0
  store i32 0, i32* %elemPtr12, align 4
  %elemPtr13 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 0, i32 1
  store i32 0, i32* %elemPtr13, align 4
  %elemPtr14 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 0
  store i32 0, i32* %elemPtr14, align 4
  %elemPtr15 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 1
  store i32 0, i32* %elemPtr15, align 4
  %elemPtr16 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrix_a, i32 0
  %elemPtr17 = getelementptr [3 x [2 x i32]], [3 x [2 x i32]]* %matrix_b, i32 0
  %elemPtr18 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0
  call void @matrix_multiply([2 x [3 x i32]]* %elemPtr16, [3 x [2 x i32]]* %elemPtr17, [2 x [2 x i32]]* %elemPtr18)
  %elemPtr19 = getelementptr [2 x [2 x i32]], [2 x [2 x i32]]* %result, i32 0, i32 1, i32 1
  %load_lval = load i32, i32* %elemPtr19, align 4
  ret i32 %load_lval
}
