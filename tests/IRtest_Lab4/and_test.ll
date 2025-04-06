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
  %zext_to_i32 = zext i1 %cmp to i32
  %lhs_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %lhs_bool, label %or.merge, label %or.rhs

merge:                                            ; preds = %cur, %or.merge
  %load_lval19 = load i32, i32* @x, align 4
  %add = add i32 %load_lval19, 1
  ret i32 %add

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
  br label %while.cond

cur:                                              ; preds = %if.then17, %while.cond
  br label %merge

while.stmt:                                       ; preds = %while.cond
  %g = call i32 @g(i32 2, i32 3)
  %load_lval7 = load i32, i32* @x, align 4
  %cmp8 = icmp slt i32 %load_lval7, 50
  %zext_to_i329 = zext i1 %cmp8 to i32
  %to_bool11 = icmp ne i32 %zext_to_i329, 0
  br i1 %to_bool11, label %if.then10, label %merge6

while.cond:                                       ; preds = %merge13, %if.then10, %if.then
  br i1 true, label %while.stmt, label %cur

merge6:                                           ; preds = %if.then10, %while.stmt
  %load_lval14 = load i32, i32* @x, align 4
  %cmp15 = icmp sgt i32 %load_lval14, 100
  %zext_to_i3216 = zext i1 %cmp15 to i32
  %to_bool18 = icmp ne i32 %zext_to_i3216, 0
  br i1 %to_bool18, label %if.then17, label %merge13

if.then10:                                        ; preds = %while.stmt
  store i32 2, i32* @x, align 4
  %g12 = call i32 @g(i32 10, i32 2)
  br label %while.cond
  br label %merge6

merge13:                                          ; preds = %if.then17, %merge6
  br label %while.cond

if.then17:                                        ; preds = %merge6
  br label %cur
  br label %merge13
}
