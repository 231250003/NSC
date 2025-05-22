; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 56
@y = global i32 98

define i32 @main() {
mainEntry:
  %a = alloca i32, align 4
  store i32 56, i32* %a, align 4
  %b = alloca i32, align 4
  store i32 98, i32* %b, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %result = alloca i32, align 4
  %load_lval13 = load i32, i32* %a, align 4
  store i32 %load_lval13, i32* %result, align 4
  %load_lval14 = load i32, i32* %result, align 4
  ret i32 %load_lval14

while.stmt:                                       ; preds = %while.cond
  %load_lval3 = load i32, i32* %a, align 4
  %load_lval4 = load i32, i32* %b, align 4
  %cmp5 = icmp sgt i32 %load_lval3, %load_lval4
  %zext_to_i326 = zext i1 %cmp5 to i32
  %to_bool7 = icmp ne i32 %zext_to_i326, 0
  br i1 %to_bool7, label %if.then, label %if.else

while.cond:                                       ; preds = %if.else, %if.then, %mainEntry
  %load_lval2 = load i32, i32* %b, align 4
  %cmp = icmp ne i32 %load_lval2, 0
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

if.then:                                          ; preds = %while.stmt
  %load_lval8 = load i32, i32* %a, align 4
  %load_lval9 = load i32, i32* %b, align 4
  %sub = sub i32 %load_lval8, %load_lval9
  store i32 %sub, i32* %a, align 4
  br label %while.cond

if.else:                                          ; preds = %while.stmt
  %load_lval10 = load i32, i32* %b, align 4
  %load_lval11 = load i32, i32* %a, align 4
  %sub12 = sub i32 %load_lval10, %load_lval11
  store i32 %sub12, i32* %b, align 4
  br label %while.cond
}
