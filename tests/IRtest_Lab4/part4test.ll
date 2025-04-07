; ModuleID = 'my_module'
source_filename = "my_module"

@a = global i32 10

define i32 @main() {
mainEntry:
  %b = alloca i32, align 4
  store i32 2, i32* %b, align 4
  %c = alloca i32, align 4
  store i32 3, i32* %c, align 4
  %load_lval = load i32, i32* @a, align 4
  %load_lval1 = load i32, i32* %b, align 4
  %cmp = icmp sgt i32 %load_lval, %load_lval1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %mainEntry
  %load_lval11 = load i32, i32* @a, align 4
  ret i32 %load_lval11

if.then:                                          ; preds = %if.then, %mainEntry
  %load_lval2 = load i32, i32* %b, align 4
  %load_lval3 = load i32, i32* %c, align 4
  %cmp4 = icmp sgt i32 %load_lval2, %load_lval3
  %zext_to_i325 = zext i1 %cmp4 to i32
  %to_bool7 = icmp ne i32 %zext_to_i325, 0
  br i1 %to_bool7, label %if.then6, label %if.then

if.then6:                                         ; preds = %if.then
  %load_lval8 = load i32, i32* @a, align 4
  %add = add i32 %load_lval8, 1
  store i32 %add, i32* @a, align 4
  br label %merge

merge:                                            ; preds = %if.then6
  %load_lval9 = load i32, i32* @a, align 4
  %add10 = add i32 %load_lval9, 1
  store i32 %add10, i32* @a, align 4
}
