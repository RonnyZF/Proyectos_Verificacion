program testcase(intf_cnt intf);
  environment env = new(intf);
         
  initial
    begin
    env.drvr.reset();
    fork
      begin
      env.drvr.write(10);
      end
      begin
        @(negedge intf.clk)  //This to avoid reading and writing when fifo is empty. 
      env.drvr.read(10);
      end
    join 
      if (env.mntr.err_count == 0 && env.mntr.check_count > 0)
        $display("\n***** Test Passed *****\n");
      else
        $display("\n***** Test Failed *****\n");
    
    end
endprogram
