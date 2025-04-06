; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 10

define i32 @f(i32 %x) {
fEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %load_lval = load i32, i32* @a, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* @a, align 4
  %load_lval1 = load i32, i32* @a, align 4
  %add2 = add i32 %load_lval1, 10
  ret i32 %add2
}

define i32 @main() {
mainEntry:
  %load_lval = load i32, i32* @a, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* @a, align 4
  %t = alloca i32, align 4
  %load_lval1 = load i32, i32* @a, align 4
  %f = call i32 @f(i32 %load_lval1)
  store i32 %f, i32* %t, align 4
  %load_lval2 = load i32, i32* @a, align 4
  %f3 = call i32 @f(i32 %load_lval2)
  %cmp = icmp slt i32 %f3, 10
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval8 = load i32, i32* @a, align 4
  %add9 = add i32 %load_lval8, 1
  ret i32 %add9

while.stmt:                                       ; preds = %while.cond
  %load_lval4 = load i32, i32* @a, align 4
  %f5 = call i32 @f(i32 %load_lval4)
  %cmp6 = icmp sgt i32 %f5, 10
  br i1 %cmp6, label %if.then, label %merge

while.cond:                                       ; preds = %merge, %mainEntry
  br i1 %cmp, label %while.stmt, label %cur

merge:                                            ; preds = %if.then, %while.stmt
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  %load_lval7 = load i32, i32* @a, align 4
  ret i32 %load_lval7
  br label %merge
}
