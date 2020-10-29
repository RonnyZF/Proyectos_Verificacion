`define DUV_PATH top.dut

module whitebox();

  //Inmediate assertion
  always_comb begin
    empty_0: assert (`DUV_PATH.empty && (`DUV_PATH.status_cnt == 0));
  end
  
  //Defered assertion
  always_comb begin
    empty_1: assert #0 (`DUV_PATH.empty && (`DUV_PATH.status_cnt == 0));
  end

  property empty_p_0;
    @(posedge `DUV_PATH.clk)
    disable iff (`DUV_PATH.rst)
    (`DUV_PATH.empty && (`DUV_PATH.status_cnt ==0)) == 1;
  endproperty

  property empty_p_1;
    @(posedge `DUV_PATH.clk)
    disable iff (`DUV_PATH.rst)
    $isunknown(`DUV_PATH.empty) == 0 |->
    $isunknown(`DUV_PATH.full) == 0 |->
    `DUV_PATH.status_cnt == 0 |->
    `DUV_PATH.empty == 1;
  endproperty

  assert_empty_p_0: assert property (empty_p_0) else $error ("Rule1.1 empty signals violated");

  assert_empty_p_1: assert property (empty_p_1) else $error ("Rule1.2 empty signals violated");

    assert_full: assert property ( @(posedge `DUV_PATH.clk) (`DUV_PATH.status_cnt == 09'hFF) |-> `DUV_PATH.full == 1) else $error ("full signals violated");
  
endmodule