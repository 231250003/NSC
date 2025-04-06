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
  %load_lval35 = load i32, i32* @x, align 4
  ret i32 %load_lval35

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

cur:                                              ; preds = %merge27, %while.cond
  br label %merge

while.stmt:                                       ; preds = %while.cond
  %load_lval25 = load i32, i32* @x, align 4
  %add26 = add i32 %load_lval25, 1
  store i32 %add26, i32* @x, align 4
  %load_lval28 = load i32, i32* @x, align 4
  %cmp29 = icmp slt i32 %load_lval28, 125
  %zext_to_i3230 = zext i1 %cmp29 to i32
  %to_bool32 = icmp ne i32 %zext_to_i3230, 0
  br i1 %to_bool32, label %if.then31, label %merge27

while.cond:                                       ; preds = %merge27, %merge27, %if.then31, %merge1
  %load_lval21 = load i32, i32* @x, align 4
  %cmp22 = icmp slt i32 %load_lval21, 200
  %zext_to_i3223 = zext i1 %cmp22 to i32
  %to_bool24 = icmp ne i32 %zext_to_i3223, 0
  br i1 %to_bool24, label %while.stmt, label %cur

merge27:                                          ; preds = %if.then31, %while.stmt
  %load_lval33 = load i32, i32* @x, align 4
  %add34 = add i32 %load_lval33, 2
  store i32 %add34, i32* @x, align 4
  br label %while.cond
  br label %cur
  br label %while.cond

if.then31:                                        ; preds = %while.stmt
  br label %while.cond
  br label %merge27
}
