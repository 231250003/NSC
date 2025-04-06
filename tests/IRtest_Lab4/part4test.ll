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
  %to_bool = icmp ne i32 %load_lval, 0
  %load_lval1 = load i32, i32* %b, align 4
  %to_bool2 = icmp ne i32 %load_lval1, 0
  %cmp = icmp sgt i1 %to_bool, %to_bool2
  br i1 %cmp, label %if.then, label %merge

merge:                                            ; preds = %merge3, %mainEntry
  %load_lval13 = load i32, i32* @a, align 4
  ret i32 %load_lval13

if.then:                                          ; preds = %mainEntry
  %load_lval4 = load i32, i32* %b, align 4
  %to_bool5 = icmp ne i32 %load_lval4, 0
  %load_lval6 = load i32, i32* %c, align 4
  %to_bool7 = icmp ne i32 %load_lval6, 0
  %cmp8 = icmp sgt i1 %to_bool5, %to_bool7
  br i1 %cmp8, label %if.then9, label %merge3

merge3:                                           ; preds = %if.then9, %if.then
  %load_lval11 = load i32, i32* @a, align 4
  %add12 = add i32 %load_lval11, 1
  store i32 %add12, i32* @a, align 4
  br label %merge

if.then9:                                         ; preds = %if.then
  %load_lval10 = load i32, i32* @a, align 4
  %add = add i32 %load_lval10, 1
  store i32 %add, i32* @a, align 4
  br label %merge3
}
