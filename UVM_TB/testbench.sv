// ---- Compile options ----  
//-timescale=1ns/1ns +vcs+flush+all +warn=all -sverilog -ova_cov -cm line+cond+fsm+tgl+path+assert+branch+property_path -cm_pp -cm_report unencrypted_hierarchies+svpackages+noinitial -lca 

// ----   Run options  ----  
//-cm line+cond+fsm+tgl+path+assert+branch+property_path +UVM_TESTNAME=mem_wr_rd_test

//-------------------------------------------------------------------------
//				www.verificationguide.com   testbench.sv
//-------------------------------------------------------------------------
//---------------------------------------------------------------
//including interfcae and testcase files
`include "mem_interface.sv"
`include "mem_base_test.sv"
`include "mem_wr_rd_test.sv"
//---------------------------------------------------------------

module tbench_top;

  //---------------------------------------
  //clock and reset signal declaration
  //---------------------------------------
  bit clk;
  bit reset;
  wire  [15:0]	Data;
  
  //---------------------------------------
  //clock generation
  //---------------------------------------
  always #5 clk = ~clk;
  
  //---------------------------------------
  //reset Generation
  //---------------------------------------
  initial begin
    reset = 1;
    #5 reset =0;
  end
  
  //---------------------------------------
  //interface instance
  //---------------------------------------
  mem_if intf(clk,reset);
  
  assign intf.rdata = Data; // To read from inout net
  assign Data = ((intf.WE)&&(intf.CS))? 16'hz : intf.wdata; // To drive the inout net
  

  //---------------------------------------
  //DUT instance
  //---------------------------------------
  Ram_128B DUT (
    .Address(intf.Address),
    .Data(Data),
    .CS(intf.CS),
    .WE(intf.WE),
    .OE(intf.OE)
   );
  
  //---------------------------------------
  //passing the interface handle to lower heirarchy using set method 
  //and enabling the wave dump
  //---------------------------------------
  initial begin 
    uvm_config_db#(virtual mem_if)::set(uvm_root::get(),"*","vif",intf);
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