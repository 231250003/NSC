; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %prime_counter = alloca i32, align 4
  store i32 0, i32* %prime_counter, align 4
  %current_num = alloca i32, align 4
  store i32 2, i32* %current_num, align 4
  %total_primes = alloca i32, align 4
  store i32 0, i32* %total_primes, align 4
  %fib_a = alloca i32, align 4
  store i32 0, i32* %fib_a, align 4
  %fib_b = alloca i32, align 4
  store i32 1, i32* %fib_b, align 4
  %fib_temp = alloca i32, align 4
  store i32 64, i32* %fib_temp, align 4
  %fib_count = alloca i32, align 4
  store i32 1, i32* %fib_count, align 4
  %even_fib_sum = alloca i32, align 4
  store i32 0, i32* %even_fib_sum, align 4
  %factorial = alloca i32, align 4
  store i32 1, i32* %factorial, align 4
  %fact_counter = alloca i32, align 4
  store i32 1, i32* %fact_counter, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  br label %while.cond39

while.stmt:                                       ; preds = %while.cond
  %is_prime = alloca i32, align 4
  store i32 1, i32* %is_prime, align 4
  %divisor = alloca i32, align 4
  store i32 2, i32* %divisor, align 4
  br label %while.cond4

while.cond:                                       ; preds = %merge17, %mainEntry
  %load_lval = load i32, i32* %current_num, align 4
  %cmp = icmp slt i32 %load_lval, 50
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

cur2:                                             ; preds = %if.then, %while.cond4
  %load_lval18 = load i32, i32* %is_prime, align 4
  %cmp19 = icmp eq i32 %load_lval18, 1
  %zext_to_i3220 = zext i1 %cmp19 to i32
  %to_bool22 = icmp ne i32 %zext_to_i3220, 0
  br i1 %to_bool22, label %if.then21, label %if.else

while.stmt3:                                      ; preds = %while.cond4
  %load_lval11 = load i32, i32* %current_num, align 4
  %load_lval12 = load i32, i32* %divisor, align 4
  %mod = srem i32 %load_lval11, %load_lval12
  %cmp13 = icmp eq i32 %mod, 0
  %zext_to_i3214 = zext i1 %cmp13 to i32
  %to_bool15 = icmp ne i32 %zext_to_i3214, 0
  br i1 %to_bool15, label %if.then, label %merge

while.cond4:                                      ; preds = %merge, %while.stmt
  %load_lval5 = load i32, i32* %divisor, align 4
  %load_lval6 = load i32, i32* %divisor, align 4
  %mul = mul i32 %load_lval5, %load_lval6
  %load_lval7 = load i32, i32* %current_num, align 4
  %cmp8 = icmp sle i32 %mul, %load_lval7
  %zext_to_i329 = zext i1 %cmp8 to i32
  %to_bool10 = icmp ne i32 %zext_to_i329, 0
  br i1 %to_bool10, label %while.stmt3, label %cur2

merge:                                            ; preds = %if.then, %while.stmt3
  %load_lval16 = load i32, i32* %divisor, align 4
  %add = add i32 %load_lval16, 1
  store i32 %add, i32* %divisor, align 4
  br label %while.cond4

if.then:                                          ; preds = %while.stmt3
  store i32 0, i32* %is_prime, align 4
  br label %cur2
  br label %merge

merge17:                                          ; preds = %if.else, %merge26
  %load_lval35 = load i32, i32* %current_num, align 4
  %add36 = add i32 %load_lval35, 1
  store i32 %add36, i32* %current_num, align 4
  br label %while.cond

if.then21:                                        ; preds = %cur2
  %load_lval23 = load i32, i32* %total_primes, align 4
  %load_lval24 = load i32, i32* %current_num, align 4
  %add25 = add i32 %load_lval23, %load_lval24
  store i32 %add25, i32* %total_primes, align 4
  %load_lval27 = load i32, i32* %current_num, align 4
  %cmp28 = icmp sgt i32 %load_lval27, 10
  %zext_to_i3229 = zext i1 %cmp28 to i32
  %to_bool31 = icmp ne i32 %zext_to_i3229, 0
  br i1 %to_bool31, label %if.then30, label %merge26

if.else:                                          ; preds = %cur2
  %load_lval34 = load i32, i32* %prime_counter, align 4
  %sub = sub i32 %load_lval34, 1
  store i32 %sub, i32* %prime_counter, align 4
  br label %merge17

