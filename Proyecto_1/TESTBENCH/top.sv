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
  intf_cnt intf(clk);
  
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
    $dumpvars(0);
  end

  //Test case
  testcase test(intf);

endmodule
