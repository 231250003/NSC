; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 1, i32* %num, align 4
  br i1 true, label %if.then, label %merge

merge:                                            ; preds = %if.then, %mainEntry
  %c = alloca i32, align 4
  %load_lval2 = load i32, i32* %num, align 4
  store i32 %load_lval2, i32* %c, align 4
  %load_lval3 = load i32, i32* %c, align 4
  ret i32 %load_lval3

if.then:                                          ; preds = %mainEntry
  store i32 2, i32* %num, align 4
  br label %merge
}
