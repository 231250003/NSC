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
  %mul = mul i32 %load_lval4, 3
  %load_lval5 = load i32, i32* %i, align 4
  %sub = sub i32 %load_lval5, 1
  %elemPtr6 = getelementptr [3 x i32], [3 x i32]* %a, i32 0, i32 %sub
  %load_lval7 = load i32, i32* %elemPtr6, align 4
  %mul8 = mul i32 %load_lval7, 5
  %add = add i32 %mul, %mul8
  store i32 %add, i32* %elemPtr, align 4
  %load_lval9 = load i32, i32* %i, align 4
  %add10 = add i32 %load_lval9, 1
  store i32 %add10, i32* %i, align 4
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
  store i32 2, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 0, i32 2
  store i32 3, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 0
  store i32 4, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 1
  store i32 5, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 2
  store i32 6, i32* %elemPtr5, align 4
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

cur:                                              ; preds = %for.cond
  %i40 = alloca i32, align 4
  store i32 0, i32* %i40, align 4
  br label %for.cond39

for.stmt:                                         ; preds = %for.cond
  %j = alloca i32, align 4
  store i32 1, i32* %j, align 4
  br label %for.cond12

for.cond:                                         ; preds = %cur10, %mainEntry
  %load_lval9 = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval9, 2
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %for.stmt, label %cur

cur10:                                            ; preds = %for.cond12
  %load_lval35 = load i32, i32* %i, align 4
  %add36 = add i32 %load_lval35, 1
  store i32 %add36, i32* %i, align 4
  br label %for.cond

for.stmt11:                                       ; preds = %for.cond12
  %load_lval17 = load i32, i32* %i, align 4
  %load_lval18 = load i32, i32* %j, align 4
  %elemPtr19 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 %load_lval17, i32 %load_lval18
  %load_lval20 = load i32, i32* %i, align 4
  %load_lval21 = load i32, i32* %j, align 4
  %sub = sub i32 %load_lval21, 1
  %elemPtr22 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 %load_lval20, i32 %sub
  %load_lval23 = load i32, i32* %elemPtr22, align 4
  %load_lval24 = load i32, i32* %i, align 4
  %load_lval25 = load i32, i32* %j, align 4
  %elemPtr26 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 %load_lval24, i32 %load_lval25
  %load_lval27 = load i32, i32* %elemPtr26, align 4
  %add = add i32 %load_lval23, %load_lval27
  %elemPtr28 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 1, i32 2
  %load_lval29 = load i32, i32* %elemPtr28, align 4
  %add30 = add i32 %add, %load_lval29
  store i32 %add30, i32* %elemPtr19, align 4
  %load_lval31 = load i32, i32* %i, align 4
  %elemPtr32 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 %load_lval31
  call void @f([3 x i32]* %elemPtr32)
  %load_lval33 = load i32, i32* %j, align 4
  %add34 = add i32 %load_lval33, 1
  store i32 %add34, i32* %j, align 4
  br label %for.cond12

for.cond12:                                       ; preds = %for.stmt11, %for.stmt
  %load_lval13 = load i32, i32* %j, align 4
  %cmp14 = icmp slt i32 %load_lval13, 3
  %zext_to_i3215 = zext i1 %cmp14 to i32
  %to_bool16 = icmp ne i32 %zext_to_i3215, 0
  br i1 %to_bool16, label %for.stmt11, label %cur10

cur37:                                            ; preds = %for.cond39
  %load_lval63 = load i32, i32* %sum, align 4
  ret i32 %load_lval63

for.stmt38:                                       ; preds = %for.cond39
  %j48 = alloca i32, align 4
  store i32 0, i32* %j48, align 4
  br label %for.cond47

for.cond39:                                       ; preds = %cur45, %cur
  %load_lval41 = load i32, i32* %i40, align 4
  %cmp42 = icmp slt i32 %load_lval41, 2
  %zext_to_i3243 = zext i1 %cmp42 to i32
  %to_bool44 = icmp ne i32 %zext_to_i3243, 0
  br i1 %to_bool44, label %for.stmt38, label %cur37

cur45:                                            ; preds = %for.cond47
  %load_lval61 = load i32, i32* %i40, align 4
  %add62 = add i32 %load_lval61, 1
  store i32 %add62, i32* %i40, align 4
  br label %for.cond39

for.stmt46:                                       ; preds = %for.cond47
  %load_lval53 = load i32, i32* %sum, align 4
  %load_lval54 = load i32, i32* %i40, align 4
  %load_lval55 = load i32, i32* %j48, align 4
  %elemPtr56 = getelementptr [2 x [3 x i32]], [2 x [3 x i32]]* %matrixGrid, i32 0, i32 %load_lval54, i32 %load_lval55
  %load_lval57 = load i32, i32* %elemPtr56, align 4
  %add58 = add i32 %load_lval53, %load_lval57
  store i32 %add58, i32* %sum, align 4
  %load_lval59 = load i32, i32* %j48, align 4
  %add60 = add i32 %load_lval59, 1
  store i32 %add60, i32* %j48, align 4
  br label %for.cond47

for.cond47:                                       ; preds = %for.stmt46, %for.stmt38
  %load_lval49 = load i32, i32* %j48, align 4
  %cmp50 = icmp slt i32 %load_lval49, 3
  %zext_to_i3251 = zext i1 %cmp50 to i32
  %to_bool52 = icmp ne i32 %zext_to_i3251, 0
  br i1 %to_bool52, label %for.stmt46, label %cur45
}
