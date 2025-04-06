; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 10
@z = global i32 0

define i32 @g(i32 %x, i32 %y) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %y, i32* %param1_addr, align 4
  %load_lval = load i32, i32* %param1_addr, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* %param1_addr, align 4
  %load_lval1 = load i32, i32* @z, align 4
  %add2 = add i32 %load_lval1, 1
  store i32 %add2, i32* @z, align 4
  %load_lval3 = load i32, i32* %param1_addr, align 4
  %add4 = add i32 %load_lval3, 1
  ret i32 %add4
}

define i32 @main() {
mainEntry:
  %y = alloca i32, align 4
  store i32 10, i32* %y, align 4
  %load_lval = load i32, i32* %y, align 4
  store i32 %load_lval, i32* @z, align 4
  %load_lval1 = load i32, i32* @x, align 4
  %cmp = icmp sgt i32 %load_lval1, 50
  %lhs_bool = icmp ne i1 %cmp, false
  br i1 %lhs_bool, label %or.merge, label %or.rhs

merge:                                            ; preds = %cur, %or.merge
  %load_lval14 = load i32, i32* @x, align 4
  ret i32 %load_lval14

or.rhs:                                           ; preds = %mainEntry
  %load_lval2 = load i32, i32* %y, align 4
  %div = sdiv i32 %load_lval2, 2
  %cmp3 = icmp eq i32 %div, 0
  %rhs_bool = icmp ne i1 %cmp3, false
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %mainEntry
  %or_result = phi i1 [ true, %mainEntry ], [ %rhs_bool, %or.rhs ]
  br i1 %or_result, label %if.then, label %merge

if.then:                                          ; preds = %or.merge
  br label %while.cond

cur:                                              ; preds = %if.then13, %while.cond
  br label %merge

while.stmt:                                       ; preds = %while.cond
  %g = call i32 @g(i32 2, i32 3)
  %load_lval5 = load i32, i32* @x, align 4
  %to_bool = icmp ne i32 %load_lval5, 0
  %cmp6 = icmp slt i1 %to_bool, true
  br i1 %cmp6, label %if.then7, label %merge4

while.cond:                                       ; preds = %merge9, %if.then7, %if.then
  br i1 true, label %while.stmt, label %cur

merge4:                                           ; preds = %if.then7, %while.stmt
  %load_lval10 = load i32, i32* @x, align 4
  %to_bool11 = icmp ne i32 %load_lval10, 0
  %cmp12 = icmp sgt i1 %to_bool11, true
  br i1 %cmp12, label %if.then13, label %merge9

if.then7:                                         ; preds = %while.stmt
  store i32 2, i32* @x, align 4
  %g8 = call i32 @g(i32 10, i32 2)
  br label %while.cond
  br label %merge4

merge9:                                           ; preds = %if.then13, %merge4
  br label %while.cond

if.then13:                                        ; preds = %merge4
  br label %cur
  br label %merge9
}
