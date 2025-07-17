#   SysY编译器实现
## 编译器简介
源自于NJU软院编译原理作业，在此基础之上实现了函数调用(包括递归,数组作为参数等)、数组的实现，同时在前端与后端加入了相应的优化，可以编译出快速排序等有关算法的实现。前端通过ANTLR构建语法树，中间代码采用LLVM-IR，目标代码为riscv
## 运行方法
在release分支下可以直接运行
```cmd
make run SRCFILE=/path/to/inputfile OUTFILE=/path/to/outputfile
```
根据相应的.sysy文件生成.ll(中间代码)和.riscv(目标代码)
在test分支下可进行测试
## 编译器实现
### 编译器前端
采用ANTLR构建语法分析树,并进行了词法、语法、语义的分析，其中词法，语法在Main.java中实现，语义分析在SemanticVisitor.java中遍历语法树实现，同时在语义分析时，构建了符号表，具体实现在symbolTable.java。
### 中间代码生成
在IRGenerationVisitor.java通过遍历语法树实现。
### 中间代码优化
实现了常量传播算法、未使用变量消除，死代码消除等，同时由于加入了数组以及函数调用，导致实现难度上升。为此进行了简单的别名分析，主要包括may_analysis和must_analysis.
### 目标代码生成
采用图染色法进行寄存器分配，同样由于加入了数组，导致难度陡然提高。体现在由于LLVMIR访问数组时用的是GETELEMTPTR指令，相当于给了一个指针，需要把变量store进去，因此会出现不同指针指向相同变量的情况，因此在图染色法时还需要进行别名分析。之后根据中间代码生成riscv文件。



