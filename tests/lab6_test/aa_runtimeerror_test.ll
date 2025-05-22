; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %count = alloca i32, align 4
  store i32 0, i32* %count, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %load_lval71 = load i32, i32* %count, align 4
  ret i32 %load_lval71

while.stmt:                                       ; preds = %while.cond
  %load_lval2 = load i32, i32* %count, align 4
  %add = add i32 %load_lval2, 10
  %add5 = add i32 %add, 10
  %add7 = add i32 %add5, 10
  %add9 = add i32 %add7, 10
  %add11 = add i32 %add9, 10
  %add13 = add i32 %add11, 10
  %add15 = add i32 %add13, 10
  %add17 = add i32 %add15, 10
  %add19 = add i32 %add17, 10
  store i32 %add19, i32* %count, align 4
  %load_lval20 = load i32, i32* %count, align 4
  %add22 = add i32 %load_lval20, 10
  %add24 = add i32 %add22, 10
  %add26 = add i32 %add24, 10
  %add28 = add i32 %add26, 10
  %add30 = add i32 %add28, 10
  %add32 = add i32 %add30, 10
  %add34 = add i32 %add32, 10
  %add36 = add i32 %add34, 10
  %add38 = add i32 %add36, 10
  %add40 = add i32 %add38, 10
  store i32 %add40, i32* %count, align 4
  %load_lval41 = load i32, i32* %count, align 4
  %add43 = add i32 %load_lval41, 10
  %add45 = add i32 %add43, 10
  %add47 = add i32 %add45, 10
  %add49 = add i32 %add47, 10
  %add51 = add i32 %add49, 10
  %add53 = add i32 %add51, 10
  %add55 = add i32 %add53, 10
  %add57 = add i32 %add55, 10
  %add59 = add i32 %add57, 10
  %add61 = add i32 %add59, 10
  store i32 %add61, i32* %count, align 4
  %load_lval62 = load i32, i32* %count, align 4
  %add64 = add i32 %load_lval62, 10
  %add66 = add i32 %add64, 10
  %add68 = add i32 %add66, 10
  store i32 %add68, i32* %count, align 4
  %load_lval69 = load i32, i32* %i, align 4
  %add70 = add i32 %load_lval69, 1
  store i32 %add70, i32* %i, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 5
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
