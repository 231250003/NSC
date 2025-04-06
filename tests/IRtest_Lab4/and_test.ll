; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 10
@z = global i32 0

define i32 @g(i32 %t, i32 %y) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %t, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %y, i32* %param1_addr, align 4
  %load_lval = load i32, i32* %param1_addr, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* %param1_addr, align 4
  %load_lval1 = load i32, i32* @z, align 4
  %add2 = add i32 %load_lval1, 1
  store i32 %add2, i32* @z, align 4
  %load_lval3 = load i32, i32* @x, align 4
  %add4 = add i32 %load_lval3, 1
  store i32 %add4, i32* @x, align 4
  %load_lval5 = load i32, i32* %param1_addr, align 4
  %add6 = add i32 %load_lval5, 1
  ret i32 %add6
}

define i32 @main() {
mainEntry:
  %y = alloca i32, align 4
  store i32 10, i32* %y, align 4
  %load_lval = load i32, i32* %y, align 4
  store i32 %load_lval, i32* @z, align 4
  %load_lval1 = load i32, i32* @x, align 4
  %cmp = icmp sgt i32 %load_lval1, 5
  %zext_to_i32 = zext i1 %cmp to i32
  %lhs_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %lhs_bool, label %or.merge, label %or.rhs

merge:                                            ; preds = %cur, %or.merge
  %load_lval27 = load i32, i32* @x, align 4
  %add28 = add i32 %load_lval27, 1
  ret i32 %add28

or.rhs:                                           ; preds = %mainEntry
  %load_lval2 = load i32, i32* %y, align 4
  %div = sdiv i32 %load_lval2, 2
  %cmp3 = icmp eq i32 %div, 0
  %zext_to_i324 = zext i1 %cmp3 to i32
  %rhs_bool = icmp ne i32 %zext_to_i324, 0
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %mainEntry
  %or_result = phi i1 [ true, %mainEntry ], [ %rhs_bool, %or.rhs ]
  %zext_to_i325 = zext i1 %or_result to i32
  %to_bool = icmp ne i32 %zext_to_i325, 0
  br i1 %to_bool, label %if.then, label %merge

if.then:                                          ; preds = %or.merge
  %z = alloca i32, align 4
  store i32 5, i32* %z, align 4
  br label %while.cond

cur:                                              ; preds = %if.then25, %while.cond
  br label %merge

while.stmt:                                       ; preds = %while.cond
  %z6 = alloca i32, align 4
  %g = call i32 @g(i32 2, i32 3)
  store i32 %g, i32* %z6, align 4
  %load_lval8 = load i32, i32* @x, align 4
  %cmp9 = icmp slt i32 %load_lval8, 50
  %zext_to_i3210 = zext i1 %cmp9 to i32
  %lhs_bool11 = icmp ne i32 %zext_to_i3210, 0
  br i1 %lhs_bool11, label %and.rhs, label %and.merge

while.cond:                                       ; preds = %merge21, %if.then17, %if.then
  br i1 true, label %while.stmt, label %cur

merge7:                                           ; preds = %if.then17, %and.merge
  %load_lval22 = load i32, i32* @x, align 4
  %cmp23 = icmp sgt i32 %load_lval22, 10
  %zext_to_i3224 = zext i1 %cmp23 to i32
  %to_bool26 = icmp ne i32 %zext_to_i3224, 0
  br i1 %to_bool26, label %if.then25, label %merge21

and.rhs:                                          ; preds = %while.stmt
  %load_lval12 = load i32, i32* %z6, align 4
  %cmp13 = icmp sgt i32 %load_lval12, 100
  %zext_to_i3214 = zext i1 %cmp13 to i32
  %rhs_bool15 = icmp ne i32 %zext_to_i3214, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %while.stmt
  %and_result = phi i1 [ false, %while.stmt ], [ %rhs_bool15, %and.rhs ]
  %zext_to_i3216 = zext i1 %and_result to i32
  %to_bool18 = icmp ne i32 %zext_to_i3216, 0
  br i1 %to_bool18, label %if.then17, label %merge7

if.then17:                                        ; preds = %and.merge
  %load_lval19 = load i32, i32* @x, align 4
  %add = add i32 %load_lval19, 3
  store i32 %add, i32* @x, align 4
  %g20 = call i32 @g(i32 10, i32 2)
  br label %while.cond
  br label %merge7

merge21:                                          ; preds = %if.then25, %merge7
  br label %while.cond

if.then25:                                        ; preds = %merge7
  br label %cur
  br label %merge21
}