merge26:                                          ; preds = %if.then30, %if.then21
  br label %merge17

if.then30:                                        ; preds = %if.then21
  %load_lval32 = load i32, i32* %prime_counter, align 4
  %add33 = add i32 %load_lval32, 1
  store i32 %add33, i32* %prime_counter, align 4
  br label %merge26

cur37:                                            ; preds = %while.cond39
  br label %while.cond67

while.stmt38:                                     ; preds = %while.cond39
  %load_lval45 = load i32, i32* %fib_a, align 4
  %mod46 = srem i32 %load_lval45, 2
  %cmp47 = icmp eq i32 %mod46, 0
  %zext_to_i3248 = zext i1 %cmp47 to i32
  %to_bool51 = icmp ne i32 %zext_to_i3248, 0
  br i1 %to_bool51, label %if.then49, label %if.else50

while.cond39:                                     ; preds = %merge44, %cur
  %load_lval40 = load i32, i32* %fib_count, align 4
  %cmp41 = icmp slt i32 %load_lval40, 15
  %zext_to_i3242 = zext i1 %cmp41 to i32
  %to_bool43 = icmp ne i32 %zext_to_i3242, 0
  br i1 %to_bool43, label %while.stmt38, label %cur37

merge44:                                          ; preds = %if.else50, %if.then49
  %load_lval58 = load i32, i32* %fib_a, align 4
  %load_lval59 = load i32, i32* %fib_b, align 4
  %add60 = add i32 %load_lval58, %load_lval59
  store i32 %add60, i32* %fib_temp, align 4
  %load_lval61 = load i32, i32* %fib_b, align 4
  store i32 %load_lval61, i32* %fib_a, align 4
  %load_lval62 = load i32, i32* %fib_temp, align 4
  store i32 %load_lval62, i32* %fib_b, align 4
  %load_lval63 = load i32, i32* %fib_count, align 4
  %add64 = add i32 %load_lval63, 1
  store i32 %add64, i32* %fib_count, align 4
  br label %while.cond39

if.then49:                                        ; preds = %while.stmt38
  %load_lval52 = load i32, i32* %even_fib_sum, align 4
  %load_lval53 = load i32, i32* %fib_a, align 4
  %add54 = add i32 %load_lval52, %load_lval53
  store i32 %add54, i32* %even_fib_sum, align 4
  br label %merge44

if.else50:                                        ; preds = %while.stmt38
  %load_lval55 = load i32, i32* %even_fib_sum, align 4
  %load_lval56 = load i32, i32* %fib_a, align 4
  %div = sdiv i32 %load_lval56, 2
  %sub57 = sub i32 %load_lval55, %div
  store i32 %sub57, i32* %even_fib_sum, align 4
  br label %merge44

cur65:                                            ; preds = %while.cond67
  %final_result = alloca i32, align 4
  store i32 0, i32* %final_result, align 4
  %load_lval89 = load i32, i32* %total_primes, align 4
  %load_lval90 = load i32, i32* %even_fib_sum, align 4
  %cmp91 = icmp sgt i32 %load_lval89, %load_lval90
  %zext_to_i3292 = zext i1 %cmp91 to i32
  %to_bool95 = icmp ne i32 %zext_to_i3292, 0
  br i1 %to_bool95, label %if.then93, label %if.else94

while.stmt66:                                     ; preds = %while.cond67
  %load_lval73 = load i32, i32* %factorial, align 4
  %load_lval74 = load i32, i32* %fact_counter, align 4
  %mul75 = mul i32 %load_lval73, %load_lval74
  store i32 %mul75, i32* %factorial, align 4
  %load_lval77 = load i32, i32* %fact_counter, align 4
  %mod78 = srem i32 %load_lval77, 2
  %cmp79 = icmp eq i32 %mod78, 0
  %zext_to_i3280 = zext i1 %cmp79 to i32
  %to_bool83 = icmp ne i32 %zext_to_i3280, 0
  br i1 %to_bool83, label %if.then81, label %if.else82

while.cond67:                                     ; preds = %merge76, %cur37
  %load_lval68 = load i32, i32* %fact_counter, align 4
  %cmp70 = icmp sle i32 %load_lval68, 5
  %zext_to_i3271 = zext i1 %cmp70 to i32
  %to_bool72 = icmp ne i32 %zext_to_i3271, 0
  br i1 %to_bool72, label %while.stmt66, label %cur65

