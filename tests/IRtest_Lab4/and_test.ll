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
  %to_bool = icmp ne i32 %load_lval1, 0
  %cmp = icmp sgt i1 %to_bool, true
  %lhs_bool = icmp ne i1 %cmp, false
  br i1 %lhs_bool, label %or.merge, label %or.rhs

merge:                                            ; preds = %cur, %or.merge
  %load_lval16 = load i32, i32* @x, align 4
  ret i32 %load_lval16

or.rhs:                                           ; preds = %mainEntry
  %load_lval2 = load i32, i32* %y, align 4
  %div = sdiv i32 %load_lval2, 2
  %to_bool3 = icmp ne i32 %div, 0
  %cmp4 = icmp eq i1 %to_bool3, false
  %rhs_bool = icmp ne i1 %cmp4, false
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %mainEntry
  %or_result = phi i1 [ true, %mainEntry ], [ %rhs_bool, %or.rhs ]
  br i1 %or_result, label %if.then, label %merge

if.then:                                          ; preds = %or.merge
  br label %while.cond

cur:                                              ; preds = %if.then15, %while.cond
  br label %merge

while.stmt:                                       ; preds = %while.cond
  %g = call i32 @g(i32 2, i32 3)
  %load_lval6 = load i32, i32* @x, align 4
  %to_bool7 = icmp ne i32 %load_lval6, 0
  %cmp8 = icmp slt i1 %to_bool7, true
  br i1 %cmp8, label %if.then9, label %merge5

while.cond:                                       ; preds = %merge11, %if.then9, %if.then
  br i1 true, label %while.stmt, label %cur

merge5:                                           ; preds = %if.then9, %while.stmt
  %load_lval12 = load i32, i32* @x, align 4
  %to_bool13 = icmp ne i32 %load_lval12, 0
  %cmp14 = icmp sgt i1 %to_bool13, true
  br i1 %cmp14, label %if.then15, label %merge11

if.then9:                                         ; preds = %while.stmt
  store i32 2, i32* @x, align 4
  %g10 = call i32 @g(i32 10, i32 2)
  br label %while.cond
  br label %merge5

merge11:                                          ; preds = %if.then15, %merge5
  br label %while.cond

if.then15:                                        ; preds = %merge5
  br label %cur
  br label %merge11
}
