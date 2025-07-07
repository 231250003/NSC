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
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

cur:                                              ; preds = %for.cond
  ret i32 0

for.stmt:                                         ; preds = %for.cond
  %j = alloca i32, align 4
  store i32 0, i32* %j, align 4
  br label %for.cond11

for.cond:                                         ; preds = %cur9, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 3
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %for.stmt, label %cur

cur9:                                             ; preds = %for.cond11
  %load_lval52 = load i32, i32* %i, align 4
  %add53 = add i32 %load_lval52, 1
  store i32 %add53, i32* %i, align 4
  br label %for.cond

for.stmt10:                                       ; preds = %for.cond11
  %load_lval16 = load i32, i32* %i, align 4
  %load_lval17 = load i32, i32* %j, align 4
  %cmp18 = icmp eq i32 %load_lval16, %load_lval17
  %zext_to_i3219 = zext i1 %cmp18 to i32
  %to_bool20 = icmp ne i32 %zext_to_i3219, 0
  br i1 %to_bool20, label %if.then, label %merge

for.cond11:                                       ; preds = %cur21, %if.then, %for.stmt
  %load_lval12 = load i32, i32* %j, align 4
  %cmp13 = icmp slt i32 %load_lval12, 3
  %zext_to_i3214 = zext i1 %cmp13 to i32
  %to_bool15 = icmp ne i32 %zext_to_i3214, 0
  br i1 %to_bool15, label %for.stmt10, label %cur9

merge:                                            ; preds = %for.stmt10
  %k = alloca i32, align 4
  store i32 0, i32* %k, align 4
  br label %for.cond23

if.then:                                          ; preds = %for.stmt10
  br label %for.cond11

cur21:                                            ; preds = %if.then46, %for.cond23
  %load_lval50 = load i32, i32* %j, align 4
  %add51 = add i32 %load_lval50, 1
  store i32 %add51, i32* %j, align 4
  br label %for.cond11

for.stmt22:                                       ; preds = %for.cond23
  %load_lval28 = load i32, i32* %i, align 4
  %load_lval29 = load i32, i32* %j, align 4
  %elemPtr30 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 %load_lval28, i32 %load_lval29
  %load_lval31 = load i32, i32* %i, align 4
  %load_lval32 = load i32, i32* %j, align 4
  %elemPtr33 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 %load_lval31, i32 %load_lval32
  %load_lval34 = load i32, i32* %elemPtr33, align 4
  %load_lval35 = load i32, i32* %j, align 4
  %load_lval36 = load i32, i32* %k, align 4
  %elemPtr37 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 %load_lval35, i32 %load_lval36
  %load_lval38 = load i32, i32* %elemPtr37, align 4
  %add = add i32 %load_lval34, %load_lval38
  store i32 %add, i32* %elemPtr30, align 4
  %load_lval40 = load i32, i32* %i, align 4
  %load_lval41 = load i32, i32* %j, align 4
  %elemPtr42 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %arr, i32 0, i32 %load_lval40, i32 %load_lval41
  %load_lval43 = load i32, i32* %elemPtr42, align 4
  %cmp44 = icmp sgt i32 %load_lval43, 20
  %zext_to_i3245 = zext i1 %cmp44 to i32
  %to_bool47 = icmp ne i32 %zext_to_i3245, 0
  br i1 %to_bool47, label %if.then46, label %merge39

for.cond23:                                       ; preds = %merge39, %merge
  %load_lval24 = load i32, i32* %k, align 4
  %cmp25 = icmp slt i32 %load_lval24, 3
  %zext_to_i3226 = zext i1 %cmp25 to i32
  %to_bool27 = icmp ne i32 %zext_to_i3226, 0
  br i1 %to_bool27, label %for.stmt22, label %cur21

merge39:                                          ; preds = %for.stmt22
  %load_lval48 = load i32, i32* %k, align 4
  %add49 = add i32 %load_lval48, 1
  store i32 %add49, i32* %k, align 4
  br label %for.cond23

if.then46:                                        ; preds = %for.stmt22
  br label %cur21
}
