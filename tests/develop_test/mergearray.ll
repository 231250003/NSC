; ModuleID = 'my_module'
source_filename = "my_module"

@sort_arr = global [5 x i32] zeroinitializer

define i32 @combine([2 x i32]* %arr1, i32 %arr1_length, [3 x i32]* %arr2, i32 %arr2_length) {
combineEntry:
  %param1_addr = alloca i32, align 4
  store i32 %arr1_length, i32* %param1_addr, align 4
  %param3_addr = alloca i32, align 4
  store i32 %arr2_length, i32* %param3_addr, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %j, align 4
  %k = alloca i32, align 4
  store i32 0, i32* %k, align 4
  br label %while.cond

cur:                                              ; preds = %and.merge
  %load_lval31 = load i32, i32* %i, align 4
  %load_lval32 = load i32, i32* %param1_addr, align 4
  %cmp33 = icmp eq i32 %load_lval31, %load_lval32
  %zext_to_i3234 = zext i1 %cmp33 to i32
  %to_bool37 = icmp ne i32 %zext_to_i3234, 0
  br i1 %to_bool37, label %if.then35, label %if.else36

while.stmt:                                       ; preds = %and.merge
  %load_lval7 = load i32, i32* %i, align 4
  %elemPtr = getelementptr [2 x i32], [2 x i32]* %arr1, i32 0, i32 %load_lval7
  %load_lval8 = load i32, i32* %elemPtr, align 4
  %load_lval9 = load i32, i32* %j, align 4
  %elemPtr10 = getelementptr [3 x i32], [3 x i32]* %arr2, i32 0, i32 %load_lval9
  %load_lval11 = load i32, i32* %elemPtr10, align 4
  %cmp12 = icmp slt i32 %load_lval8, %load_lval11
  %zext_to_i3213 = zext i1 %cmp12 to i32
  %to_bool14 = icmp ne i32 %zext_to_i3213, 0
  br i1 %to_bool14, label %if.then, label %if.else

while.cond:                                       ; preds = %merge, %combineEntry
  %load_lval = load i32, i32* %i, align 4
  %load_lval1 = load i32, i32* %param1_addr, align 4
  %cmp = icmp slt i32 %load_lval, %load_lval1
  %zext_to_i32 = zext i1 %cmp to i32
  %lhs_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %lhs_bool, label %and.rhs, label %and.merge

and.rhs:                                          ; preds = %while.cond
  %load_lval2 = load i32, i32* %j, align 4
  %load_lval3 = load i32, i32* %param3_addr, align 4
  %cmp4 = icmp slt i32 %load_lval2, %load_lval3
  %zext_to_i325 = zext i1 %cmp4 to i32
  %rhs_bool = icmp ne i32 %zext_to_i325, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %while.cond
  %and_result = phi i1 [ false, %while.cond ], [ %rhs_bool, %and.rhs ]
  %zext_to_i326 = zext i1 %and_result to i32
  %to_bool = icmp ne i32 %zext_to_i326, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %if.else, %if.then
  %load_lval28 = load i32, i32* %k, align 4
  %add29 = add i32 %load_lval28, 1
  store i32 %add29, i32* %k, align 4
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  %load_lval15 = load i32, i32* %k, align 4
  %elemPtr16 = getelementptr [5 x i32], [5 x i32]* @sort_arr, i32 0, i32 %load_lval15
  %load_lval17 = load i32, i32* %i, align 4
  %elemPtr18 = getelementptr [2 x i32], [2 x i32]* %arr1, i32 0, i32 %load_lval17
  %load_lval19 = load i32, i32* %elemPtr18, align 4
  store i32 %load_lval19, i32* %elemPtr16, align 4
  %load_lval20 = load i32, i32* %i, align 4
  %add = add i32 %load_lval20, 1
  store i32 %add, i32* %i, align 4
  br label %merge

if.else:                                          ; preds = %while.stmt
  %load_lval21 = load i32, i32* %k, align 4
  %elemPtr22 = getelementptr [5 x i32], [5 x i32]* @sort_arr, i32 0, i32 %load_lval21
  %load_lval23 = load i32, i32* %j, align 4
  %elemPtr24 = getelementptr [3 x i32], [3 x i32]* %arr2, i32 0, i32 %load_lval23
  %load_lval25 = load i32, i32* %elemPtr24, align 4
  store i32 %load_lval25, i32* %elemPtr22, align 4
  %load_lval26 = load i32, i32* %j, align 4
  %add27 = add i32 %load_lval26, 1
  store i32 %add27, i32* %j, align 4
  br label %merge

merge30:                                          ; preds = %cur55, %cur38
  %load_lval72 = load i32, i32* %param1_addr, align 4
  %load_lval73 = load i32, i32* %param3_addr, align 4
  %add74 = add i32 %load_lval72, %load_lval73
  %sub = sub i32 %add74, 1
  %elemPtr75 = getelementptr [5 x i32], [5 x i32]* @sort_arr, i32 0, i32 %sub
  %load_lval76 = load i32, i32* %elemPtr75, align 4
  ret i32 %load_lval76

if.then35:                                        ; preds = %cur
  br label %while.cond40

if.else36:                                        ; preds = %cur
  br label %while.cond57

cur38:                                            ; preds = %while.cond40
  br label %merge30

while.stmt39:                                     ; preds = %while.cond40
  %load_lval46 = load i32, i32* %k, align 4
  %elemPtr47 = getelementptr [5 x i32], [5 x i32]* @sort_arr, i32 0, i32 %load_lval46
  %load_lval48 = load i32, i32* %j, align 4
  %elemPtr49 = getelementptr [3 x i32], [3 x i32]* %arr2, i32 0, i32 %load_lval48
  %load_lval50 = load i32, i32* %elemPtr49, align 4
  store i32 %load_lval50, i32* %elemPtr47, align 4
  %load_lval51 = load i32, i32* %k, align 4
  %add52 = add i32 %load_lval51, 1
  store i32 %add52, i32* %k, align 4
  %load_lval53 = load i32, i32* %j, align 4
  %add54 = add i32 %load_lval53, 1
  store i32 %add54, i32* %j, align 4
  br label %while.cond40

while.cond40:                                     ; preds = %while.stmt39, %if.then35
  %load_lval41 = load i32, i32* %j, align 4
  %load_lval42 = load i32, i32* %param3_addr, align 4
  %cmp43 = icmp slt i32 %load_lval41, %load_lval42
  %zext_to_i3244 = zext i1 %cmp43 to i32
  %to_bool45 = icmp ne i32 %zext_to_i3244, 0
  br i1 %to_bool45, label %while.stmt39, label %cur38

cur55:                                            ; preds = %while.cond57
  br label %merge30

while.stmt56:                                     ; preds = %while.cond57
  %load_lval63 = load i32, i32* %k, align 4
  %elemPtr64 = getelementptr [5 x i32], [5 x i32]* @sort_arr, i32 0, i32 %load_lval63
  %load_lval65 = load i32, i32* %i, align 4
  %elemPtr66 = getelementptr [3 x i32], [3 x i32]* %arr2, i32 0, i32 %load_lval65
  %load_lval67 = load i32, i32* %elemPtr66, align 4
  store i32 %load_lval67, i32* %elemPtr64, align 4
  %load_lval68 = load i32, i32* %k, align 4
  %add69 = add i32 %load_lval68, 1
  store i32 %add69, i32* %k, align 4
  %load_lval70 = load i32, i32* %i, align 4
  %add71 = add i32 %load_lval70, 1
  store i32 %add71, i32* %i, align 4
  br label %while.cond57

while.cond57:                                     ; preds = %while.stmt56, %if.else36
  %load_lval58 = load i32, i32* %i, align 4
  %load_lval59 = load i32, i32* %param1_addr, align 4
  %cmp60 = icmp slt i32 %load_lval58, %load_lval59
  %zext_to_i3261 = zext i1 %cmp60 to i32
  %to_bool62 = icmp ne i32 %zext_to_i3261, 0
  br i1 %to_bool62, label %while.stmt56, label %cur55
}

