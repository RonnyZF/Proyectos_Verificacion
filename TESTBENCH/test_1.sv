program testcase(intf_cnt intf);
  environment env = new(intf);
         
  initial
    begin
    fork
      begin
      env.drvr.add(1);
      end
      begin
        @(negedge intf.clk)  //This to avoid reading and writing when fifo is empty. 
      env.drvr.sub(1);
      end
    join 
      if (env.mntr.err_count == 0 && env.mntr.check_count > 0)
        $display("\n***** Test Passed *****\n");
      else
        $display("\n***** Test Failed *****\n");
    
    end
endprogram
