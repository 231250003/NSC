; ModuleID = 'my_module'
source_filename = "my_module"

@z = global i32 0

define i32 @g(i32 %x, i32 %y) {
gEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %y, i32* %param1_addr, align 4
  %load_lval = load i32, i32* @z, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* @z, align 4
  ret i32 5
}

define i32 @fib(i32 %n) {
fibEntry:
  %param0_addr = alloca i32, align 4
  store i32 %n, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %cmp = icmp sle i32 %load_lval, 1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %if.then, %fibEntry
  %x = alloca i32, align 4
  %load_lval2 = load i32, i32* %param0_addr, align 4
  %sub = sub i32 %load_lval2, 1
  %fib = call i32 @fib(i32 %sub)
  store i32 %fib, i32* %x, align 4
  %y = alloca i32, align 4
  %load_lval3 = load i32, i32* %param0_addr, align 4
  %sub4 = sub i32 %load_lval3, 2
  %fib5 = call i32 @fib(i32 %sub4)
  store i32 %fib5, i32* %y, align 4
  %z = alloca i32, align 4
  %load_lval6 = load i32, i32* %x, align 4
  %load_lval7 = load i32, i32* %y, align 4
  %add = add i32 %load_lval6, %load_lval7
  store i32 %add, i32* %z, align 4
  %load_lval8 = load i32, i32* %z, align 4
  ret i32 %load_lval8

if.then:                                          ; preds = %fibEntry
  %load_lval1 = load i32, i32* %param0_addr, align 4
  ret i32 %load_lval1
  br label %merge
}

define i32 @main() {
mainEntry:
  %z = alloca i32, align 4
  store i32 62, i32* %z, align 4
  %p = alloca i32, align 4
  %g = call i32 @g(i32 1, i32 1)
  %load_lval = load i32, i32* %z, align 4
  %add = add i32 %g, %load_lval
  store i32 %add, i32* %p, align 4
  %load_lval1 = load i32, i32* %p, align 4
  %g2 = call i32 @g(i32 2, i32 2)
  %add3 = add i32 %load_lval1, %g2
  ret i32 %add3
}
