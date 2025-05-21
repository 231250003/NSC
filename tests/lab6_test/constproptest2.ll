; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 1, i32* %num, align 4
  br i1 false, label %if.then, label %merge

merge:                                            ; preds = %if.then, %mainEntry
  store i32 3, i32* %num, align 4
  %x = alloca i32, align 4
  store i32 1, i32* %x, align 4
  %load_lval4 = load i32, i32* %num, align 4
  %add = add i32 %load_lval4, 1
  ret i32 %add

if.then:                                          ; preds = %mainEntry
  store i32 2, i32* %num, align 4
  br label %merge
}
