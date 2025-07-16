; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %arr = alloca [3 x [3 x i32]], align 4
  %elemPtr = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 0, i32 0
  store i32 1, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 0, i32 1
  store i32 2, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 0, i32 2
  store i32 3, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 1, i32 0
  store i32 4, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 1, i32 1
  store i32 5, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 1, i32 2
  store i32 6, i32* %elemPtr5, align 4
  %elemPtr6 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 2, i32 0
  store i32 7, i32* %elemPtr6, align 4
  %elemPtr7 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 2, i32 1
  store i32 8, i32* %elemPtr7, align 4
  %elemPtr8 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 2, i32 2
  store i32 9, i32* %elemPtr8, align 4
  %i9 = alloca i32, align 4
  store i32 0, i32* %i9, align 4
  br label %for.cond

cur:                                              ; preds = %for.cond
  %elemPtr59 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 2, i32 2
  %load_lval60 = load i32, i32* %elemPtr59, align 4
  ret i32 %load_lval60

for.stmt:                                         ; preds = %for.cond
  %j13 = alloca i32, align 4
  store i32 0, i32* %j13, align 4
  br label %for.cond12

for.cond:                                         ; preds = %cur10, %mainEntry
  %load_lval = load i32, i32* %i9, align 4
  %cmp = icmp slt i32 %load_lval, 3
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %for.stmt, label %cur

cur10:                                            ; preds = %for.cond12
  %load_lval57 = load i32, i32* %i9, align 4
  %add58 = add i32 %load_lval57, 1
  store i32 %add58, i32* %i9, align 4
  br label %for.cond

for.stmt11:                                       ; preds = %for.cond12
  %load_lval18 = load i32, i32* %i9, align 4
  %load_lval19 = load i32, i32* %j13, align 4
  %cmp20 = icmp eq i32 %load_lval18, %load_lval19
  %zext_to_i3221 = zext i1 %cmp20 to i32
  %to_bool22 = icmp ne i32 %zext_to_i3221, 0
  br i1 %to_bool22, label %if.then, label %merge

for.cond12:                                       ; preds = %cur24, %if.then, %for.stmt
  %load_lval14 = load i32, i32* %j13, align 4
  %cmp15 = icmp slt i32 %load_lval14, 3
  %zext_to_i3216 = zext i1 %cmp15 to i32
  %to_bool17 = icmp ne i32 %zext_to_i3216, 0
  br i1 %to_bool17, label %for.stmt11, label %cur10

merge:                                            ; preds = %for.stmt11
  %k27 = alloca i32, align 4
  store i32 0, i32* %k27, align 4
  br label %for.cond26

if.then:                                          ; preds = %for.stmt11
  %load_lval23 = load i32, i32* %j13, align 4
  %add = add i32 %load_lval23, 1
  store i32 %add, i32* %j13, align 4
  br label %for.cond12

cur24:                                            ; preds = %for.stmt25, %for.cond26
  %load_lval55 = load i32, i32* %j13, align 4
  %add56 = add i32 %load_lval55, 1
  store i32 %add56, i32* %j13, align 4
  br label %for.cond12

for.stmt25:                                       ; preds = %for.cond26
  %load_lval32 = load i32, i32* %i9, align 4
  %load_lval33 = load i32, i32* %j13, align 4
  %elemPtr34 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 %load_lval32, i32 %load_lval33
  %load_lval35 = load i32, i32* %i9, align 4
  %load_lval36 = load i32, i32* %j13, align 4
  %elemPtr37 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 %load_lval35, i32 %load_lval36
  %load_lval38 = load i32, i32* %elemPtr37, align 4
  %load_lval39 = load i32, i32* %j13, align 4
  %load_lval40 = load i32, i32* %k27, align 4
  %elemPtr41 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 %load_lval39, i32 %load_lval40
  %load_lval42 = load i32, i32* %elemPtr41, align 4
  %add43 = add i32 %load_lval38, %load_lval42
  store i32 %add43, i32* %elemPtr34, align 4
  %load_lval45 = load i32, i32* %i9, align 4
  %load_lval46 = load i32, i32* %j13, align 4
  %elemPtr47 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 %load_lval45, i32 %load_lval46
  %load_lval48 = load i32, i32* %elemPtr47, align 4
  %cmp49 = icmp sgt i32 %load_lval48, 20
  %zext_to_i3250 = zext i1 %cmp49 to i32
  %to_bool52 = icmp ne i32 %zext_to_i3250, 0
  br i1 %to_bool52, label %cur24, label %merge44

for.cond26:                                       ; preds = %merge44, %merge
  %load_lval28 = load i32, i32* %k27, align 4
  %cmp29 = icmp slt i32 %load_lval28, 3
  %zext_to_i3230 = zext i1 %cmp29 to i32
  %to_bool31 = icmp ne i32 %zext_to_i3230, 0
  br i1 %to_bool31, label %for.stmt25, label %cur24

merge44:                                          ; preds = %for.stmt25
  %load_lval53 = load i32, i32* %k27, align 4
  %add54 = add i32 %load_lval53, 1
  store i32 %add54, i32* %k27, align 4
  br label %for.cond26
}
