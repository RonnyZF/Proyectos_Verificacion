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
    Feature_data: coverpoint intf.opa {option.auto_bin_max=8;}
    Feature_data: coverpoint intf.opb {option.auto_bin_max=8;}
    Feature_data: coverpoint intf.out {option.auto_bin_max=8;}
    Feature_empty_seq: coverpoint intf.zero {bins seq = (0=>1=>0);}
    Feature_full_seq: coverpoint intf.overflow {bins seq = (0=>1=>0);}
  endgroup
  
  function new(virtual intf_cnt intf);
    this.intf =intf;
    cov0 =new();
  endfunction


endclass