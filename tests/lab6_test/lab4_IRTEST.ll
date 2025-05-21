; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %a = alloca i32, align 4
  store i32 2, i32* %a, align 4
  %load_lval = load i32, i32* %a, align 4
  %cmp = icmp ne i32 %load_lval, 2
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %if.else

merge:                                            ; preds = %if.else, %if.then
  unreachable

if.then:                                          ; preds = %mainEntry
  %load_lval1 = load i32, i32* %a, align 4
  %add = add i32 %load_lval1, 1
  ret i32 %add
  br label %merge

if.else:                                          ; preds = %mainEntry
  %load_lval2 = load i32, i32* %a, align 4
  %add3 = add i32 %load_lval2, 2
  ret i32 %add3
  br label %merge
}
