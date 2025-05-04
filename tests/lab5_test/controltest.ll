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
  %x = alloca i32, align 4
  store i32 10, i32* %x, align 4
  %y = alloca i32, align 4
  store i32 5, i32* %y, align 4
  %load_lval2 = load i32, i32* %x, align 4
  %cmp = icmp sgt i32 %load_lval2, 0
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %merge4, %mainEntry
  %result = alloca i32, align 4
  %load_lval16 = load i32, i32* %x, align 4
  store i32 %load_lval16, i32* %result, align 4
  %load_lval17 = load i32, i32* %result, align 4
  ret i32 %load_lval17

if.then:                                          ; preds = %mainEntry
  %load_lval3 = load i32, i32* %a, align 4
  store i32 %load_lval3, i32* %x, align 4
  %load_lval5 = load i32, i32* %y, align 4
  %cmp6 = icmp sgt i32 %load_lval5, 0
  %zext_to_i327 = zext i1 %cmp6 to i32
  %to_bool9 = icmp ne i32 %zext_to_i327, 0
  br i1 %to_bool9, label %if.then8, label %merge4

merge4:                                           ; preds = %if.then8, %if.then
  %load_lval13 = load i32, i32* %x, align 4
  %add = add i32 %load_lval13, 10
  store i32 %add, i32* %x, align 4
  %load_lval14 = load i32, i32* %a, align 4
  %sub15 = sub i32 %load_lval14, 4
  store i32 %sub15, i32* %a, align 4
  br label %merge

if.then8:                                         ; preds = %if.then
  %load_lval10 = load i32, i32* %x, align 4
  %sub = sub i32 %load_lval10, 1
  store i32 %sub, i32* %x, align 4
  %load_lval11 = load i32, i32* %y, align 4
  %sub12 = sub i32 %load_lval11, 2
  store i32 %sub12, i32* %y, align 4
  br label %merge4
}
