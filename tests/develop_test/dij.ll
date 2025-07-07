; ModuleID = 'my_module'
source_filename = "my_module"

@e = global [15 x [15 x i32]] zeroinitializer
@dis = global [15 x i32] zeroinitializer
@book = global [15 x i32] zeroinitializer

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %for.cond

cur:                                              ; preds = %for.cond
  %n = alloca i32, align 4
  store i32 6, i32* %n, align 4
  %m = alloca i32, align 4
  store i32 9, i32* %m, align 4
  %a = alloca i32, align 4
  store i32 64, i32* %a, align 4
  %b = alloca i32, align 4
  store i32 64, i32* %b, align 4
  %c = alloca i32, align 4
  store i32 64, i32* %c, align 4
  %i6 = alloca i32, align 4
  store i32 1, i32* %i6, align 4
  br label %for.cond5

for.stmt:                                         ; preds = %for.cond
  %load_lval1 = load i32, i32* %i, align 4
  %elemPtr = getelementptr [15 x i32], [15 x i32]* @book, i32 0, i32 %load_lval1
  store i32 0, i32* %elemPtr, align 4
  %load_lval2 = load i32, i32* %i, align 4
  %add = add i32 %load_lval2, 1
  store i32 %add, i32* %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 14
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %for.stmt, label %cur

