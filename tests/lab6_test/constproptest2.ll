; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 1, i32* %num, align 4
  %load_lval = load i32, i32* %num, align 4
  %cmp = icmp eq i32 %load_lval, 1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %if.then, %mainEntry
  %load_lval2 = load i32, i32* %num, align 4
  ret i32 %load_lval2
  %c = alloca i32, align 4
  %load_lval3 = load i32, i32* %num, align 4
  store i32 %load_lval3, i32* %c, align 4
  %load_lval5 = load i32, i32* %c, align 4
  %cmp6 = icmp eq i32 %load_lval5, 1
  %zext_to_i327 = zext i1 %cmp6 to i32
  %to_bool9 = icmp ne i32 %zext_to_i327, 0
  br i1 %to_bool9, label %if.then8, label %merge4

if.then:                                          ; preds = %mainEntry
  %load_lval1 = load i32, i32* %num, align 4
  %add = add i32 %load_lval1, 1
  store i32 %add, i32* %num, align 4
  br label %merge

merge4:                                           ; preds = %if.then8, %merge
  br label %while.cond

if.then8:                                         ; preds = %merge
  %load_lval10 = load i32, i32* %c, align 4
  %add11 = add i32 %load_lval10, 1
  store i32 %add11, i32* %c, align 4
  br label %merge4

cur:                                              ; preds = %while.cond
  %load_lval18 = load i32, i32* %num, align 4
  %load_lval19 = load i32, i32* %num, align 4
  %mul = mul i32 %load_lval18, %load_lval19
  %load_lval20 = load i32, i32* %c, align 4
  %add21 = add i32 %mul, %load_lval20
  ret i32 %add21

while.stmt:                                       ; preds = %while.cond
  %load_lval16 = load i32, i32* %num, align 4
  %add17 = add i32 %load_lval16, 1
  store i32 %add17, i32* %num, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %merge4
  %load_lval12 = load i32, i32* %num, align 4
  %cmp13 = icmp sle i32 %load_lval12, 10
  %zext_to_i3214 = zext i1 %cmp13 to i32
  %to_bool15 = icmp ne i32 %zext_to_i3214, 0
  br i1 %to_bool15, label %while.stmt, label %cur
}
