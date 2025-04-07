; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 100
@y = global i32 2
@z = global i32 3

define void @g() {
gEntry:
  %load_lval = load i32, i32* @x, align 4
  %add = add i32 %load_lval, 1
  store i32 %add, i32* @x, align 4
  ret void
}

define i32 @f(i32 %x) {
fEntry:
  %sub = add i32 %x, -1
  %f = call i32 @f(i32 %sub)
  %add = add i32 %f, 10
  ret i32 %add
}

define i32 @main() {
mainEntry:
  br label %while.cond

while.cond:                                       ; preds = %merge49, %mainEntry
  %f = call i32 @f(i32 200)
  store i32 %f, i32* @x, align 4
  br label %while.cond3

cur1:                                             ; preds = %while.cond3
  br i1 false, label %merge12, label %merge6

while.stmt2:                                      ; preds = %while.cond3
  call void @g()
  %load_lval.pre = load i32, i32* @x, align 4
  br label %while.cond3

while.cond3:                                      ; preds = %while.stmt2, %while.cond
  %load_lval31 = phi i32 [ %load_lval.pre, %while.stmt2 ], [ %f, %while.cond ]
  %to_bool.not = icmp eq i32 %load_lval31, 0
  br i1 %to_bool.not, label %cur1, label %while.stmt2

merge6:                                           ; preds = %while.cond34.merge6_crit_edge, %cur1
  store i32 5000, i32* @x, align 4
  br i1 true, label %if.then53, label %merge6.merge49_crit_edge

merge6.merge49_crit_edge:                         ; preds = %merge6
  br label %merge49

merge12:                                          ; preds = %cur1
  %add = add i32 0, 1
  br label %while.cond34

while.stmt33:                                     ; preds = %while.cond34
  %add40 = add i32 %load_lval39, 1
  store i32 %add40, i32* @x, align 4
  call void @g()
  %load_lval47 = load i32, i32* @x, align 4
  %add48 = add i32 %load_lval47, 2
  br label %while.cond34

while.cond34:                                     ; preds = %while.stmt33, %merge12
  %load_lval39 = phi i32 [ %add, %merge12 ], [ %add48, %while.stmt33 ]
  store i32 %load_lval39, i32* @x, align 4
  %cmp36 = icmp slt i32 %load_lval39, 200
  br i1 %cmp36, label %while.stmt33, label %while.cond34.merge6_crit_edge

while.cond34.merge6_crit_edge:                    ; preds = %while.cond34
  br label %merge6

merge49:                                          ; preds = %merge55.merge49_crit_edge, %merge6.merge49_crit_edge, %if.then103
  br label %while.cond

if.then53:                                        ; preds = %merge6
  br i1 false, label %if.then53.while.cond64_crit_edge, label %if.else60

if.then53.while.cond64_crit_edge:                 ; preds = %if.then53
  br label %while.cond64

merge55:                                          ; preds = %cur62.merge55_crit_edge, %if.else89, %if.then95, %if.then88, %if.then81
  br i1 true, label %if.then103, label %merge55.merge49_crit_edge

merge55.merge49_crit_edge:                        ; preds = %merge55
  br label %merge49

if.else60:                                        ; preds = %if.then53
  br i1 false, label %if.then88, label %if.else89

cur62:                                            ; preds = %while.cond64
  %load_lval78 = load i32, i32* @x, align 4
  %cmp79 = icmp sgt i32 %load_lval78, 100
  br i1 %cmp79, label %if.then81, label %cur62.merge55_crit_edge

cur62.merge55_crit_edge:                          ; preds = %cur62
  br label %merge55

while.stmt63:                                     ; preds = %while.cond64
  %load_lval70 = load i32, i32* @x, align 4
  %to_bool73.not = icmp eq i32 %load_lval70, 0
  br i1 %to_bool73.not, label %if.else72, label %if.then71

while.cond64:                                     ; preds = %if.then53.while.cond64_crit_edge, %merge69
  %load_lval65 = load i32, i32* @x, align 4
  %cmp66 = icmp sgt i32 %load_lval65, 100
  br i1 %cmp66, label %while.stmt63, label %cur62

merge69:                                          ; preds = %if.else72, %if.then71
  %storemerge = phi i32 [ %sub76, %if.else72 ], [ %sub, %if.then71 ]
  store i32 %storemerge, i32* @x, align 4
  br label %while.cond64

if.then71:                                        ; preds = %while.stmt63
  %load_lval74 = load i32, i32* @x, align 4
  %sub = add i32 %load_lval74, -1
  br label %merge69

if.else72:                                        ; preds = %while.stmt63
  %load_lval75 = load i32, i32* @x, align 4
  %sub76 = add i32 %load_lval75, -2
  br label %merge69

if.then81:                                        ; preds = %cur62
  %load_lval83 = load i32, i32* @x, align 4
  ret i32 %load_lval83
  br label %merge55

if.then88:                                        ; preds = %if.else60
  store i32 5016, i32* @x, align 4
  br label %merge55

if.else89:                                        ; preds = %if.else60
  br i1 false, label %if.then95, label %merge55

if.then95:                                        ; preds = %if.else89
  %load_lval97 = load i32, i32* @x, align 4
  %add98 = add i32 %load_lval97, 1
  ret i32 %add98
  br label %merge55

if.then103:                                       ; preds = %merge55
  store i32 4990, i32* @x, align 4
  br label %merge49
}
