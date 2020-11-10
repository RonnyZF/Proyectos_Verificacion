program testcase(intf_cnt intf);
  environment env = new(intf);
         
  initial
    begin
        @(negedge intf.clk)
        $display("\n***** EFECTUANDO OPERACIONES *****\n");
        env.drvr.operation(320);
        //env.drvr.overflow(1);
        //env.drvr.operation(2);
        //env.drvr.div_zero(1);
        //env.drvr.task_nan(1);
      repeat(3)
        begin
          @ (negedge intf.clk);
        end
      $display("======================= TEST FINISH ==========================",);
      $display("Test count= %d",env.mntr.check_count);
      $display("Error count= %d",env.mntr.err_count);
      if (env.mntr.err_count == 0 && env.mntr.check_count > 0)
        $display("\n***** Test Passed *****\n");
      else
        $display("\n***** Test Failed :C *****\n");
    
    end
endprogram
