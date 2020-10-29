program testcase(intf_cnt intf);
  environment env = new(intf);
         
  initial
    begin
        @(negedge intf.clk)
        $display("\n***** EFECTUANDO LAS SUMAS *****\n");
        $display("\n***** EFECTUANDO LAS SUMAS *****\n");
        $display("\n***** EFECTUANDO LAS SUMAS *****\n");
        env.drvr.add(15);
        /*
        @(negedge intf.clk)  //This to avoid reading and writing when fifo is empty. 
        $display("\n***** EFECTUANDO LAS RESTAS *****\n");
        $display("\n***** EFECTUANDO LAS RESTAS *****\n");
        $display("\n***** EFECTUANDO LAS RESTAS *****\n");
        env.drvr.sub(10);
        */
      repeat(3)
        begin
          @ (negedge intf.clk);
        end
      if (env.mntr.err_count == 0 && env.mntr.check_count > 0)
        $display("\n***** Test Passed *****\n");
      else
        $display("\n***** Test Failed :C *****\n");
    
    end
endprogram
