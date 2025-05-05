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
  %load_lval2 = load i32, i32* %a, align 4
  %load_lval3 = load i32, i32* @x, align 4
  %not = icmp eq i32 %load_lval3, 0
  %zext_to_i32 = zext i1 %not to i32
  %add = add i32 %zext_to_i32, 3
  %cmp = icmp ne i32 %load_lval2, %add
  %zext_to_i324 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %if.then, %mainEntry
  %result = alloca i32, align 4
  %load_lval7 = load i32, i32* %a, align 4
  store i32 %load_lval7, i32* %result, align 4
  %load_lval8 = load i32, i32* %result, align 4
  ret i32 %load_lval8

if.then:                                          ; preds = %mainEntry
  %load_lval5 = load i32, i32* %a, align 4
  %add6 = add i32 %load_lval5, 1
  store i32 %add6, i32* %a, align 4
  br label %merge
}
