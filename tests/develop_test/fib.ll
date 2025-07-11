; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @fib(i32 %n) {
fibEntry:
  %param0_addr = alloca i32, align 4
  store i32 %n, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %cmp = icmp eq i32 %load_lval, 0
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %if.else

if.then:                                          ; preds = %fibEntry
  ret i32 1

if.else:                                          ; preds = %fibEntry
  %load_lval2 = load i32, i32* %param0_addr, align 4
  %cmp3 = icmp eq i32 %load_lval2, 2
  %zext_to_i324 = zext i1 %cmp3 to i32
  %to_bool7 = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool7, label %if.then5, label %if.else6

if.then5:                                         ; preds = %if.else
  ret i32 2

if.else6:                                         ; preds = %if.else
  %load_lval8 = load i32, i32* %param0_addr, align 4
  %fib = call i32 @fib(i32 %load_lval8)
  %load_lval9 = load i32, i32* %param0_addr, align 4
  %sub = sub i32 %load_lval9, 1
  %fib10 = call i32 @fib(i32 %sub)
  %add = add i32 %fib, %fib10
  ret i32 %add
}

define i32 @main() {
mainEntry:
  %fib = call i32 @fib(i32 5)
  ret i32 %fib
}
