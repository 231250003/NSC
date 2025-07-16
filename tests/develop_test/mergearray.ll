; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @combine([2 x i32]* %arr1, i32 %arr1_length, [3 x i32]* %arr2, i32 %arr2_length) {
combineEntry:
  %param1_addr = alloca i32, align 4
  store i32 %arr1_length, i32* %param1_addr, align 4
  %param3_addr = alloca i32, align 4
  store i32 %arr2_length, i32* %param3_addr, align 4
  %sort_arr = alloca [5 x i32], align 4
  %elemPtr = getelementptr [5 x i32], [5 x i32]* %sort_arr, i32 0, i32 0
  store i32 0, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [5 x i32], [5 x i32]* %sort_arr, i32 0, i32 1
  store i32 0, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [5 x i32], [5 x i32]* %sort_arr, i32 0, i32 2
  store i32 0, i32* %elemPtr2, align 4
  %elemPtr3 = getelementptr [5 x i32], [5 x i32]* %sort_arr, i32 0, i32 3
  store i32 0, i32* %elemPtr3, align 4
  %elemPtr4 = getelementptr [5 x i32], [5 x i32]* %sort_arr, i32 0, i32 4
  store i32 0, i32* %elemPtr4, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %j, align 4
  %k = alloca i32, align 4
  store i32 0, i32* %k, align 4
  br label %while.cond

cur:                                              ; preds = %and.merge
  %load_lval36 = load i32, i32* %i, align 4
  %load_lval37 = load i32, i32* %param1_addr, align 4
  %cmp38 = icmp eq i32 %load_lval36, %load_lval37
  %zext_to_i3239 = zext i1 %cmp38 to i32
  %to_bool42 = icmp ne i32 %zext_to_i3239, 0
  br i1 %to_bool42, label %if.then40, label %if.else41

while.stmt:                                       ; preds = %and.merge
  %load_lval11 = load i32, i32* %i, align 4
  %elemPtr12 = getelementptr [2 x i32], [2 x i32]* %arr1, i32 0, i32 %load_lval11
  %load_lval13 = load i32, i32* %elemPtr12, align 4
  %load_lval14 = load i32, i32* %j, align 4
  %elemPtr15 = getelementptr [3 x i32], [3 x i32]* %arr2, i32 0, i32 %load_lval14
  %load_lval16 = load i32, i32* %elemPtr15, align 4
  %cmp17 = icmp slt i32 %load_lval13, %load_lval16
  %zext_to_i3218 = zext i1 %cmp17 to i32
  %to_bool19 = icmp ne i32 %zext_to_i3218, 0
  br i1 %to_bool19, label %if.then, label %if.else

while.cond:                                       ; preds = %merge, %combineEntry
  %load_lval = load i32, i32* %i, align 4
  %load_lval5 = load i32, i32* %param1_addr, align 4
  %cmp = icmp slt i32 %load_lval, %load_lval5
  %zext_to_i32 = zext i1 %cmp to i32
  %lhs_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %lhs_bool, label %and.rhs, label %and.merge

and.rhs:                                          ; preds = %while.cond
  %load_lval6 = load i32, i32* %j, align 4
  %load_lval7 = load i32, i32* %param3_addr, align 4
  %cmp8 = icmp slt i32 %load_lval6, %load_lval7
  %zext_to_i329 = zext i1 %cmp8 to i32
  %rhs_bool = icmp ne i32 %zext_to_i329, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %while.cond
  %phi_repl = phi i1 [ false, %while.cond ], [ %rhs_bool, %and.rhs ]
  %zext_to_i3210 = zext i1 %phi_repl to i32
  %to_bool = icmp ne i32 %zext_to_i3210, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %if.else, %if.then
  %load_lval33 = load i32, i32* %k, align 4
  %add34 = add i32 %load_lval33, 1
  store i32 %add34, i32* %k, align 4
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  %load_lval20 = load i32, i32* %k, align 4
  %elemPtr21 = getelementptr [5 x i32], [5 x i32]* %sort_arr, i32 0, i32 %load_lval20
  %load_lval22 = load i32, i32* %i, align 4
  %elemPtr23 = getelementptr [2 x i32], [2 x i32]* %arr1, i32 0, i32 %load_lval22
  %load_lval24 = load i32, i32* %elemPtr23, align 4
  store i32 %load_lval24, i32* %elemPtr21, align 4
  %load_lval25 = load i32, i32* %i, align 4
  %add = add i32 %load_lval25, 1
  store i32 %add, i32* %i, align 4
  br label %merge

if.else:                                          ; preds = %while.stmt
  %load_lval26 = load i32, i32* %k, align 4
  %elemPtr27 = getelementptr [5 x i32], [5 x i32]* %sort_arr, i32 0, i32 %load_lval26
  %load_lval28 = load i32, i32* %j, align 4
  %elemPtr29 = getelementptr [3 x i32], [3 x i32]* %arr2, i32 0, i32 %load_lval28
  %load_lval30 = load i32, i32* %elemPtr29, align 4
  store i32 %load_lval30, i32* %elemPtr27, align 4
  %load_lval31 = load i32, i32* %j, align 4
  %add32 = add i32 %load_lval31, 1
  store i32 %add32, i32* %j, align 4
  br label %merge

merge35:                                          ; preds = %cur60, %cur43
  %load_lval77 = load i32, i32* %param1_addr, align 4
  %load_lval78 = load i32, i32* %param3_addr, align 4
  %add79 = add i32 %load_lval77, %load_lval78
  %sub = sub i32 %add79, 1
  %elemPtr80 = getelementptr [5 x i32], [5 x i32]* %sort_arr, i32 0, i32 %sub
  %load_lval81 = load i32, i32* %elemPtr80, align 4
  ret i32 %load_lval81

if.then40:                                        ; preds = %cur
  br label %while.cond45

if.else41:                                        ; preds = %cur
  br label %while.cond62

cur43:                                            ; preds = %while.cond45
  br label %merge35

while.stmt44:                                     ; preds = %while.cond45
  %load_lval51 = load i32, i32* %k, align 4
  %elemPtr52 = getelementptr [5 x i32], [5 x i32]* %sort_arr, i32 0, i32 %load_lval51
  %load_lval53 = load i32, i32* %j, align 4
  %elemPtr54 = getelementptr [3 x i32], [3 x i32]* %arr2, i32 0, i32 %load_lval53
  %load_lval55 = load i32, i32* %elemPtr54, align 4
  store i32 %load_lval55, i32* %elemPtr52, align 4
  %load_lval56 = load i32, i32* %k, align 4
  %add57 = add i32 %load_lval56, 1
  store i32 %add57, i32* %k, align 4
  %load_lval58 = load i32, i32* %j, align 4
  %add59 = add i32 %load_lval58, 1
  store i32 %add59, i32* %j, align 4
  br label %while.cond45

while.cond45:                                     ; preds = %while.stmt44, %if.then40
  %load_lval46 = load i32, i32* %j, align 4
  %load_lval47 = load i32, i32* %param3_addr, align 4
  %cmp48 = icmp slt i32 %load_lval46, %load_lval47
  %zext_to_i3249 = zext i1 %cmp48 to i32
  %to_bool50 = icmp ne i32 %zext_to_i3249, 0
  br i1 %to_bool50, label %while.stmt44, label %cur43

cur60:                                            ; preds = %while.cond62
  br label %merge35

while.stmt61:                                     ; preds = %while.cond62
  %load_lval68 = load i32, i32* %k, align 4
  %elemPtr69 = getelementptr [5 x i32], [5 x i32]* %sort_arr, i32 0, i32 %load_lval68
  %load_lval70 = load i32, i32* %i, align 4
  %elemPtr71 = getelementptr [3 x i32], [3 x i32]* %arr2, i32 0, i32 %load_lval70
  %load_lval72 = load i32, i32* %elemPtr71, align 4
  store i32 %load_lval72, i32* %elemPtr69, align 4
  %load_lval73 = load i32, i32* %k, align 4
  %add74 = add i32 %load_lval73, 1
  store i32 %add74, i32* %k, align 4
  %load_lval75 = load i32, i32* %i, align 4
  %add76 = add i32 %load_lval75, 1
  store i32 %add76, i32* %i, align 4
  br label %while.cond62

while.cond62:                                     ; preds = %while.stmt61, %if.else41
  %load_lval63 = load i32, i32* %i, align 4
  %load_lval64 = load i32, i32* %param1_addr, align 4
  %cmp65 = icmp slt i32 %load_lval63, %load_lval64
  %zext_to_i3266 = zext i1 %cmp65 to i32
  %to_bool67 = icmp ne i32 %zext_to_i3266, 0
  br i1 %to_bool67, label %while.stmt61, label %cur60
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
