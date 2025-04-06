; ModuleID = 'my_module'
source_filename = "my_module"

@x = global i32 1
@y = global i32 2
@z = global i32 3
@counter = global i32 0

define i32 @mul(i32 %a, i32 %b) {
mulEntry:
  %param0_addr = alloca i32, align 4
  store i32 %a, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %b, i32* %param1_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %cmp = icmp eq i32 %load_lval, 0
  %zext_to_i32 = zext i1 %cmp to i32
  %lhs_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %lhs_bool, label %or.merge, label %or.rhs

merge:                                            ; preds = %if.then, %or.merge
  %load_lval5 = load i32, i32* %param0_addr, align 4
  %load_lval6 = load i32, i32* %param1_addr, align 4
  %mul = mul i32 %load_lval5, %load_lval6
  ret i32 %mul

or.rhs:                                           ; preds = %mulEntry
  %load_lval1 = load i32, i32* %param1_addr, align 4
  %cmp2 = icmp eq i32 %load_lval1, 0
  %zext_to_i323 = zext i1 %cmp2 to i32
  %rhs_bool = icmp ne i32 %zext_to_i323, 0
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %mulEntry
  %or_result = phi i1 [ true, %mulEntry ], [ %rhs_bool, %or.rhs ]
  %zext_to_i324 = zext i1 %or_result to i32
  %to_bool = icmp ne i32 %zext_to_i324, 0
  br i1 %to_bool, label %if.then, label %merge

if.then:                                          ; preds = %or.merge
  ret i32 0
  br label %merge
}

define i32 @max(i32 %a, i32 %b) {
maxEntry:
  %param0_addr = alloca i32, align 4
  store i32 %a, i32* %param0_addr, align 4
  %param1_addr = alloca i32, align 4
  store i32 %b, i32* %param1_addr, align 4
  %load_lval = load i32, i32* %param0_addr, align 4
  %load_lval1 = load i32, i32* %param1_addr, align 4
  %cmp = icmp sgt i32 %load_lval, %load_lval1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %if.then, label %if.else

merge:                                            ; preds = %if.else, %if.then

if.then:                                          ; preds = %maxEntry
  %load_lval2 = load i32, i32* %param0_addr, align 4
  ret i32 %load_lval2
  br label %merge

if.else:                                          ; preds = %maxEntry
  %load_lval3 = load i32, i32* %param1_addr, align 4
  ret i32 %load_lval3
  br label %merge
}

define void @logSum(i32 %val) {
logSumEntry:
  %param0_addr = alloca i32, align 4
  store i32 %val, i32* %param0_addr, align 4
  %t = alloca i32, align 4
  store i32 0, i32* %t, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  ret void

while.stmt:                                       ; preds = %while.cond
  %load_lval2 = load i32, i32* %t, align 4
  %add = add i32 %load_lval2, 1
  store i32 %add, i32* %t, align 4
  %load_lval3 = load i32, i32* @counter, align 4
  %add4 = add i32 %load_lval3, 1
  store i32 %add4, i32* @counter, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.stmt, %logSumEntry
  %load_lval = load i32, i32* %t, align 4
  %load_lval1 = load i32, i32* %param0_addr, align 4
  %cmp = icmp slt i32 %load_lval, %load_lval1
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur
}

