; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 56
@y = global i32 98

define i32 @main() {
mainEntry:
  %a = alloca i32, align 4
  %load_lval = load i32, i32* @x, align 4
  store i32 %load_lval, i32* %a, align 4
  %b = alloca i32, align 4
  %load_lval1 = load i32, i32* @y, align 4
  store i32 %load_lval1, i32* %b, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %result = alloca i32, align 4
  %load_lval11 = load i32, i32* %a, align 4
  store i32 %load_lval11, i32* %result, align 4
  %load_lval12 = load i32, i32* %result, align 4
  ret i32 %load_lval12

while.stmt:                                       ; preds = %while.cond
  %load_lval3 = load i32, i32* %a, align 4
  %add = add i32 %load_lval3, 1
  store i32 %add, i32* %a, align 4
  %load_lval4 = load i32, i32* %a, align 4
  %load_lval5 = load i32, i32* %b, align 4
  %cmp6 = icmp sgt i32 %load_lval4, %load_lval5
  %zext_to_i327 = zext i1 %cmp6 to i32
  %to_bool8 = icmp ne i32 %zext_to_i327, 0
  br i1 %to_bool8, label %if.then, label %merge

while.cond:                                       ; preds = %merge, %mainEntry
  %load_lval2 = load i32, i32* %a, align 4
  %cmp = icmp slt i32 %load_lval2, 98
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %if.then, %while.stmt
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  %load_lval9 = load i32, i32* %a, align 4
  %add10 = add i32 %load_lval9, 1
  store i32 %add10, i32* %a, align 4
  br label %merge
}
