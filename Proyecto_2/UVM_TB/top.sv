import uvm_pkg::*;

module top();
  //---------------------------------------
  //clock signal declaration
  //---------------------------------------
  reg clk = 0;
  
  //---------------------------------------
  //clock generation
  //---------------------------------------
  initial 
  forever #5 clk = ~clk;
   
  //---------------------------------------
  //interface instance
  //---------------------------------------
  fpu_intf intf(clk);
  
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

  initial begin
    //enable wave dump
    $dumpfile("verilog.vcd");
    $dumpvars;
   
    uvm_config_db #(virtual fpu_intf)::set(null, "uvm_test_top", "VIRTUAL_INTERFACE", intf);
    run_test();	
 end
  
endmodule