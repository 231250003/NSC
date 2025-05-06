; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 56
@y = global i32 98

define i32 @main() {
mainEntry:
  %load_lval = load i32, i32* @x, align 4
  %load_lval1 = load i32, i32* @y, align 4
  %cmp = icmp sgt i32 %load_lval, %load_lval1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %if.else

if.then:                                          ; preds = %mainEntry
  %load_lval2 = load i32, i32* @x, align 4
  %load_lval3 = load i32, i32* @y, align 4
  %add = add i32 %load_lval2, %load_lval3
  ret i32 %add

if.else:                                          ; preds = %mainEntry
  %load_lval4 = load i32, i32* @y, align 4
  ret i32 %load_lval4
}
