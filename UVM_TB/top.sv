// ---- Compile options ----  
//-timescale=1ns/1ns +vcs+flush+all +warn=all -sverilog -ova_cov -cm line+cond+fsm+tgl+path+assert+branch+property_path -cm_pp -cm_report unencrypted_hierarchies+svpackages+noinitial -lca 

// ----   Run options  ----  
//-cm line+cond+fsm+tgl+path+assert+branch+property_path +UVM_TESTNAME=mem_wr_rd_test

//-------------------------------------------------------------------------
//				www.verificationguide.com   testbench.sv
//-------------------------------------------------------------------------
//---------------------------------------------------------------
//including interfcae and testcase files
`include "fpu_interface.sv"
`include "fpu_base_test.sv"
`include "fpu_wr_rd_test.sv"
//---------------------------------------------------------------

module tbench_top;

  //---------------------------------------
  //clock and reset signal declaration
  //---------------------------------------
  bit clk;
  
  //---------------------------------------
  //clock generation
  //---------------------------------------
  always #5 clk = ~clk;
  

  //---------------------------------------
  //interface instance
  //---------------------------------------
  fpu_if intf(clk);
  

  //---------------------------------------
  //DUT instance
  //---------------------------------------
  fpu dut (
    .clk(clk),
    .rmode(intf.rmode),
    .fpu_op(intf.fpu_op),
    .opa(intf.opa),
    .opb(intf.opb),
    .out(intf.out),
    .inf(intf.inf),
    .snan(intf.snan),
    .qnan(intf.qnan),
    .ine(intf.ine),
    .overflow(intf.overflow),
    .underflow(intf.underflow),
    .zero(intf.zero),
    .div_by_zero(intf.div_by_zero)
  );
  
  //---------------------------------------
  //passing the interface handle to lower heirarchy using set method 
  //and enabling the wave dump
  //---------------------------------------
  initial begin 
    uvm_config_db#(virtual fpu_if)::set(uvm_root::get(),"*","vif",intf);
    //enable wave dump
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
  //---------------------------------------
  //calling test
  //---------------------------------------
  initial begin 
    run_test();
  end
  
endmodule