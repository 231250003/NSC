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
  %f = call i32 @f()
  store i32 %f, i32* %t, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval7 = load i32, i32* @a, align 4
  %add8 = add i32 %load_lval7, 1
  ret i32 %add8

while.stmt:                                       ; preds = %while.cond
  %f2 = call i32 @f()
  %cmp3 = icmp sgt i32 %f2, 10
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool5 = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool5, label %if.then, label %merge

while.cond:                                       ; preds = %merge, %mainEntry
  %f1 = call i32 @f()
  %cmp = icmp slt i32 %f1, 10
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %if.then, %while.stmt
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  %load_lval6 = load i32, i32* @a, align 4
  ret i32 %load_lval6
  br label %merge
}
