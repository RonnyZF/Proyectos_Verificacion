class funct_coverage;

  virtual intf_cnt intf;
  
  covergroup cov0 @(intf.clk);
    Feature_inf: coverpoint intf.inf;
    Feature_data: coverpoint intf.out {option.auto_bin_max=8;}
    Feature_empty_seq: coverpoint intf.zero {bins seq = (0=>1=>0);}
    Feature_full_seq: coverpoint intf.overflow {bins seq = (0=>1=>0);}
  endgroup
  
  function new(virtual intf_cnt intf);
    this.intf =intf;
    cov0 =new();
  endfunction


endclass