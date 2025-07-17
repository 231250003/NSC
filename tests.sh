#!/bin/bash

GENERATE_RISCV=1
SYSY_DIR="tests/develop_test"
SPECIFIC_FILE=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--file)
            SPECIFIC_FILE="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ -n "$SPECIFIC_FILE" ]]; then
    echo "== Processing specific file: $SPECIFIC_FILE =="
    FILE_LIST=("$SYSY_DIR/$SPECIFIC_FILE")
else
    echo "== Batch processing all .sysy files in $SYSY_DIR =="
    FILE_LIST=("$SYSY_DIR"/*.sysy)
fi

for sysy_file in "${FILE_LIST[@]}"; do
    filename=$(basename "$sysy_file" .sysy)
    c_file="$SYSY_DIR/$filename.c"
    exe_file="$SYSY_DIR/$filename"
    ll_file="$SYSY_DIR/$filename.ll"

    echo "------------------------------"
    echo "Processing: $filename.sysy"

    # Step 1: 模拟生成 .c 文件（如果你是从 sysy 到 c 的，可以替换这一步）
    cp "$sysy_file" "$c_file"

    # Step 2: 用 gcc 编译为可执行文件
    gcc "$c_file" -o "$exe_file"
    if [ $? -ne 0 ]; then
        echo "Compilation failed for $c_file"
        continue
    fi

    # Step 3: 运行可执行文件并获取返回值
    "$exe_file"
    c_return_value=$?
    echo "C Return value: $c_return_value"

    # Step 4: 用 make run 生成 .ll 文件
    #mvn -q compile exec:java -Dexec.args="$sysy_file $ll_file"
    mvn -q compile exec:java -Dexec.args="$sysy_file $ll_file"
    if [ $? -ne 0 ]; then
        echo "IR generation failed for $exe_file"
        continue
    fi

    # Step 5: 用 lli 运行 .ll 文件
    lli "$ll_file"
    ll_return_value=$?
    echo "LLVM IR Return value: $ll_return_value"

    # Step 6: 比较两个返回值
    if [ "$c_return_value" -eq "$ll_return_value" ]; then
        echo "✅ C vs LLVMIR Return values match."
    else
        echo "❌ C vs LLVMIR Return values differ!"
    fi
     #Step 7: 使用 RARS 运行 .riscv 汇编文件
    if [ "$GENERATE_RISCV" -eq 1 ]; then
      riscv_file="$SYSY_DIR/$filename.riscv"
        if [ -f "$riscv_file" ]; then
              echo "Running RARS on: $riscv_file"
              java -jar utils/rars.jar nc me "$riscv_file"
              riscv_return_value=$?
              echo "RISC-V Return value: $riscv_return_value"
              if [ "$c_return_value" -eq "$riscv_return_value" ]; then
                    echo "✅ C vs RISC-V return values match."
              else
                    echo "❌ C vs RISC-V return values differ!"
              fi
        else
              echo "RISC-V assembly file not found: $riscv_file"
        fi
    fi
done