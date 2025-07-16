; ModuleID = 'my_module'
source_filename = "my_module"

define void @f([3 x i32]* %a) {
fEntry:
  %i = alloca i32, align 4
  store i32 1, i32* %i, align 4
  br label %for.cond

cur:                                              ; preds = %for.cond
  ret void

for.stmt:                                         ; preds = %for.cond
  %load_lval1 = load i32, i32* %i, align 4
  %elemPtr = getelementptr [3 x i32], [3 x i32]* %a, i32 0, i32 %load_lval1
  %load_lval2 = load i32, i32* %i, align 4
  %elemPtr3 = getelementptr [3 x i32], [3 x i32]* %a, i32 0, i32 %load_lval2
  %load_lval4 = load i32, i32* %elemPtr3, align 4
  %load_lval5 = load i32, i32* %i, align 4
  %sub = sub i32 %load_lval5, 1
  %elemPtr6 = getelementptr [3 x i32], [3 x i32]* %a, i32 0, i32 %sub
  %load_lval7 = load i32, i32* %elemPtr6, align 4
  %add = add i32 %load_lval4, %load_lval7
  store i32 %add, i32* %elemPtr, align 4
  %load_lval8 = load i32, i32* %i, align 4
  %add9 = add i32 %load_lval8, 1
  store i32 %add9, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.stmt, %fEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 3
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %for.stmt, label %cur
}

define i32 @main() {
mainEntry:
  %matrixGrid = alloca [2 x [3 x i32]], align 4
  %elemPtr = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 0, i32 0
  store i32 1, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 0, i32 1
  %elemPtr2 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 0, i32 2
  store i32 3, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 0
  %elemPtr4 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 1
  store i32 5, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 2
  store i32 15, i32* %elemPtr1, align 4
  store i32 25, i32* %elemPtr3, align 4
  store i32 40, i32* %elemPtr5, align 4
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

cur:                                              ; preds = %for.cond
  %i48 = alloca i32, align 4
  store i32 0, i32* %i48, align 4
  br label %for.cond47

for.stmt:                                         ; preds = %for.cond
  %j = alloca i32, align 4
  store i32 1, i32* %j, align 4
  br label %for.cond19

for.cond:                                         ; preds = %cur17, %mainEntry
  %load_lval16 = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval16, 2
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %for.stmt, label %cur

cur17:                                            ; preds = %for.cond19
  %load_lval43 = load i32, i32* %i, align 4
  %add44 = add i32 %load_lval43, 1
  store i32 %add44, i32* %i, align 4
  br label %for.cond

for.stmt18:                                       ; preds = %for.cond19
  %load_lval24 = load i32, i32* %i, align 4
  %load_lval25 = load i32, i32* %j, align 4
  %elemPtr26 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 %load_lval24, i32 %load_lval25
  %load_lval27 = load i32, i32* %i, align 4
  %load_lval28 = load i32, i32* %j, align 4
  %sub = sub i32 %load_lval28, 1
  %elemPtr29 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 %load_lval27, i32 %sub
  %load_lval30 = load i32, i32* %elemPtr29, align 4
  %load_lval31 = load i32, i32* %i, align 4
  %load_lval32 = load i32, i32* %j, align 4
  %elemPtr33 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 %load_lval31, i32 %load_lval32
  %load_lval34 = load i32, i32* %elemPtr33, align 4
  %add35 = add i32 %load_lval30, %load_lval34
  %elemPtr36 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 2
  %load_lval37 = load i32, i32* %elemPtr36, align 4
  %add38 = add i32 %add35, %load_lval37
  store i32 %add38, i32* %elemPtr26, align 4
  %load_lval39 = load i32, i32* %i, align 4
  %elemPtr40 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 %load_lval39
  call void @f([3 x i32]* %elemPtr40)
  %load_lval41 = load i32, i32* %j, align 4
  %add42 = add i32 %load_lval41, 1
  store i32 %add42, i32* %j, align 4
  br label %for.cond19

for.cond19:                                       ; preds = %for.stmt18, %for.stmt
  %load_lval20 = load i32, i32* %j, align 4
  %cmp21 = icmp slt i32 %load_lval20, 3
  %zext_to_i3222 = zext i1 %cmp21 to i32
  %to_bool23 = icmp ne i32 %zext_to_i3222, 0
  br i1 %to_bool23, label %for.stmt18, label %cur17

cur45:                                            ; preds = %for.cond47
  %load_lval71 = load i32, i32* %sum, align 4
  ret i32 %load_lval71

for.stmt46:                                       ; preds = %for.cond47
  %j56 = alloca i32, align 4
  store i32 0, i32* %j56, align 4
  br label %for.cond55

for.cond47:                                       ; preds = %cur53, %cur
  %load_lval49 = load i32, i32* %i48, align 4
  %cmp50 = icmp slt i32 %load_lval49, 2
  %zext_to_i3251 = zext i1 %cmp50 to i32
  %to_bool52 = icmp ne i32 %zext_to_i3251, 0
  br i1 %to_bool52, label %for.stmt46, label %cur45

cur53:                                            ; preds = %for.cond55
  %load_lval69 = load i32, i32* %i48, align 4
  %add70 = add i32 %load_lval69, 1
  store i32 %add70, i32* %i48, align 4
  br label %for.cond47

for.stmt54:                                       ; preds = %for.cond55
  %load_lval61 = load i32, i32* %sum, align 4
  %load_lval62 = load i32, i32* %i48, align 4
  %load_lval63 = load i32, i32* %j56, align 4
  %elemPtr64 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 %load_lval62, i32 %load_lval63
  %load_lval65 = load i32, i32* %elemPtr64, align 4
  %add66 = add i32 %load_lval61, %load_lval65
  store i32 %add66, i32* %sum, align 4
  %load_lval67 = load i32, i32* %j56, align 4
  %add68 = add i32 %load_lval67, 1
  store i32 %add68, i32* %j56, align 4
  br label %for.cond55

for.cond55:                                       ; preds = %for.stmt54, %for.stmt46
  %load_lval57 = load i32, i32* %j56, align 4
  %cmp58 = icmp slt i32 %load_lval57, 3
  %zext_to_i3259 = zext i1 %cmp58 to i32
  %to_bool60 = icmp ne i32 %zext_to_i3259, 0
  br i1 %to_bool60, label %for.stmt54, label %cur53
}
