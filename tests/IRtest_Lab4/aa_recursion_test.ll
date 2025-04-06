; ModuleID = 'my_module'
source_filename = "my_module"

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
  %n = alloca i32, align 4
  store i32 15, i32* %n, align 4
  %load_lval = load i32, i32* %n, align 4
  %fib = call i32 @fib(i32 %load_lval)
  ret i32 %fib
}
