`define DUV_PATH top.dut

module whitebox();

  //Inmediate assertion
  always_comb begin
    assert_test_0: assert (`DUV_PATH.overflow != `DUV_PATH.underflow );
  end
  //Inmediate assertion
  always_comb begin
    assert_1: assert ((`DUV_PATH.opb == 0) && (`DUV_PATH.fpu_op == 3) && (`DUV_PATH.div_by_zero == 1) );
    //else
    //  $error("error en: div_by_zero, valor diferente a 1");
  end

  property empty_p_0;
    @(posedge `DUV_PATH.clk)
    disable iff ($isunknown(`DUV_PATH.out))
    (`DUV_PATH.overflow != `DUV_PATH.underflow ) == 1;
  endproperty

  assert_empty_p_0: assert property (empty_p_0) else $error ("Rule1.1 empty signals violated");
  
endmodule


  