; ModuleID = 'my_module'
source_filename = "my_module"

@global_var = global i32 1

define i32 @main() {
mainEntry:
  %num = alloca i32, align 4
  store i32 1, i32* %num, align 4
  %load_lval = load i32, i32* %num, align 4
  %cmp = icmp ne i32 %load_lval, 1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %if.then, %mainEntry
  store i32 3, i32* %num, align 4
  %x = alloca i32, align 4
  %load_lval2 = load i32, i32* @global_var, align 4
  store i32 %load_lval2, i32* %x, align 4
  store i32 3, i32* %x, align 4
  %load_lval3 = load i32, i32* @global_var, align 4
  store i32 %load_lval3, i32* %x, align 4
  %load_lval4 = load i32, i32* %num, align 4
  %load_lval5 = load i32, i32* %x, align 4
  %add = add i32 %load_lval4, %load_lval5
  ret i32 %add

if.then:                                          ; preds = %mainEntry
  %load_lval1 = load i32, i32* %num, align 4
  %mul = mul i32 %load_lval1, 2
  store i32 %mul, i32* %num, align 4
  br label %merge
}
