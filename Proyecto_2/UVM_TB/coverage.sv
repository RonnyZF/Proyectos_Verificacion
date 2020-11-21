class funct_coverage;

  virtual intf_cnt intf;
  
  covergroup cov0 @(intf.clk);
    Feature_rmode: coverpoint intf.rmode;
    Feature_fpu_op: coverpoint intf.fpu_op;
    Feature_inf: coverpoint intf.inf;
    Feature_snan: coverpoint intf.snan;
    Feature_qnan: coverpoint intf.qnan;
    Feature_ine: coverpoint intf.ine;
    Feature_overflow: coverpoint intf.overflow;
    Feature_underflow: coverpoint intf.underflow;
    Feature_zero: coverpoint intf.zero;
    Feature_div_by_zero: coverpoint intf.div_by_zero;
    Feature_opa: coverpoint intf.opa {option.auto_bin_max=8;}
    Feature_opb: coverpoint intf.opb {option.auto_bin_max=8;}
    Feature_out: coverpoint intf.out {option.auto_bin_max=8;}
    Feature_empty_seq: coverpoint intf.zero {bins seq = (0=>1=>0);}
    Feature_full_seq: coverpoint intf.overflow {bins seq = (0=>1=>0);}
  endgroup

  covergroup covFPU_Op @(intf.clk);
  	coverpoint intf.fpu_op{
  		bins t1 = (3'b000 => 3'b001), (3'b000 => 3'b010), (3'b000 => 3'b011);
  		bins t2 = (3'b001 => 3'b000), (3'b001 => 3'b010), (3'b001 => 3'b011);
  		bins t3 = (3'b010 => 3'b000), (3'b010 => 3'b001), (3'b010 => 3'b011);
  		bins t4 = (3'b011 => 3'b000), (3'b011 => 3'b001), (3'b011 => 3'b010);
  	}
  endgroup 

  covergroup crossCov_op_rmode @(intf.clk);
  	fpu_op: coverpoint intf.fpu_op
  	{bins fpu_op0 = {0};
  	bins fpu_op1 = {1};
  	bins fpu_op2 = {2};
  	bins fpu_op3 = {3};
  	}
    rmode: coverpoint intf.rmode
    {bins rmode0 = {0};
    bins rmode1 = {1};
    bins rmode2 = {2};
    bins rmode3 = {3};
  	}
    cross_op_rmode : cross fpu_op, rmode;
  endgroup

  covergroup crossCov_op_overflow @(intf.clk);
  	fpu_op: coverpoint intf.fpu_op
  	{bins fpu_op0 = {0};
  	bins fpu_op1 = {1};
  	bins fpu_op2 = {2};
  	bins fpu_op3 = {3};
  	}
    overflow: coverpoint intf.overflow
    {bins overflow0 = {0};
  	bins overflow1 = {1};
  	}
    cross_op_overflow : cross fpu_op, overflow;
  endgroup

  covergroup crossCov_op_underflow @(intf.clk);
  	fpu_op: coverpoint intf.fpu_op
  	{bins fpu_op0 = {0};
  	bins fpu_op1 = {1};
  	bins fpu_op2 = {2};
  	bins fpu_op3 = {3};
  	}
    underflow: coverpoint intf.underflow
    {bins underflow0 = {0};
  	bins underflow1 = {1};
  	}
    cross_op_underflow : cross fpu_op, underflow;
  endgroup

  covergroup crossCov_op_snan @(intf.clk);
  	fpu_op: coverpoint intf.fpu_op
  	{bins fpu_op0 = {0};
  	bins fpu_op1 = {1};
  	bins fpu_op2 = {2};
  	bins fpu_op3 = {3};
  	}
    snan: coverpoint intf.snan
    {bins snan0 = {0};
  	bins snan1 = {1};
  	}
    cross_op_snan : cross fpu_op, snan;
  endgroup

  covergroup crossCov_op_qnan @(intf.clk);
  	fpu_op: coverpoint intf.fpu_op
  	{bins fpu_op0 = {0};
  	bins fpu_op1 = {1};
  	bins fpu_op2 = {2};
  	bins fpu_op3 = {3};
  	}
    qnan: coverpoint intf.qnan
    {bins qnan0 = {0};
  	bins qnan1 = {1};
  	}
    cross_op_qnan : cross fpu_op, qnan;
  endgroup

  covergroup crossCov_op_ine @(intf.clk);
  	fpu_op: coverpoint intf.fpu_op
  	{bins fpu_op0 = {0};
  	bins fpu_op1 = {1};
  	bins fpu_op2 = {2};
  	bins fpu_op3 = {3};
  	}
    ine: coverpoint intf.ine
    {bins ine0 = {0};
  	bins ine1 = {1};
  	}
    cross_op_ine : cross fpu_op, ine;
  endgroup

  covergroup crossCov_op_inf @(intf.clk);
  	fpu_op: coverpoint intf.fpu_op
  	{bins fpu_op0 = {0};
  	bins fpu_op1 = {1};
  	bins fpu_op2 = {2};
  	bins fpu_op3 = {3};
  	}
    inf: coverpoint intf.inf
    {bins inf0 = {0};
  	bins inf1 = {1};
  	}
    cross_op_inf : cross fpu_op, inf;
  endgroup


  function new(virtual intf_cnt intf);
    this.intf =intf;
    cov0 =new();
    covFPU_Op =new();
    crossCov_op_rmode =new();
    crossCov_op_overflow =new();
    crossCov_op_underflow =new(); 
    crossCov_op_snan =new();
    crossCov_op_qnan =new();
    crossCov_op_ine =new();
    crossCov_op_inf =new();
  endfunction
  	


endclass