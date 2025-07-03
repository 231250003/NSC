#!/bin/bash

GENERATE_RISCV=0
SYSY_DIR="tests/develop_test"
ll_file="$SYSY_DIR/$filename.ll"
echo "== Batch processing all .sysy files in $SYSY_DIR =="
for sysy_file in "$SYSY_DIR"/*.sysy; do
    make -s run SRCFILE="$sysy_file" OUTFILE="$ll_file"
done