; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 1, i32* %num, align 4
  %load_lval = load i32, i32* null, align 4
  %cmp = icmp eq i32 0, 0
  %zext_to_i32 = zext i1 false to i32
  %to_bool = icmp ne i32 0, 0
  br i1 true, label %if.then, label %merge

merge:                                            ; preds = %if.then, %mainEntry
  %load_lval2 = load i32, i32* %num, align 4
  ret i32 %load_lval2

if.then:                                          ; preds = %mainEntry
  %load_lval1 = load i32, i32* null, align 4
  %add = add i32 0, 0
  store i32 2, i32* %num, align 4
  br label %merge
}
