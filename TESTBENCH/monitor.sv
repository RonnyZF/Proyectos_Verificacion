class monitor;
  scoreboard sb;
  virtual intf_cnt intf;

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
        @ (posedge intf.clk)
        if (intf.rmode == 0) //CAMBIAR
        begin
        sb_opa = sb.opa.pop_back();
        sb_opb = sb.opb.pop_back();
        sb_out = sb_opa + sb_opb;
        $display(" SCOREBOARD opa is 0x%h :: opb is 0x%h ", sb_opa,sb_opb );
        $display(" SCOREBOARD out is 0x%h :: decimal is %d ", sb_out,sb_out );
          if( sb_opa !== intf.out) // Get expected value from scoreboard and comare with DUT output
            begin
            $display(" * ERROR * DUT data is %b :: SB data is %b ", intf.out,sb_opa );
            err_count = err_count + 1;
            check_count = check_count + 1;
            end
          else
            begin
            $display(" * PASS * DUT data is %b :: SB data is %b ", intf.out,sb_opa );
            check_count = check_count + 1;
            end
        end
      end
  endtask
endclass

