; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 100
@y = global i32 2
@z = global i32 3

define i32 @main() {
mainEntry:
  %load_lval = load i32, i32* @x, align 4
  %cmp = icmp sge i32 %load_lval, 100
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %cur, %mainEntry
  %load_lval50 = load i32, i32* @x, align 4
  ret i32 %load_lval50

if.then:                                          ; preds = %mainEntry
  %load_lval2 = load i32, i32* @x, align 4
  %cmp3 = icmp slt i32 %load_lval2, 10
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool6 = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool6, label %if.then5, label %if.else

merge1:                                           ; preds = %merge7, %if.then5
  %load_lval20 = load i32, i32* @x, align 4
  %add = add i32 %load_lval20, 1
  store i32 %add, i32* @x, align 4
  br label %while.cond

if.then5:                                         ; preds = %if.then
  ret i32 0
  br label %merge1

if.else:                                          ; preds = %if.then
  %load_lval8 = load i32, i32* @x, align 4
  %cmp9 = icmp sgt i32 %load_lval8, 200
  %zext_to_i3210 = zext i1 %cmp9 to i32
  %to_bool13 = icmp ne i32 %zext_to_i3210, 0
  br i1 %to_bool13, label %if.then11, label %if.else12

merge7:                                           ; preds = %merge14, %if.then11
  br label %merge1

if.then11:                                        ; preds = %if.else
  ret i32 2
  br label %merge7

if.else12:                                        ; preds = %if.else
  %load_lval15 = load i32, i32* @x, align 4
  %cmp16 = icmp sgt i32 %load_lval15, 256
  %zext_to_i3217 = zext i1 %cmp16 to i32
  %to_bool19 = icmp ne i32 %zext_to_i3217, 0
  br i1 %to_bool19, label %if.then18, label %merge14

merge14:                                          ; preds = %if.then18, %if.else12
  br label %merge7

if.then18:                                        ; preds = %if.else12
  ret i32 3
  br label %merge14

cur:                                              ; preds = %merge42, %if.then38, %while.cond
  br label %merge

while.stmt:                                       ; preds = %while.cond
  %load_lval26 = load i32, i32* @x, align 4
  %cmp27 = icmp sgt i32 %load_lval26, 10
  %zext_to_i3228 = zext i1 %cmp27 to i32
  %lhs_bool = icmp ne i32 %zext_to_i3228, 0
  br i1 %lhs_bool, label %and.rhs, label %and.merge

while.cond:                                       ; preds = %merge42, %merge42, %if.then46, %merge1
  %load_lval21 = load i32, i32* @x, align 4
  %cmp22 = icmp slt i32 %load_lval21, 200
  %zext_to_i3223 = zext i1 %cmp22 to i32
  %to_bool24 = icmp ne i32 %zext_to_i3223, 0
  br i1 %to_bool24, label %while.stmt, label %cur

merge25:                                          ; preds = %if.then38, %or.merge
  %load_lval40 = load i32, i32* @x, align 4
  %add41 = add i32 %load_lval40, 1
  store i32 %add41, i32* @x, align 4
  %load_lval43 = load i32, i32* @x, align 4
  %cmp44 = icmp slt i32 %load_lval43, 125
  %zext_to_i3245 = zext i1 %cmp44 to i32
  %to_bool47 = icmp ne i32 %zext_to_i3245, 0
  br i1 %to_bool47, label %if.then46, label %merge42

and.rhs:                                          ; preds = %while.stmt
  %load_lval29 = load i32, i32* @x, align 4
  %not = icmp eq i32 %load_lval29, 0
  %zext_to_i3230 = zext i1 %not to i32
  %rhs_bool = icmp ne i32 %zext_to_i3230, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %while.stmt
  %and_result = phi i1 [ false, %while.stmt ], [ %rhs_bool, %and.rhs ]
  %zext_to_i3231 = zext i1 %and_result to i32
  %lhs_bool32 = icmp ne i32 %zext_to_i3231, 0
  br i1 %lhs_bool32, label %or.merge, label %or.rhs

or.rhs:                                           ; preds = %and.merge
  %load_lval33 = load i32, i32* @x, align 4
  %cmp34 = icmp sgt i32 %load_lval33, 150
  %zext_to_i3235 = zext i1 %cmp34 to i32
  %rhs_bool36 = icmp ne i32 %zext_to_i3235, 0
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %and.merge
  %or_result = phi i1 [ true, %and.merge ], [ %rhs_bool36, %or.rhs ]
  %zext_to_i3237 = zext i1 %or_result to i32
  %to_bool39 = icmp ne i32 %zext_to_i3237, 0
  br i1 %to_bool39, label %if.then38, label %merge25

if.then38:                                        ; preds = %or.merge
  br label %cur
  br label %merge25

merge42:                                          ; preds = %if.then46, %merge25
  %load_lval48 = load i32, i32* @x, align 4
  %add49 = add i32 %load_lval48, 2
  store i32 %add49, i32* @x, align 4
  br label %while.cond
  br label %cur
  br label %while.cond

if.then46:                                        ; preds = %merge25
  br label %while.cond
  br label %merge42
}
