; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %a = alloca i32, align 4
  store i32 15, i32* %a, align 4
  %b = alloca i32, align 4
  store i32 3, i32* %b, align 4
  %c = alloca i32, align 4
  %load_lval = load i32, i32* %a, align 4
  %load_lval1 = load i32, i32* %b, align 4
  %add = add i32 %load_lval, %load_lval1
  store i32 %add, i32* %c, align 4
  %d = alloca i32, align 4
  %load_lval2 = load i32, i32* %a, align 4
  %load_lval3 = load i32, i32* %b, align 4
  %sub = sub i32 %load_lval2, %load_lval3
  store i32 %sub, i32* %d, align 4
  %e = alloca i32, align 4
  %load_lval4 = load i32, i32* %a, align 4
  %load_lval5 = load i32, i32* %b, align 4
  %mul = mul i32 %load_lval4, %load_lval5
  store i32 %mul, i32* %e, align 4
  %f = alloca i32, align 4
  %load_lval6 = load i32, i32* %a, align 4
  %load_lval7 = load i32, i32* %b, align 4
  %div = sdiv i32 %load_lval6, %load_lval7
  store i32 %div, i32* %f, align 4
  %g = alloca i32, align 4
  %load_lval8 = load i32, i32* %a, align 4
  %load_lval9 = load i32, i32* %b, align 4
  %mod = srem i32 %load_lval8, %load_lval9
  store i32 %mod, i32* %g, align 4
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  %n = alloca i32, align 4
  store i32 0, i32* %n, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %mem_test = alloca i32, align 4
  store i32 0, i32* %mem_test, align 4
  %load_lval16 = load i32, i32* %c, align 4
  store i32 %load_lval16, i32* %mem_test, align 4
  %load_test = alloca i32, align 4
  %load_lval17 = load i32, i32* %mem_test, align 4
  store i32 %load_lval17, i32* %load_test, align 4
  %load_lval18 = load i32, i32* %c, align 4
  %sub19 = sub i32 %load_lval18, 18
  %load_lval20 = load i32, i32* %d, align 4
  %sub21 = sub i32 %load_lval20, 12
  %add22 = add i32 %sub19, %sub21
  %load_lval23 = load i32, i32* %e, align 4
  %sub24 = sub i32 %load_lval23, 45
  %add25 = add i32 %add22, %sub24
  %load_lval26 = load i32, i32* %sum, align 4
  %sub27 = sub i32 %load_lval26, 10
  %add28 = add i32 %add25, %sub27
  ret i32 %add28

while.stmt:                                       ; preds = %while.cond
  %load_lval11 = load i32, i32* %sum, align 4
  %load_lval12 = load i32, i32* %n, align 4
  %add13 = add i32 %load_lval11, %load_lval12
  store i32 %add13, i32* %sum, align 4
  %load_lval14 = load i32, i32* %n, align 4
  %add15 = add i32 %load_lval14, 1
  store i32 %add15, i32* %n, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %mainEntry
  %load_lval10 = load i32, i32* %n, align 4
  %cmp = icmp slt i32 %load_lval10, 5
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}
