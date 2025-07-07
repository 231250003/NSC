; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 64, i32* %i, align 4
  %j = alloca i32, align 4
  store i32 64, i32* %j, align 4
  %k = alloca i32, align 4
  store i32 64, i32* %k, align 4
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
  ret i32 0

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
  %load_lval55 = load i32, i32* %i9, align 4
  %add56 = add i32 %load_lval55, 1
  store i32 %add56, i32* %i9, align 4
  br label %for.cond

for.stmt11:                                       ; preds = %for.cond12
  %load_lval18 = load i32, i32* %i9, align 4
  %load_lval19 = load i32, i32* %j13, align 4
  %cmp20 = icmp eq i32 %load_lval18, %load_lval19
  %zext_to_i3221 = zext i1 %cmp20 to i32
  %to_bool22 = icmp ne i32 %zext_to_i3221, 0
  br i1 %to_bool22, label %if.then, label %merge

for.cond12:                                       ; preds = %cur23, %if.then, %for.stmt
  %load_lval14 = load i32, i32* %j13, align 4
  %cmp15 = icmp slt i32 %load_lval14, 3
  %zext_to_i3216 = zext i1 %cmp15 to i32
  %to_bool17 = icmp ne i32 %zext_to_i3216, 0
  br i1 %to_bool17, label %for.stmt11, label %cur10

merge:                                            ; preds = %for.stmt11
  %k26 = alloca i32, align 4
  store i32 0, i32* %k26, align 4
  br label %for.cond25

if.then:                                          ; preds = %for.stmt11
  br label %for.cond12

cur23:                                            ; preds = %if.then49, %for.cond25
  %load_lval53 = load i32, i32* %j13, align 4
  %add54 = add i32 %load_lval53, 1
  store i32 %add54, i32* %j13, align 4
  br label %for.cond12

for.stmt24:                                       ; preds = %for.cond25
  %load_lval31 = load i32, i32* %i9, align 4
  %load_lval32 = load i32, i32* %j13, align 4
  %elemPtr33 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 %load_lval31, i32 %load_lval32
  %load_lval34 = load i32, i32* %i9, align 4
  %load_lval35 = load i32, i32* %j13, align 4
  %elemPtr36 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 %load_lval34, i32 %load_lval35
  %load_lval37 = load i32, i32* %elemPtr36, align 4
  %load_lval38 = load i32, i32* %j13, align 4
  %load_lval39 = load i32, i32* %k26, align 4
  %elemPtr40 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 %load_lval38, i32 %load_lval39
  %load_lval41 = load i32, i32* %elemPtr40, align 4
  %add = add i32 %load_lval37, %load_lval41
  store i32 %add, i32* %elemPtr33, align 4
  %load_lval43 = load i32, i32* %i9, align 4
  %load_lval44 = load i32, i32* %j13, align 4
  %elemPtr45 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 %load_lval43, i32 %load_lval44
  %load_lval46 = load i32, i32* %elemPtr45, align 4
  %cmp47 = icmp sgt i32 %load_lval46, 20
  %zext_to_i3248 = zext i1 %cmp47 to i32
  %to_bool50 = icmp ne i32 %zext_to_i3248, 0
  br i1 %to_bool50, label %if.then49, label %merge42

for.cond25:                                       ; preds = %merge42, %merge
  %load_lval27 = load i32, i32* %k26, align 4
  %cmp28 = icmp slt i32 %load_lval27, 3
  %zext_to_i3229 = zext i1 %cmp28 to i32
  %to_bool30 = icmp ne i32 %zext_to_i3229, 0
  br i1 %to_bool30, label %for.stmt24, label %cur23

merge42:                                          ; preds = %for.stmt24
  %load_lval51 = load i32, i32* %k26, align 4
  %add52 = add i32 %load_lval51, 1
  store i32 %add52, i32* %k26, align 4
  br label %for.cond25

if.then49:                                        ; preds = %for.stmt24
  br label %cur23
}
