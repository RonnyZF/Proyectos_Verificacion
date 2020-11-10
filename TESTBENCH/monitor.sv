class monitor;
  scoreboard sb;
  virtual intf_cnt intf;
  logic [2:0] sb_fpu_op; 
  logic [1:0] sb_rmode;  
  logic [31:0] sb_opa;
  logic [31:0] sb_opb;
  logic [31:0] sb_out;
  int err_count;
  int check_count;
          
  function new(virtual intf_cnt intf,scoreboard sb);
    this.intf = intf;
    this.sb = sb;
  endfunction
          
  task check();
    err_count = 0;
    check_count = 0;
    forever
      begin  
        @ (negedge intf.clk)
        if( $isunknown(intf.out)==0)
        begin
          	$display("-------------------- Monitor Operation Check%d --------------------", (check_count+1));
	    	sb.operation();
	        sb_out = sb.out;
	        $display(" SCOREBOARD  out is 0x%h :: decimal is %f ", sb_out, $bitstoshortreal(sb_out) );
	        $display(" MONITOR DUT out is 0x%h :: decimal is %f ", intf.out, $bitstoshortreal(intf.out) );
	          if( sb_out !== intf.out) // Get expected value from scoreboard and comare with DUT output
	            begin
	            $display(" * ERROR * DUT data is 0x%h :: SB data is 0x%h \n", intf.out, sb_out );
	            err_count = err_count + 1;
	            check_count = check_count + 1;
	            end
	          else
	            begin
	            $display(" * PASS * DUT data is 0x%h :: SB data is 0x%h \n", intf.out, sb_out );
	            check_count = check_count + 1;
	            end
                $display("-------------------- ------- ------- ------- -----------------");
	    end  
      end
  endtask
endclass

