; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %a = alloca i32, align 4
  store i32 56, i32* %a, align 4
  br label %while.stmt

while.stmt:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %a, align 4
  %sub = sub i32 %load_lval, 1
  store i32 %sub, i32* %a, align 4
  %load_lval1 = load i32, i32* %a, align 4
  %cmp = icmp eq i32 %load_lval1, 45
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br label %while.stmt
}
