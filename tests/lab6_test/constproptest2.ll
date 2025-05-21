; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 1, i32* %num, align 4
  br label %merge

merge:                                            ; preds = %mainEntry, %if.then
  store i32 3, i32* %num, align 4
  %load_lval4 = load i32, i32* %num, align 4
  %add = add i32 %load_lval4, 1
  ret i32 %add
}
