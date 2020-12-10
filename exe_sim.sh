#!/bin/bash

mkdir test1
cd test1
vcs -R -sverilog -F ../filelist -debug_access+all -full64 -cm line+tgl+assert +plusarg_save -timescale=1ns/1ns +UVM_TESTNAME=test_basic +ntb_random_seed=5
cd ..

mkdir test2
cd test2
vcs -R -sverilog -F ../filelist -debug_access+all -full64 -cm line+tgl+assert +plusarg_save -timescale=1ns/1ns +UVM_TESTNAME=test_basic +ntb_random_seed=5
cd ..

mkdir test3
cd test3
vcs -R -sverilog -F ../filelist -debug_access+all -full64 -cm line+tgl+assert +plusarg_save -timescale=1ns/1ns +UVM_TESTNAME=test_basic +ntb_random_seed=5
cd ..

mkdir test4
cd test4
vcs -R -sverilog -F ../filelist -debug_access+all -full64 -cm line+tgl+assert +plusarg_save -timescale=1ns/1ns +UVM_TESTNAME=test_basic +ntb_random_seed=5
cd ..

mkdir test5
cd test5
vcs -R -sverilog -F ../filelist -debug_access+all -full64 -cm line+tgl+assert +plusarg_save -timescale=1ns/1ns +UVM_TESTNAME=test_basic +ntb_random_seed=5
cd ..

mkdir test6
cd test6
vcs -R -sverilog -F ../filelist -debug_access+all -full64 -cm line+tgl+assert +plusarg_save -timescale=1ns/1ns +UVM_TESTNAME=test_basic +ntb_random_seed=5
cd ..


