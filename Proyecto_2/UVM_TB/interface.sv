interface fpu_intf(input clk);
  
  //---------------------------------------
  //declaring the signals
  //---------------------------------------
  logic [1:0] rmode;
  logic [2:0] fpu_op;
  logic [31:0] opa;
  logic [31:0] opb;
  logic [31:0] out;
  logic inf;
  logic snan;
  logic qnan;
  logic ine; 
  logic overflow; 
  logic underflow; 
  logic zero; 
  logic div_by_zero; 

covergroup cov0 @(clk);
    Feature_rmode: coverpoint rmode;
    Feature_fpu_op: coverpoint intf.fpu_op{
    bins fpu_op0 = {0};
  	bins fpu_op1 = {1};
  	bins fpu_op2 = {2};
  	bins fpu_op3 = {3};
  	bins fpu_op_misc = default;
  	}
    Feature_inf: coverpoint inf;
    Feature_snan: coverpoint snan;
    Feature_qnan: coverpoint qnan;
    Feature_ine: coverpoint ine;
    Feature_overflow: coverpoint overflow;
    Feature_underflow: coverpoint underflow;
    Feature_zero: coverpoint zero;
    Feature_div_by_zero: coverpoint div_by_zero;
    Feature_opa: coverpoint opa {option.auto_bin_max=1024;}
    Feature_opb: coverpoint opb {option.auto_bin_max=1024;}
    Feature_out: coverpoint out {option.auto_bin_max=1024;}
  endgroup

  covergroup covFPU_Op @(clk);
    coverpoint fpu_op{
      bins t1 = (3'b000 => 3'b001), (3'b000 => 3'b010), (3'b000 => 3'b011);
      bins t2 = (3'b001 => 3'b000), (3'b001 => 3'b010), (3'b001 => 3'b011);
      bins t3 = (3'b010 => 3'b000), (3'b010 => 3'b001), (3'b010 => 3'b011);
      bins t4 = (3'b011 => 3'b000), (3'b011 => 3'b001), (3'b011 => 3'b010);
    }
  endgroup 

  covergroup crossCov_op_rmode @(clk);
    fpu_op: coverpoint fpu_op
    {bins fpu_op0 = {0};
    bins fpu_op1 = {1};
    bins fpu_op2 = {2};
    bins fpu_op3 = {3};
    }
    rmode: coverpoint rmode
    {bins rmode0 = {0};
    bins rmode1 = {1};
    bins rmode2 = {2};
    bins rmode3 = {3};
    }
    cross_op_rmode : cross fpu_op, rmode;
  endgroup

  covergroup crossCov_op_overflow @(clk);
    fpu_op: coverpoint fpu_op
    {bins fpu_op0 = {0};
    bins fpu_op1 = {1};
    bins fpu_op2 = {2};
    bins fpu_op3 = {3};
    }
    overflow: coverpoint overflow
    {bins overflow0 = {0};
    bins overflow1 = {1};
    }
    cross_op_overflow : cross fpu_op, overflow;
  endgroup

  covergroup crossCov_op_underflow @(clk);
    fpu_op: coverpoint fpu_op
    {bins fpu_op0 = {0};
    bins fpu_op1 = {1};
    bins fpu_op2 = {2};
    bins fpu_op3 = {3};
    }
    underflow: coverpoint underflow
    {bins underflow0 = {0};
    bins underflow1 = {1};
    }
    cross_op_underflow : cross fpu_op, underflow;
  endgroup

  covergroup crossCov_op_snan @(clk);
    fpu_op: coverpoint fpu_op
    {bins fpu_op0 = {0};
    bins fpu_op1 = {1};
    bins fpu_op2 = {2};
    bins fpu_op3 = {3};
    }
    snan: coverpoint snan
    {bins snan0 = {0};
    bins snan1 = {1};
    }
    cross_op_snan : cross fpu_op, snan;
  endgroup

  covergroup crossCov_op_qnan @(clk);
    fpu_op: coverpoint fpu_op
    {bins fpu_op0 = {0};
    bins fpu_op1 = {1};
    bins fpu_op2 = {2};
    bins fpu_op3 = {3};
    }
    qnan: coverpoint qnan
    {bins qnan0 = {0};
    bins qnan1 = {1};
    }
    cross_op_qnan : cross fpu_op, qnan;
  endgroup

  covergroup crossCov_op_ine @(clk);
    fpu_op: coverpoint fpu_op
    {bins fpu_op0 = {0};
    bins fpu_op1 = {1};
    bins fpu_op2 = {2};
    bins fpu_op3 = {3};
    }
    ine: coverpoint ine
    {bins ine0 = {0};
    bins ine1 = {1};
    }
    cross_op_ine : cross fpu_op, ine;
  endgroup

  covergroup crossCov_op_inf @(clk);
    fpu_op: coverpoint fpu_op
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

//_______________________________________________________________________
//______________________CASOS ESPECIFICOS________________________________
//_______________________________________________________________________
//Caso de redondeo
  covergroup crossCov_rmode_test_div @(clk);
    fpu_op: coverpoint fpu_op
    {bins fpu_op3 = {3};
    }
    opa: coverpoint opa 
    {bins opa1 = {1024};
    }
    opb: coverpoint opb 
    {bins opb1 = {1024};
    }
    rmode: coverpoint rmode
    {bins rmode0 = {0};
    bins rmode1 = {1};
    bins rmode2 = {2};
    bins rmode3 = {3};
    }
    cross_op_rmode : cross fpu_op, rmode;
  endgroup

//Números mas grandes
  covergroup crossCov_op_maxNum @(clk);
    fpu_op: coverpoint fpu_op
    {bins fpu_op0 = {0};
    bins fpu_op1 = {1};
    bins fpu_op2 = {2};
    bins fpu_op3 = {3};
    }
    opa: coverpoint opa 
    {bins opa1 = {1024};
    }
    opb: coverpoint opb 
    {bins opb1 = {1024};
    }
    cross_op_rmode : cross fpu_op, rmode;
  endgroup

//caso secuencia NAN



  //_______________________________________________________________________

    cov0 					coverage_collection_1  =new();
    covFPU_Op 				coverage_collection_2  =new();
    crossCov_op_rmode 		coverage_collection_3  =new();
    crossCov_op_overflow 	coverage_collection_4  =new();
    crossCov_op_underflow 	coverage_collection_5  =new(); 
    crossCov_op_snan 		coverage_collection_6  =new();
    crossCov_op_qnan 		coverage_collection_7  =new();
    crossCov_op_ine 		coverage_collection_8  =new();
    crossCov_op_inf 		coverage_collection_9  =new();
    crossCov_rmode_test_div coverage_collection_10 =new(); 


endinterface
