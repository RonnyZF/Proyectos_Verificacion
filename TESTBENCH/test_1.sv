program testcase(intf_cnt intf);
  environment env = new(intf);
         
  initial
    begin
        @(negedge intf.clk)
        $display("\n***** EFECTUANDO OPERACIONES *****\n");
        env.drvr.operation(500);
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