define i32 @main() {
mainEntry:
  %a = alloca [2 x i32], align 4
  %elemPtr = getelementptr [2 x i32], [2 x i32]* %a, i32 0, i32 0
  store i32 1, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [2 x i32], [2 x i32]* %a, i32 0, i32 1
  store i32 5, i32* %elemPtr1, align 4
  %b = alloca [3 x [3 x i32]], align 4
  %elemPtr2 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %b, i32 0, i32 0, i32 0
  store i32 1, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %b, i32 0, i32 0, i32 1
  store i32 4, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %b, i32 0, i32 0, i32 2
  store i32 14, i32* %elemPtr4, align 4
  %elemPtr5 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %b, i32 0, i32 1, i32 0
  store i32 1, i32* %elemPtr5, align 4
  %elemPtr6 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %b, i32 0, i32 1, i32 1
  store i32 4, i32* %elemPtr6, align 4
  %elemPtr7 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %b, i32 0, i32 1, i32 2
  store i32 14, i32* %elemPtr7, align 4
  %elemPtr8 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %b, i32 0, i32 2, i32 0
  store i32 1, i32* %elemPtr8, align 4
  %elemPtr9 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %b, i32 0, i32 2, i32 1
  store i32 4, i32* %elemPtr9, align 4
  %elemPtr10 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %b, i32 0, i32 2, i32 2
  store i32 14, i32* %elemPtr10, align 4
  %elemPtr11 = getelementptr [2 x i32], [2 x i32]* %a, i32 0
  %elemPtr12 = getelementptr [3 x [3 x i32]], [3 x [3 x i32]]* %b, i32 0, i32 1
  %combine = call i32 @combine([2 x i32]* %elemPtr11, i32 2, [3 x i32]* %elemPtr12, i32 3)
  ret i32 %combine
}