define i32 @main() {
mainEntry:
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %j = alloca i32, align 4
  store i32 0, i32* %j, align 4
  %sum = alloca i32, align 4
  store i32 0, i32* %sum, align 4
  %x = alloca i32, align 4
  store i32 5, i32* %x, align 4
  br label %while.cond

cur:                                              ; preds = %while.cond
  %k = alloca i32, align 4
  store i32 0, i32* %k, align 4
  br label %while.cond76

while.stmt:                                       ; preds = %while.cond
  %x1 = alloca i32, align 4
  %load_lval2 = load i32, i32* %i, align 4
  store i32 %load_lval2, i32* %x1, align 4
  br label %while.cond5

while.cond:                                       ; preds = %cur3, %mainEntry
  %load_lval = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %load_lval, 3
  %zext_to_i32 = zext i1 %cmp to i32
  %to_bool = icmp ne i32 %zext_to_i32, 0
  br i1 %to_bool, label %while.stmt, label %cur

cur3:                                             ; preds = %if.then68, %while.cond5
  store i32 0, i32* %j, align 4
  %load_lval72 = load i32, i32* %i, align 4
  %add73 = add i32 %load_lval72, 1
  store i32 %add73, i32* %i, align 4
  br label %while.cond

while.stmt4:                                      ; preds = %while.cond5
  %load_lval10 = load i32, i32* %x1, align 4
  %load_lval11 = load i32, i32* %j, align 4
  %add = add i32 %load_lval10, %load_lval11
  %mod = srem i32 %add, 2
  %cmp12 = icmp eq i32 %mod, 0
  %zext_to_i3213 = zext i1 %cmp12 to i32
  %lhs_bool = icmp ne i32 %zext_to_i3213, 0
  br i1 %lhs_bool, label %and.rhs, label %and.merge

while.cond5:                                      ; preds = %merge42, %while.stmt
  %load_lval6 = load i32, i32* %j, align 4
  %cmp7 = icmp slt i32 %load_lval6, 4
  %zext_to_i328 = zext i1 %cmp7 to i32
  %to_bool9 = icmp ne i32 %zext_to_i328, 0
  br i1 %to_bool9, label %while.stmt4, label %cur3

merge:                                            ; preds = %merge25, %if.then
  %load_lval43 = load i32, i32* %i, align 4
  %load_lval44 = load i32, i32* %j, align 4
  %add45 = add i32 %load_lval43, %load_lval44
  %cmp46 = icmp sgt i32 %add45, 3
  %zext_to_i3247 = zext i1 %cmp46 to i32
  %lhs_bool48 = icmp ne i32 %zext_to_i3247, 0
  br i1 %lhs_bool48, label %and.rhs49, label %and.merge50

and.rhs:                                          ; preds = %while.stmt4
  %load_lval14 = load i32, i32* %i, align 4
  %not = icmp eq i32 %load_lval14, 0
  %zext_to_i3215 = zext i1 %not to i32
  %load_lval16 = load i32, i32* %j, align 4
  %cmp17 = icmp eq i32 %zext_to_i3215, %load_lval16
  %zext_to_i3218 = zext i1 %cmp17 to i32
  %rhs_bool = icmp ne i32 %zext_to_i3218, 0
  br label %and.merge

and.merge:                                        ; preds = %and.rhs, %while.stmt4
  %and_result = phi i1 [ false, %while.stmt4 ], [ %rhs_bool, %and.rhs ]
  %zext_to_i3219 = zext i1 %and_result to i32
  %to_bool20 = icmp ne i32 %zext_to_i3219, 0
  br i1 %to_bool20, label %if.then, label %if.else

if.then:                                          ; preds = %and.merge
  %load_lval21 = load i32, i32* %sum, align 4
  %load_lval22 = load i32, i32* %i, align 4
  %load_lval23 = load i32, i32* %j, align 4
  %mul = call i32 @mul(i32 %load_lval22, i32 %load_lval23)
  %add24 = add i32 %load_lval21, %mul
  store i32 %add24, i32* %sum, align 4
  br label %merge

if.else:                                          ; preds = %and.merge
  %load_lval26 = load i32, i32* %x1, align 4
  %load_lval27 = load i32, i32* %j, align 4
  %cmp28 = icmp ne i32 %load_lval26, %load_lval27
  %zext_to_i3229 = zext i1 %cmp28 to i32
  %lhs_bool30 = icmp ne i32 %zext_to_i3229, 0
  br i1 %lhs_bool30, label %or.merge, label %or.rhs

merge25:                                          ; preds = %if.else37, %if.then36
  br label %merge

or.rhs:                                           ; preds = %if.else
  %load_lval31 = load i32, i32* %i, align 4
  %cmp32 = icmp eq i32 %load_lval31, 0
  %zext_to_i3233 = zext i1 %cmp32 to i32
  %rhs_bool34 = icmp ne i32 %zext_to_i3233, 0
  br label %or.merge

or.merge:                                         ; preds = %or.rhs, %if.else
  %or_result = phi i1 [ true, %if.else ], [ %rhs_bool34, %or.rhs ]
  %zext_to_i3235 = zext i1 %or_result to i32
  %to_bool38 = icmp ne i32 %zext_to_i3235, 0
  br i1 %to_bool38, label %if.then36, label %if.else37

if.then36:                                        ; preds = %or.merge
  %load_lval39 = load i32, i32* %sum, align 4
  %sub = sub i32 %load_lval39, 1
  store i32 %sub, i32* %sum, align 4
  br label %merge25

if.else37:                                        ; preds = %or.merge
  %load_lval40 = load i32, i32* %sum, align 4
  %add41 = add i32 %load_lval40, 1
  store i32 %add41, i32* %sum, align 4
  br label %merge25

merge42:                                          ; preds = %if.then68, %or.merge61
  %load_lval70 = load i32, i32* %j, align 4
  %add71 = add i32 %load_lval70, 1
  store i32 %add71, i32* %j, align 4
  br label %while.cond5

and.rhs49:                                        ; preds = %merge
  %load_lval51 = load i32, i32* %i, align 4
  %load_lval52 = load i32, i32* %j, align 4
  %mul53 = mul i32 %load_lval51, %load_lval52
  %cmp54 = icmp slt i32 %mul53, 6
  %zext_to_i3255 = zext i1 %cmp54 to i32
  %rhs_bool56 = icmp ne i32 %zext_to_i3255, 0
  br label %and.merge50

and.merge50:                                      ; preds = %and.rhs49, %merge
  %and_result57 = phi i1 [ false, %merge ], [ %rhs_bool56, %and.rhs49 ]
  %zext_to_i3258 = zext i1 %and_result57 to i32
  %lhs_bool59 = icmp ne i32 %zext_to_i3258, 0
  br i1 %lhs_bool59, label %or.merge61, label %or.rhs60

or.rhs60:                                         ; preds = %and.merge50
  %load_lval62 = load i32, i32* %x1, align 4
  %cmp63 = icmp sge i32 %load_lval62, 2
  %zext_to_i3264 = zext i1 %cmp63 to i32
  %rhs_bool65 = icmp ne i32 %zext_to_i3264, 0
  br label %or.merge61

or.merge61:                                       ; preds = %or.rhs60, %and.merge50
  %or_result66 = phi i1 [ true, %and.merge50 ], [ %rhs_bool65, %or.rhs60 ]
  %zext_to_i3267 = zext i1 %or_result66 to i32
  %to_bool69 = icmp ne i32 %zext_to_i3267, 0
  br i1 %to_bool69, label %if.then68, label %merge42

if.then68:                                        ; preds = %or.merge61
  br label %cur3
  br label %merge42

cur74:                                            ; preds = %while.cond76
  %m = alloca i32, align 4
  store i32 0, i32* %m, align 4
  br label %while.cond127

while.stmt75:                                     ; preds = %while.cond76
  %load_lval82 = load i32, i32* %k, align 4
  %mod83 = srem i32 %load_lval82, 2
  %cmp84 = icmp eq i32 %mod83, 0
  %zext_to_i3285 = zext i1 %cmp84 to i32
  %lhs_bool86 = icmp ne i32 %zext_to_i3285, 0
  br i1 %lhs_bool86, label %and.rhs87, label %and.merge88

while.cond76:                                     ; preds = %merge81, %cur
  %load_lval77 = load i32, i32* %k, align 4
  %cmp78 = icmp slt i32 %load_lval77, 5
  %zext_to_i3279 = zext i1 %cmp78 to i32
  %to_bool80 = icmp ne i32 %zext_to_i3279, 0
  br i1 %to_bool80, label %while.stmt75, label %cur74

merge81:                                          ; preds = %merge99, %if.then95
  %load_lval123 = load i32, i32* %k, align 4
  %add124 = add i32 %load_lval123, 1
  store i32 %add124, i32* %k, align 4
  br label %while.cond76

and.rhs87:                                        ; preds = %while.stmt75
  %load_lval89 = load i32, i32* @counter, align 4
  %cmp90 = icmp slt i32 %load_lval89, 20
  %zext_to_i3291 = zext i1 %cmp90 to i32
  %rhs_bool92 = icmp ne i32 %zext_to_i3291, 0
  br label %and.merge88

and.merge88:                                      ; preds = %and.rhs87, %while.stmt75
  %and_result93 = phi i1 [ false, %while.stmt75 ], [ %rhs_bool92, %and.rhs87 ]
  %zext_to_i3294 = zext i1 %and_result93 to i32
  %to_bool97 = icmp ne i32 %zext_to_i3294, 0
  br i1 %to_bool97, label %if.then95, label %if.else96

if.then95:                                        ; preds = %and.merge88
  %load_lval98 = load i32, i32* %k, align 4
  call void @logSum(i32 %load_lval98)
  br label %merge81

if.else96:                                        ; preds = %and.merge88
  %load_lval100 = load i32, i32* %k, align 4
  %mul101 = mul i32 %load_lval100, 2
  %cmp102 = icmp eq i32 %mul101, 4
  %zext_to_i32103 = zext i1 %cmp102 to i32
  %lhs_bool104 = icmp ne i32 %zext_to_i32103, 0
  br i1 %lhs_bool104, label %or.merge106, label %or.rhs105

merge99:                                          ; preds = %if.else116, %if.then115
  br label %merge81

or.rhs105:                                        ; preds = %if.else96
  %load_lval107 = load i32, i32* %sum, align 4
  %not108 = icmp eq i32 %load_lval107, 0
  %zext_to_i32109 = zext i1 %not108 to i32
  %cmp110 = icmp sgt i32 %zext_to_i32109, 100
  %zext_to_i32111 = zext i1 %cmp110 to i32
  %rhs_bool112 = icmp ne i32 %zext_to_i32111, 0
  br label %or.merge106

or.merge106:                                      ; preds = %or.rhs105, %if.else96
  %or_result113 = phi i1 [ true, %if.else96 ], [ %rhs_bool112, %or.rhs105 ]
  %zext_to_i32114 = zext i1 %or_result113 to i32
  %to_bool117 = icmp ne i32 %zext_to_i32114, 0
  br i1 %to_bool117, label %if.then115, label %if.else116

if.then115:                                       ; preds = %or.merge106
  %load_lval118 = load i32, i32* @counter, align 4
  %add119 = add i32 %load_lval118, 1
  store i32 %add119, i32* @counter, align 4
  br label %merge99

if.else116:                                       ; preds = %or.merge106
  %load_lval120 = load i32, i32* @counter, align 4
  %load_lval121 = load i32, i32* %k, align 4
  %add122 = add i32 %load_lval120, %load_lval121
  store i32 %add122, i32* @counter, align 4
  br label %merge99

cur125:                                           ; preds = %while.cond127
  %load_lval178 = load i32, i32* @counter, align 4
  ret i32 %load_lval178

while.stmt126:                                    ; preds = %while.cond127
  %n = alloca i32, align 4
  store i32 0, i32* %n, align 4
  br label %while.cond134

while.cond127:                                    ; preds = %cur132, %cur74
  %load_lval128 = load i32, i32* %m, align 4
  %cmp129 = icmp slt i32 %load_lval128, 3
  %zext_to_i32130 = zext i1 %cmp129 to i32
  %to_bool131 = icmp ne i32 %zext_to_i32130, 0
  br i1 %to_bool131, label %while.stmt126, label %cur125

cur132:                                           ; preds = %while.cond134
  %load_lval176 = load i32, i32* %m, align 4
  %add177 = add i32 %load_lval176, 1
  store i32 %add177, i32* %m, align 4
  br label %while.cond127

while.stmt133:                                    ; preds = %while.cond134
  %p = alloca i32, align 4
  store i32 0, i32* %p, align 4
  br label %while.cond141

while.cond134:                                    ; preds = %cur139, %while.stmt126
  %load_lval135 = load i32, i32* %n, align 4
  %cmp136 = icmp slt i32 %load_lval135, 3
  %zext_to_i32137 = zext i1 %cmp136 to i32
  %to_bool138 = icmp ne i32 %zext_to_i32137, 0
  br i1 %to_bool138, label %while.stmt133, label %cur132

cur139:                                           ; preds = %while.cond141
  %load_lval174 = load i32, i32* %n, align 4
  %add175 = add i32 %load_lval174, 1
  store i32 %add175, i32* %n, align 4
  br label %while.cond134

while.stmt140:                                    ; preds = %while.cond141
  %load_lval147 = load i32, i32* %m, align 4
  %load_lval148 = load i32, i32* %n, align 4
  %cmp149 = icmp eq i32 %load_lval147, %load_lval148
  %zext_to_i32150 = zext i1 %cmp149 to i32
  %lhs_bool151 = icmp ne i32 %zext_to_i32150, 0
  br i1 %lhs_bool151, label %and.rhs152, label %and.merge153

while.cond141:                                    ; preds = %merge146, %while.stmt133
  %load_lval142 = load i32, i32* %p, align 4
  %cmp143 = icmp slt i32 %load_lval142, 2
  %zext_to_i32144 = zext i1 %cmp143 to i32
  %to_bool145 = icmp ne i32 %zext_to_i32144, 0
  br i1 %to_bool145, label %while.stmt140, label %cur139

merge146:                                         ; preds = %if.then161, %and.merge153
  %load_lval168 = load i32, i32* %sum, align 4
  %add169 = add i32 %load_lval168, 1
  store i32 %add169, i32* %sum, align 4
  %load_lval170 = load i32, i32* %sum, align 4
  %sub171 = sub i32 %load_lval170, 1
  store i32 %sub171, i32* %sum, align 4
  %load_lval172 = load i32, i32* %p, align 4
  %add173 = add i32 %load_lval172, 1
  store i32 %add173, i32* %p, align 4
  br label %while.cond141

and.rhs152:                                       ; preds = %while.stmt140
  %load_lval154 = load i32, i32* %n, align 4
  %load_lval155 = load i32, i32* %p, align 4
  %cmp156 = icmp eq i32 %load_lval154, %load_lval155
  %zext_to_i32157 = zext i1 %cmp156 to i32
  %rhs_bool158 = icmp ne i32 %zext_to_i32157, 0
  br label %and.merge153

and.merge153:                                     ; preds = %and.rhs152, %while.stmt140
  %and_result159 = phi i1 [ false, %while.stmt140 ], [ %rhs_bool158, %and.rhs152 ]
  %zext_to_i32160 = zext i1 %and_result159 to i32
  %to_bool162 = icmp ne i32 %zext_to_i32160, 0
  br i1 %to_bool162, label %if.then161, label %merge146

if.then161:                                       ; preds = %and.merge153
  %load_lval163 = load i32, i32* %m, align 4
  %load_lval164 = load i32, i32* %n, align 4
  %add165 = add i32 %load_lval163, %load_lval164
  %load_lval166 = load i32, i32* %p, align 4
  %add167 = add i32 %add165, %load_lval166
  br label %merge146
}
