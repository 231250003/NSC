; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @gcd(i32 %a, i32 %b) {
gcdEntry:
  %param0_addr = alloca i32, align 4
  store i32 %a, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %b, i32* %param1_addr, align 4
  %load_lval = load i32, i32* %param1_addr, align 4
  %cmp = icmp eq i32 %load_lval, 0
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %merge

merge:                                            ; preds = %gcdEntry
  %load_lval2 = load i32, i32* %param1_addr, align 4
  %load_lval3 = load i32, i32* %param0_addr, align 4
  %load_lval4 = load i32, i32* %param1_addr, align 4
  %mod = srem i32 %load_lval3, %load_lval4
  %gcd = call i32 @gcd(i32 %load_lval2, i32 %mod)
  ret i32 %gcd

if.then:                                          ; preds = %gcdEntry
  %load_lval1 = load i32, i32* %param0_addr, align 4
  ret i32 %load_lval1
}

define i32 @main() {
mainEntry:
  %num1 = alloca i32, align 4
  store i32 25, i32* %num1, align 4
  %num2 = alloca i32, align 4
  store i32 40, i32* %num2, align 4
  %result = alloca i32, align 4
  %load_lval = load i32, i32* %num1, align 4
  %load_lval1 = load i32, i32* %num2, align 4
  %gcd = call i32 @gcd(i32 %load_lval, i32 %load_lval1)
  store i32 %gcd, i32* %result, align 4
  %load_lval2 = load i32, i32* %result, align 4
  ret i32 %load_lval2
}
