; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @f(i32 %x) {
fEntry:
  %param0_addr = alloca i32, align 4
  store i32 %x, i32* %param0_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %cmp = icmp eq i32 %load_lval, 1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %if.else

if.then:                                          ; preds = %fEntry
  ret i32 1

if.else:                                          ; preds = %fEntry
  %load_lval1 = load i32, i32* %param0_addr, align 4
  %sub = sub i32 %load_lval1, 1
  %f = call i32 @f(i32 %sub)
  %load_lval2 = load i32, i32* %param0_addr, align 4
  %sub3 = sub i32 %load_lval2, 2
  %f4 = call i32 @f(i32 %sub3)
  %add = add i32 %f, %f4
  ret i32 %add
}

define i32 @main() {
mainEntry:
  %f = call i32 @f(i32 10)
  ret i32 %f
}
