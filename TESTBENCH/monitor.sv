class monitor;
  scoreboard sb;
  virtual intf_cnt intf;

  logic [7:0] sb_value;
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
        if (intf.rd_en == 1) //CAMBIAR
        begin
        sb_value = sb.store.pop_back();
          if( sb_value !== intf.data_out) // Get expected value from scoreboard and compare with DUT output
            begin
            $display(" * ERROR * DUT data is %b :: SB data is %b ", intf.data_out,sb_value );
            err_count = err_count + 1;
            check_count = check_count + 1;
            end
          else
            begin
            $display(" * PASS * DUT data is %b :: SB data is %b ", intf.data_out,sb_value );
            check_count = check_count + 1;
            end
        end
      end
  endtask
endclass

