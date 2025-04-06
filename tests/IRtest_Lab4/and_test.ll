; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 10

define void @g() {
gEntry:
  %load_lval = load i32, i32* @x, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* @x, align 4
  ret void
}

define i32 @main() {
mainEntry:
  %y = alloca i32, align 4
  store i32 10, i32* %y, align 4
  %load_lval = load i32, i32* @x, align 4
  %cmp = icmp sgt i32 %load_lval, 50
  %lhs_bool = icmp ne i1 %cmp, false
  br i1 %lhs_bool, label %or.merge, label %or.rhs

merge:                                            ; preds = %cur, %or.merge
  %load_lval11 = load i32, i32* @x, align 4
  ret i32 %load_lval11

or.rhs:                                           ; preds = %mainEntry
  %load_lval1 = load i32, i32* %y, align 4
  %div = sdiv i32 %load_lval1, 2
  %cmp2 = icmp eq i32 %div, 0
  %rhs_bool = icmp ne i1 %cmp2, false
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %mainEntry
  %or_result = phi i1 [ true, %mainEntry ], [ %rhs_bool, %or.rhs ]
  br i1 %or_result, label %if.then, label %merge

if.then:                                          ; preds = %or.merge
  br label %while.cond

cur:                                              ; preds = %if.then10, %while.cond
  br label %merge

while.stmt:                                       ; preds = %while.cond
  %load_lval4 = load i32, i32* @x, align 4
  %cmp5 = icmp slt i32 %load_lval4, 50
  br i1 %cmp5, label %if.then6, label %merge3

while.cond:                                       ; preds = %merge7, %if.then6, %if.then
  br i1 true, label %while.stmt, label %cur

merge3:                                           ; preds = %if.then6, %while.stmt
  %load_lval8 = load i32, i32* @x, align 4
  %cmp9 = icmp sgt i32 %load_lval8, 100
  br i1 %cmp9, label %if.then10, label %merge7

if.then6:                                         ; preds = %while.stmt
  store i32 2, i32* @x, align 4
  br label %while.cond
  br label %merge3

merge7:                                           ; preds = %if.then10, %merge3
  br label %while.cond

if.then10:                                        ; preds = %merge3
  br label %cur
  br label %merge7
}
