; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @p(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k, [3 x i32]* %arr) {
pEntry:
  %param0_addr = alloca i32, align 4
  store i32 %a, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %b, i32* %param1_addr, align 4
  %param2_addr = alloca i32, align 4
  store i32 %c, i32* %param2_addr, align 4
  %elemPtr = getelementptr [3 x i32], [3 x i32]* %arr, i32 0, i32 2
  %load_lval = load i32, i32* %elemPtr, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* %elemPtr, align 4
  %load_lval2 = load i32, i32* %param0_addr, align 4
  %load_lval3 = load i32, i32* %param1_addr, align 4
  %add4 = add i32 %load_lval2, %load_lval3
  %load_lval5 = load i32, i32* %param2_addr, align 4
  %add6 = add i32 %add4, %load_lval5
  %load_lval8 = load i32, i32* %elemPtr, align 4
  %add9 = add i32 %add6, %load_lval8
  ret i32 %add9
}

define i32 @f(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h, i32 %i, i32 %j, i32 %k) {
fEntry:
  %param0_addr = alloca i32, align 4
  store i32 %a, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %b, i32* %param1_addr, align 4
  %param2_addr = alloca i32, align 4
  store i32 %c, i32* %param2_addr, align 4
  %param3_addr = alloca i32, align 4
  store i32 %d, i32* %param3_addr, align 4
  %param4_addr = alloca i32, align 4
  store i32 %e, i32* %param4_addr, align 4
  %param5_addr = alloca i32, align 4
  store i32 %f, i32* %param5_addr, align 4
  %param6_addr = alloca i32, align 4
  store i32 %g, i32* %param6_addr, align 4
  %param7_addr = alloca i32, align 4
  store i32 %h, i32* %param7_addr, align 4
  %param8_addr = alloca i32, align 4
  store i32 %i, i32* %param8_addr, align 4
  %param9_addr = alloca i32, align 4
  store i32 %j, i32* %param9_addr, align 4
  %param10_addr = alloca i32, align 4
  store i32 %k, i32* %param10_addr, align 4
  %arr = alloca [3 x i32], align 4
  %elemPtr = getelementptr [3 x i32], [3 x i32]* %arr, i32 0, i32 0
  store i32 0, i32* %elemPtr, align 4
  %elemPtr1 = getelementptr [3 x i32], [3 x i32]* %arr, i32 0, i32 1
  store i32 0, i32* %elemPtr1, align 4
  %elemPtr2 = getelementptr [3 x i32], [3 x i32]* %arr, i32 0, i32 2
  store i32 0, i32* %elemPtr2, align 4
  %x = alloca i32, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %load_lval3 = load i32, i32* %param1_addr, align 4
  %load_lval4 = load i32, i32* %param2_addr, align 4
  %load_lval5 = load i32, i32* %param3_addr, align 4
  %load_lval6 = load i32, i32* %param4_addr, align 4
  %load_lval7 = load i32, i32* %param5_addr, align 4
  %load_lval8 = load i32, i32* %param6_addr, align 4
  %load_lval9 = load i32, i32* %param7_addr, align 4
  %load_lval10 = load i32, i32* %param8_addr, align 4
  %load_lval11 = load i32, i32* %param9_addr, align 4
  %load_lval12 = load i32, i32* %param10_addr, align 4
  %elemPtr13 = getelementptr [3 x i32], [3 x i32]* %arr, i32 0
  %p = call i32 @p(i32 %load_lval, i32 %load_lval3, i32 %load_lval4, i32 %load_lval5, i32 %load_lval6, i32 %load_lval7, i32 %load_lval8, i32 %load_lval9, i32 %load_lval10, i32 %load_lval11, i32 %load_lval12, [3 x i32]* %elemPtr13)
  store i32 %p, i32* %x, align 4
  %load_lval15 = load i32, i32* %elemPtr2, align 4
  %load_lval16 = load i32, i32* %param0_addr, align 4
  %add = add i32 %load_lval15, %load_lval16
  %load_lval17 = load i32, i32* %param1_addr, align 4
  %add18 = add i32 %add, %load_lval17
  %load_lval19 = load i32, i32* %param2_addr, align 4
  %add20 = add i32 %add18, %load_lval19
  %load_lval21 = load i32, i32* %param3_addr, align 4
  %add22 = add i32 %add20, %load_lval21
  %load_lval23 = load i32, i32* %param4_addr, align 4
  %add24 = add i32 %add22, %load_lval23
  %load_lval25 = load i32, i32* %param5_addr, align 4
  %add26 = add i32 %add24, %load_lval25
  %load_lval27 = load i32, i32* %param6_addr, align 4
  %add28 = add i32 %add26, %load_lval27
  %load_lval29 = load i32, i32* %param7_addr, align 4
  %add30 = add i32 %add28, %load_lval29
  %load_lval31 = load i32, i32* %param8_addr, align 4
  %add32 = add i32 %add30, %load_lval31
  %load_lval33 = load i32, i32* %param9_addr, align 4
  %add34 = add i32 %add32, %load_lval33
  %load_lval35 = load i32, i32* %param10_addr, align 4
  %add36 = add i32 %add34, %load_lval35
  %load_lval37 = load i32, i32* %x, align 4
  %add38 = add i32 %add36, %load_lval37
  ret i32 %add38
}

declare i32 @main()
