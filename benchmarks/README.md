# Benchmarks

This directory contains the binary instruction-memory programs used by `instructmem.sv` and the CPU simulation testbenches.

Each `.arm` file is written in binary with underscores separating instruction fields for readability. The simulator loads the selected benchmark with `$readmemb`.

## Available benchmark categories

- `test01_AddiB.arm` — immediate arithmetic and unconditional branch
- `test02_AddsSubs.arm` — register arithmetic and ALU flags
- `test03_CbzB.arm` — conditional branches and branch timing
- `test04_LdurStur.arm` — load/store instructions and data memory
- `test05_Blt.arm` — signed less-than conditional branch
- `test06_BlBr.arm` — branch-with-link and register-indirect branch
- `test10_forwarding.arm` — forwarding, dependencies, memory, and branches
- `test11_Sort.arm` — bubble sort using loads, stores, loops, and conditions
- `test12_Fibonacci.arm` — recursive function calls using `BL`, `BR`, and stack memory

To select a benchmark, change the `BENCHMARK` definition near the top of `instructmem.sv` and make sure the filename matches exactly.

The `.bak` files are retained as historical backup copies from the original course project.
