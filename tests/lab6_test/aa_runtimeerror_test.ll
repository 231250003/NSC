; ModuleID = 'my_module'
source_filename = "my_module"

define i32 @main() {
mainEntry:
  %j = alloca i32, align 4
  store i32 10, i32* %j, align 4
  %n = alloca i32, align 4
  store i32 14, i32* %n, align 4
  %r = alloca i32, align 4
  store i32 18, i32* %r, align 4
  %v = alloca i32, align 4
  store i32 22, i32* %v, align 4
  %z = alloca i32, align 4
  store i32 26, i32* %z, align 4
  %tmp = alloca i32, align 4
  store i32 64, i32* %tmp, align 4
  %count = alloca i32, align 4
  store i32 0, i32* %count, align 4
  br label %while.cond

cur:                                              ; preds = %if.then43, %while.cond
  %load_lval72 = load i32, i32* %tmp, align 4
  %load_lval73 = load i32, i32* %z, align 4
  %add74 = add i32 %load_lval72, %load_lval73
  ret i32 %add74

while.stmt:                                       ; preds = %while.cond
  store i32 5, i32* %tmp, align 4
  %load_lval7 = load i32, i32* %tmp, align 4
  %cmp8 = icmp sgt i32 %load_lval7, 50
  %zext_to_i329 = zext i1 %cmp8 to i32
  %to_bool10 = icmp ne i32 %zext_to_i329, 0
  br i1 %to_bool10, label %if.then, label %if.else

while.cond:                                       ; preds = %merge, %if.then56, %mainEntry
  %load_lval = load i32, i32* %count, align 4
  %cmp = icmp slt i32 %load_lval, 8
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

merge:                                            ; preds = %merge52, %merge18
  %load_lval63 = load i32, i32* %z, align 4
  %add64 = add i32 2, %load_lval63
  store i32 %add64, i32* %v, align 4
  %load_lval65 = load i32, i32* %v, align 4
  %div66 = sdiv i32 %load_lval65, 2
  %load_lval67 = load i32, i32* %count, align 4
  %mod68 = srem i32 %load_lval67, 3
  %mul69 = mul i32 %div66, %mod68
  store i32 %mul69, i32* %z, align 4
  %load_lval70 = load i32, i32* %count, align 4
  %add71 = add i32 %load_lval70, 1
  store i32 %add71, i32* %count, align 4
  br label %while.cond

if.then:                                          ; preds = %while.stmt
  %load_lval11 = load i32, i32* %tmp, align 4
  %mul15 = mul i32 %load_lval11, 15
  %div17 = sdiv i32 %mul15, 9
  store i32 %div17, i32* %tmp, align 4
  %load_lval19 = load i32, i32* %tmp, align 4
  %cmp20 = icmp slt i32 %load_lval19, 100
  %zext_to_i3221 = zext i1 %cmp20 to i32
  %to_bool24 = icmp ne i32 %zext_to_i3221, 0
  br i1 %to_bool24, label %if.then22, label %if.else23

if.else:                                          ; preds = %while.stmt
  %load_lval45 = load i32, i32* %r, align 4
  %add51 = add i32 %load_lval45, -21
  store i32 %add51, i32* %r, align 4
  %load_lval53 = load i32, i32* %r, align 4
  %cmp54 = icmp sgt i32 %load_lval53, 200
  %zext_to_i3255 = zext i1 %cmp54 to i32
  %to_bool57 = icmp ne i32 %zext_to_i3255, 0
  br i1 %to_bool57, label %if.then56, label %merge52

merge18:                                          ; preds = %merge39, %if.then22
  br label %merge

if.then22:                                        ; preds = %if.then
  %load_lval25 = load i32, i32* %j, align 4
  %add31 = add i32 %load_lval25, 2
  store i32 %add31, i32* %j, align 4
  br label %merge18

if.else23:                                        ; preds = %if.then
  %load_lval32 = load i32, i32* %n, align 4
  %sub38 = sub i32 %load_lval32, 14
  store i32 %sub38, i32* %n, align 4
  %load_lval40 = load i32, i32* %n, align 4
  %cmp41 = icmp slt i32 %load_lval40, 0
  %zext_to_i3242 = zext i1 %cmp41 to i32
  %to_bool44 = icmp ne i32 %zext_to_i3242, 0
  br i1 %to_bool44, label %if.then43, label %merge39

merge39:                                          ; preds = %if.then43, %if.else23
  br label %merge18

if.then43:                                        ; preds = %if.else23
  br label %cur
  br label %merge39

merge52:                                          ; preds = %if.then56, %if.else
  br label %merge

if.then56:                                        ; preds = %if.else
  br label %while.cond
  br label %merge52
}