cur3:                                             ; preds = %for.cond5
  store i32 1, i32* getelementptr inbounds ([15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 1, i32 2), align 4
  store i32 12, i32* getelementptr inbounds ([15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 1, i32 3), align 4
  store i32 9, i32* getelementptr inbounds ([15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 2, i32 3), align 4
  store i32 3, i32* getelementptr inbounds ([15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 2, i32 4), align 4
  store i32 5, i32* getelementptr inbounds ([15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 3, i32 5), align 4
  store i32 4, i32* getelementptr inbounds ([15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 4, i32 3), align 4
  store i32 13, i32* getelementptr inbounds ([15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 4, i32 5), align 4
  store i32 15, i32* getelementptr inbounds ([15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 4, i32 6), align 4
  store i32 4, i32* getelementptr inbounds ([15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 5, i32 6), align 4
  %i38 = alloca i32, align 4
  store i32 1, i32* %i38, align 4
  br label %for.cond37

for.stmt4:                                        ; preds = %for.cond5
  %j = alloca i32, align 4
  store i32 1, i32* %j, align 4
  br label %for.cond14

for.cond5:                                        ; preds = %cur12, %cur
  %load_lval7 = load i32, i32* %i6, align 4
  %load_lval8 = load i32, i32* %n, align 4
  %cmp9 = icmp sle i32 %load_lval7, %load_lval8
  %zext_to_i3210 = zext i1 %cmp9 to i32
  %to_bool11 = icmp ne i32 %zext_to_i3210, 0
  br i1 %to_bool11, label %for.stmt4, label %cur3

cur12:                                            ; preds = %for.cond14
  %load_lval33 = load i32, i32* %i6, align 4
  %add34 = add i32 %load_lval33, 1
  store i32 %add34, i32* %i6, align 4
  br label %for.cond5

for.stmt13:                                       ; preds = %for.cond14
  %load_lval20 = load i32, i32* %i6, align 4
  %load_lval21 = load i32, i32* %j, align 4
  %cmp22 = icmp eq i32 %load_lval20, %load_lval21
  %zext_to_i3223 = zext i1 %cmp22 to i32
  %to_bool24 = icmp ne i32 %zext_to_i3223, 0
  br i1 %to_bool24, label %if.then, label %if.else

for.cond14:                                       ; preds = %merge, %for.stmt4
  %load_lval15 = load i32, i32* %j, align 4
  %load_lval16 = load i32, i32* %n, align 4
  %cmp17 = icmp sle i32 %load_lval15, %load_lval16
  %zext_to_i3218 = zext i1 %cmp17 to i32
  %to_bool19 = icmp ne i32 %zext_to_i3218, 0
  br i1 %to_bool19, label %for.stmt13, label %cur12

merge:                                            ; preds = %if.else, %if.then
  %load_lval31 = load i32, i32* %j, align 4
  %add32 = add i32 %load_lval31, 1
  store i32 %add32, i32* %j, align 4
  br label %for.cond14

if.then:                                          ; preds = %for.stmt13
  %load_lval25 = load i32, i32* %i6, align 4
  %load_lval26 = load i32, i32* %j, align 4
  %elemPtr27 = getelementptr [15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 %load_lval25, i32 %load_lval26
  store i32 0, i32* %elemPtr27, align 4
  br label %merge

if.else:                                          ; preds = %for.stmt13
  %load_lval28 = load i32, i32* %i6, align 4
  %load_lval29 = load i32, i32* %j, align 4
  %elemPtr30 = getelementptr [15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 %load_lval28, i32 %load_lval29
  store i32 9999, i32* %elemPtr30, align 4
  br label %merge

cur35:                                            ; preds = %for.cond37
  %t = alloca i32, align 4
  store i32 64, i32* %t, align 4
  %min = alloca i32, align 4
  store i32 99999, i32* %min, align 4
  %i54 = alloca i32, align 4
  store i32 1, i32* %i54, align 4
  br label %for.cond53

for.stmt36:                                       ; preds = %for.cond37
  %load_lval44 = load i32, i32* %i38, align 4
  %elemPtr45 = getelementptr [15 x i32], [15 x i32]* @dis, i32 0, i32 %load_lval44
  %load_lval46 = load i32, i32* %i38, align 4
  %elemPtr47 = getelementptr [15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 1, i32 %load_lval46
  %load_lval48 = load i32, i32* %elemPtr47, align 4
  store i32 %load_lval48, i32* %elemPtr45, align 4
  %load_lval49 = load i32, i32* %i38, align 4
  %add50 = add i32 %load_lval49, 1
  store i32 %add50, i32* %i38, align 4
  br label %for.cond37

for.cond37:                                       ; preds = %for.stmt36, %cur3
  %load_lval39 = load i32, i32* %i38, align 4
  %load_lval40 = load i32, i32* %n, align 4
  %cmp41 = icmp sle i32 %load_lval39, %load_lval40
  %zext_to_i3242 = zext i1 %cmp41 to i32
  %to_bool43 = icmp ne i32 %zext_to_i3242, 0
  br i1 %to_bool43, label %for.stmt36, label %cur35

cur51:                                            ; preds = %for.cond53
  %load_lval141 = load i32, i32* getelementptr inbounds ([15 x i32], [15 x i32]* @dis, i32 0, i32 2), align 4
  ret i32 %load_lval141

for.stmt52:                                       ; preds = %for.cond53
  store i32 99999, i32* %min, align 4
  %j63 = alloca i32, align 4
  store i32 1, i32* %j63, align 4
  br label %for.cond62

for.cond53:                                       ; preds = %cur92, %cur35
  %load_lval55 = load i32, i32* %i54, align 4
  %load_lval56 = load i32, i32* %n, align 4
  %cmp57 = icmp sle i32 %load_lval55, %load_lval56
  %zext_to_i3258 = zext i1 %cmp57 to i32
  %to_bool59 = icmp ne i32 %zext_to_i3258, 0
  br i1 %to_bool59, label %for.stmt52, label %cur51

cur60:                                            ; preds = %for.cond62
  %load_lval90 = load i32, i32* %t, align 4
  %elemPtr91 = getelementptr [15 x i32], [15 x i32]* @book, i32 0, i32 %load_lval90
  store i32 1, i32* %elemPtr91, align 4
  %k = alloca i32, align 4
  store i32 1, i32* %k, align 4
  br label %for.cond94

for.stmt61:                                       ; preds = %for.cond62
  %load_lval70 = load i32, i32* %j63, align 4
  %elemPtr71 = getelementptr [15 x i32], [15 x i32]* @book, i32 0, i32 %load_lval70
  %load_lval72 = load i32, i32* %elemPtr71, align 4
  %cmp73 = icmp eq i32 %load_lval72, 0
  %zext_to_i3274 = zext i1 %cmp73 to i32
  %lhs_bool = icmp ne i32 %zext_to_i3274, 0
  br i1 %lhs_bool, label %and.rhs, label %and.merge

for.cond62:                                       ; preds = %merge69, %for.stmt52
  %load_lval64 = load i32, i32* %j63, align 4
  %load_lval65 = load i32, i32* %n, align 4
  %cmp66 = icmp sle i32 %load_lval64, %load_lval65
  %zext_to_i3267 = zext i1 %cmp66 to i32
  %to_bool68 = icmp ne i32 %zext_to_i3267, 0
  br i1 %to_bool68, label %for.stmt61, label %cur60

merge69:                                          ; preds = %if.then82, %and.merge
  %load_lval88 = load i32, i32* %j63, align 4
  %add89 = add i32 %load_lval88, 1
  store i32 %add89, i32* %j63, align 4
  br label %for.cond62

and.rhs:                                          ; preds = %for.stmt61
  %load_lval75 = load i32, i32* %j63, align 4
  %elemPtr76 = getelementptr [15 x i32], [15 x i32]* @dis, i32 0, i32 %load_lval75
  %load_lval77 = load i32, i32* %elemPtr76, align 4
  %load_lval78 = load i32, i32* %min, align 4
  %cmp79 = icmp slt i32 %load_lval77, %load_lval78
  %zext_to_i3280 = zext i1 %cmp79 to i32
  %rhs_bool = icmp ne i32 %zext_to_i3280, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %for.stmt61
  %and_result = phi i1 [ false, %for.stmt61 ], [ %rhs_bool, %and.rhs ]
  %zext_to_i3281 = zext i1 %and_result to i32
  %to_bool83 = icmp ne i32 %zext_to_i3281, 0
  br i1 %to_bool83, label %if.then82, label %merge69

if.then82:                                        ; preds = %and.merge
  %load_lval84 = load i32, i32* %j63, align 4
  %elemPtr85 = getelementptr [15 x i32], [15 x i32]* @dis, i32 0, i32 %load_lval84
  %load_lval86 = load i32, i32* %elemPtr85, align 4
  store i32 %load_lval86, i32* %min, align 4
  %load_lval87 = load i32, i32* %j63, align 4
  store i32 %load_lval87, i32* %t, align 4
  br label %merge69

cur92:                                            ; preds = %for.cond94
  %load_lval139 = load i32, i32* %i54, align 4
  %add140 = add i32 %load_lval139, 1
  store i32 %add140, i32* %i54, align 4
  br label %for.cond53

for.stmt93:                                       ; preds = %for.cond94
  %load_lval101 = load i32, i32* %k, align 4
  %elemPtr102 = getelementptr [15 x i32], [15 x i32]* @book, i32 0, i32 %load_lval101
  %load_lval103 = load i32, i32* %elemPtr102, align 4
  %cmp104 = icmp eq i32 %load_lval103, 0
  %zext_to_i32105 = zext i1 %cmp104 to i32
  %lhs_bool106 = icmp ne i32 %zext_to_i32105, 0
  br i1 %lhs_bool106, label %and.rhs107, label %and.merge108

for.cond94:                                       ; preds = %merge100, %cur60
  %load_lval95 = load i32, i32* %k, align 4
  %load_lval96 = load i32, i32* %n, align 4
  %cmp97 = icmp sle i32 %load_lval95, %load_lval96
  %zext_to_i3298 = zext i1 %cmp97 to i32
  %to_bool99 = icmp ne i32 %zext_to_i3298, 0
  br i1 %to_bool99, label %for.stmt93, label %cur92

merge100:                                         ; preds = %if.then125, %and.merge108
  %load_lval137 = load i32, i32* %k, align 4
  %add138 = add i32 %load_lval137, 1
  store i32 %add138, i32* %k, align 4
  br label %for.cond94

and.rhs107:                                       ; preds = %for.stmt93
  %load_lval109 = load i32, i32* %k, align 4
  %elemPtr110 = getelementptr [15 x i32], [15 x i32]* @dis, i32 0, i32 %load_lval109
  %load_lval111 = load i32, i32* %elemPtr110, align 4
  %load_lval112 = load i32, i32* %t, align 4
  %elemPtr113 = getelementptr [15 x i32], [15 x i32]* @dis, i32 0, i32 %load_lval112
  %load_lval114 = load i32, i32* %elemPtr113, align 4
  %load_lval115 = load i32, i32* %t, align 4
  %load_lval116 = load i32, i32* %k, align 4
  %elemPtr117 = getelementptr [15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 %load_lval115, i32 %load_lval116
  %load_lval118 = load i32, i32* %elemPtr117, align 4
  %add119 = add i32 %load_lval114, %load_lval118
  %cmp120 = icmp sgt i32 %load_lval111, %add119
  %zext_to_i32121 = zext i1 %cmp120 to i32
  %rhs_bool122 = icmp ne i32 %zext_to_i32121, 0
  br label %and.merge108

and.merge108:                                     ; preds = %and.rhs107, %for.stmt93
  %and_result123 = phi i1 [ false, %for.stmt93 ], [ %rhs_bool122, %and.rhs107 ]
  %zext_to_i32124 = zext i1 %and_result123 to i32
  %to_bool126 = icmp ne i32 %zext_to_i32124, 0
  br i1 %to_bool126, label %if.then125, label %merge100

if.then125:                                       ; preds = %and.merge108
  %load_lval127 = load i32, i32* %k, align 4
  %elemPtr128 = getelementptr [15 x i32], [15 x i32]* @dis, i32 0, i32 %load_lval127
  %load_lval129 = load i32, i32* %t, align 4
  %elemPtr130 = getelementptr [15 x i32], [15 x i32]* @dis, i32 0, i32 %load_lval129
  %load_lval131 = load i32, i32* %elemPtr130, align 4
  %load_lval132 = load i32, i32* %t, align 4
  %load_lval133 = load i32, i32* %k, align 4
  %elemPtr134 = getelementptr [15 x [15 x i32]], [15 x [15 x i32]]* @e, i32 0, i32 %load_lval132, i32 %load_lval133
  %load_lval135 = load i32, i32* %elemPtr134, align 4
  %add136 = add i32 %load_lval131, %load_lval135
  store i32 %add136, i32* %elemPtr128, align 4
  br label %merge100
}
