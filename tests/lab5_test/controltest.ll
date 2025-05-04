; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 56
@y = global i32 98

define i32 @main() {
mainEntry:
  %a = alloca i32, align 4
  store i32 56, i32* %a, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval2 = load i32, i32* %a, align 4
  ret i32 %load_lval2

while.stmt:                                       ; preds = %while.cond
  %load_lval1 = load i32, i32* %a, align 4
  %add = add i32 %load_lval1, 1
  store i32 %add, i32* %a, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %a, align 4
  %cmp = icmp slt i32 %load_lval, 98
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