merge76:                                          ; preds = %if.else82, %if.then81
  br label %while.cond67

if.then81:                                        ; preds = %while.stmt66
  %load_lval84 = load i32, i32* %fact_counter, align 4
  %add85 = add i32 %load_lval84, 2
  store i32 %add85, i32* %fact_counter, align 4
  br label %merge76

if.else82:                                        ; preds = %while.stmt66
  %load_lval86 = load i32, i32* %fact_counter, align 4
  %add87 = add i32 %load_lval86, 1
  store i32 %add87, i32* %fact_counter, align 4
  br label %merge76

merge88:                                          ; preds = %merge99, %if.then93
  br label %while.cond114

if.then93:                                        ; preds = %cur65
  %load_lval96 = load i32, i32* %factorial, align 4
  %load_lval97 = load i32, i32* %prime_counter, align 4
  %sub98 = sub i32 %load_lval96, %load_lval97
  store i32 %sub98, i32* %final_result, align 4
  br label %merge88

if.else94:                                        ; preds = %cur65
  %load_lval100 = load i32, i32* %total_primes, align 4
  %load_lval101 = load i32, i32* %even_fib_sum, align 4
  %cmp102 = icmp slt i32 %load_lval100, %load_lval101
  %zext_to_i32103 = zext i1 %cmp102 to i32
  %to_bool106 = icmp ne i32 %zext_to_i32103, 0
  br i1 %to_bool106, label %if.then104, label %if.else105

merge99:                                          ; preds = %if.else105, %if.then104
  br label %merge88

if.then104:                                       ; preds = %if.else94
  %load_lval107 = load i32, i32* %factorial, align 4
  %load_lval108 = load i32, i32* %prime_counter, align 4
  %add109 = add i32 %load_lval107, %load_lval108
  store i32 %add109, i32* %final_result, align 4
  br label %merge99

if.else105:                                       ; preds = %if.else94
  %load_lval110 = load i32, i32* %prime_counter, align 4
  %mul111 = mul i32 %load_lval110, 2
  store i32 %mul111, i32* %final_result, align 4
  br label %merge99

cur112:                                           ; preds = %while.cond114
  %load_lval141 = load i32, i32* %final_result, align 4
  ret i32 %load_lval141

while.stmt113:                                    ; preds = %while.cond114
  %load_lval120 = load i32, i32* %final_result, align 4
  %mod121 = srem i32 %load_lval120, 3
  %cmp122 = icmp eq i32 %mod121, 0
  %zext_to_i32123 = zext i1 %cmp122 to i32
  %to_bool126 = icmp ne i32 %zext_to_i32123, 0
  br i1 %to_bool126, label %if.then124, label %if.else125

while.cond114:                                    ; preds = %merge119, %merge88
  %load_lval115 = load i32, i32* %final_result, align 4
  %cmp116 = icmp sgt i32 %load_lval115, 0
  %zext_to_i32117 = zext i1 %cmp116 to i32
  %to_bool118 = icmp ne i32 %zext_to_i32117, 0
  br i1 %to_bool118, label %while.stmt113, label %cur112

merge119:                                         ; preds = %merge129, %if.then124
  br label %while.cond114

if.then124:                                       ; preds = %while.stmt113
  %load_lval127 = load i32, i32* %final_result, align 4
  %div128 = sdiv i32 %load_lval127, 2
  store i32 %div128, i32* %final_result, align 4
  br label %merge119

if.else125:                                       ; preds = %while.stmt113
  %load_lval130 = load i32, i32* %final_result, align 4
  %mod131 = srem i32 %load_lval130, 4
  %cmp132 = icmp eq i32 %mod131, 1
  %zext_to_i32133 = zext i1 %cmp132 to i32
  %to_bool136 = icmp ne i32 %zext_to_i32133, 0
  br i1 %to_bool136, label %if.then134, label %if.else135

merge129:                                         ; preds = %if.else135, %if.then134
  br label %merge119

if.then134:                                       ; preds = %if.else125
  %load_lval137 = load i32, i32* %final_result, align 4
  %sub138 = sub i32 %load_lval137, 5
  store i32 %sub138, i32* %final_result, align 4
  br label %merge129

if.else135:                                       ; preds = %if.else125
  %load_lval139 = load i32, i32* %final_result, align 4
  %sub140 = sub i32 %load_lval139, 1
  store i32 %sub140, i32* %final_result, align 4
  br label %merge129
}
