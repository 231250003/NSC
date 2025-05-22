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
  %load_lval20 = load i32, i32* %a, align 4
  store i32 %load_lval20, i32* %result, align 4
  %load_lval21 = load i32, i32* %result, align 4
  ret i32 %load_lval21

while.stmt:                                       ; preds = %while.cond
  %load_lval9 = load i32, i32* %a, align 4
  %load_lval10 = load i32, i32* %b, align 4
  %cmp11 = icmp sgt i32 %load_lval9, %load_lval10
  %zext_to_i3212 = zext i1 %cmp11 to i32
  %to_bool14 = icmp ne i32 %zext_to_i3212, 0
  br i1 %to_bool14, label %if.then13, label %if.else

while.cond:                                       ; preds = %if.else, %if.then13, %if.then, %mainEntry
  %load_lval4 = load i32, i32* %b, align 4
  %cmp5 = icmp ne i32 %load_lval4, 0
  %zext_to_i326 = zext i1 %cmp5 to i32
  %to_bool7 = icmp ne i32 %zext_to_i326, 0
  br i1 %to_bool7, label %while.stmt, label %cur

if.then13:                                        ; preds = %while.stmt
  %load_lval15 = load i32, i32* %a, align 4
  %load_lval16 = load i32, i32* %b, align 4
  %sub = sub i32 %load_lval15, %load_lval16
  store i32 %sub, i32* %a, align 4
  br label %while.cond

if.else:                                          ; preds = %while.stmt
  %load_lval17 = load i32, i32* %b, align 4
  %load_lval18 = load i32, i32* %a, align 4
  %sub19 = sub i32 %load_lval17, %load_lval18
  store i32 %sub19, i32* %b, align 4
  br label %while.cond
}
