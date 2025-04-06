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
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %merge2, %mainEntry
  %load_lval12 = load i32, i32* @a, align 4
  ret i32 %load_lval12
  ret void

if.then:                                          ; preds = %mainEntry
  %load_lval3 = load i32, i32* %b, align 4
  %load_lval4 = load i32, i32* %c, align 4
  %cmp5 = icmp sgt i32 %load_lval3, %load_lval4
  %zext_to_i326 = zext i1 %cmp5 to i32
  %to_bool8 = icmp ne i32 %zext_to_i326, 0
  br i1 %to_bool8, label %if.then7, label %merge2

merge2:                                           ; preds = %if.then7, %if.then
  %load_lval10 = load i32, i32* @a, align 4
  %add11 = add i32 %load_lval10, 1
  store i32 %add11, i32* @a, align 4
  br label %merge

if.then7:                                         ; preds = %if.then
  %load_lval9 = load i32, i32* @a, align 4
  %add = add i32 %load_lval9, 1
  store i32 %add, i32* @a, align 4
  br label %merge2
}
