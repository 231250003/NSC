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
  %mod = srem i32 %load_lval2, 2
  %cmp = icmp eq i32 %mod, 1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %if.then, %mainEntry
  %result = alloca i32, align 4
  %load_lval4 = load i32, i32* %a, align 4
  store i32 %load_lval4, i32* %result, align 4
  %load_lval5 = load i32, i32* %result, align 4
  ret i32 %load_lval5

if.then:                                          ; preds = %mainEntry
  %load_lval3 = load i32, i32* %a, align 4
  %add = add i32 %load_lval3, 1
  store i32 %add, i32* %a, align 4
  br label %merge
}
