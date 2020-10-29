class monitor;
  scoreboard sb;
  virtual intf_cnt intf;

  logic [31:0] sb_opa;
  logic [31:0] sb_opb;
  logic [31:0] sb_out;
  logic[2:0] sb_fpu_op; 
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
          sb_fpu_op = sb.fpu_op.pop_back();
          if (sb_fpu_op == 0) //ADD
          begin
            sb_opa = sb.opa.pop_back();
            sb_opb = sb.opb.pop_back();
            sb_out = sb_opa + sb_opb;
            $display(" MONITOR SUMA");
            $display(" SCOREBOARD opa is %h :: opb is %h ", $shortrealtobits(sb_opa),$shortrealtobits(sb_opb) );
            $display(" SCOREBOARD out is 0x%h :: decimal is %d ", $shortrealtobits(sb_out),sb_out );
            $display(" SALIDA DUT out is 0x%h :: decimal is %d ", intf.out, $bitstoshortreal(intf.out) );
              if( sb_out !== $bitstoshortreal(intf.out)) // Get expected value from scoreboard and comare with DUT output
                begin
                $display(" * ERROR * DUT data is 0x%h :: SB data is 0x%h \n", intf.out, $shortrealtobits(sb_out) );
                err_count = err_count + 1;
                check_count = check_count + 1;
                end
              else
                begin
                $display(" * PASS * DUT data is 0x%h :: SB data is 0x%h \n", intf.out, $shortrealtobits(sb_out) );
                check_count = check_count + 1;
                end
          end
          if (sb_fpu_op == 1) //SUB
          begin
            sb_opa = sb.opa.pop_back();
            sb_opb = sb.opb.pop_back();
            sb_out = sb_opa - sb_opb;
            $display(" MONITOR RESTA");
            $display(" SCOREBOARD opa is %h :: opb is %h ", $shortrealtobits(sb_opa),$shortrealtobits(sb_opb) );
            $display(" SCOREBOARD out is 0x%h :: decimal is %d ", $shortrealtobits(sb_out) ,sb_out );
            $display(" SALIDA DUT out is 0x%h :: decimal is %d ", intf.out,intf.out );
              if( sb_out !== $bitstoshortreal(intf.out)) // Get expected value from scoreboard and comare with DUT output
                begin
                $display(" * ERROR * DUT data is 0x%h :: SB data is 0x%h \n", intf.out, $shortrealtobits(sb_out) );
                err_count = err_count + 1;
                check_count = check_count + 1;
                end
              else
                begin
                $display(" * PASS * DUT data is 0x%h :: SB data is 0x%h \n", intf.out, $shortrealtobits(sb_out) );
                check_count = check_count + 1;
                end
          end
          if (sb_fpu_op == 2) //MUL
          begin
            sb_opa = sb.opa.pop_back();
            sb_opb = sb.opb.pop_back();
            sb_out = sb_opa * sb_opb;
            $display(" MONITOR MULT");
            $display(" SCOREBOARD opa is %h :: opb is %h ", $shortrealtobits(sb_opa),$shortrealtobits(sb_opb) );
            $display(" SCOREBOARD out is 0x%h :: decimal is %d ", $shortrealtobits(sb_out) ,sb_out );
            $display(" SALIDA DUT out is 0x%h :: decimal is %d ", intf.out,intf.out );
              if( sb_out !== $bitstoshortreal(intf.out)) // Get expected value from scoreboard and comare with DUT output
                begin
                $display(" * ERROR * DUT data is 0x%h :: SB data is 0x%h \n", intf.out, $shortrealtobits(sb_out) );
                err_count = err_count + 1;
                check_count = check_count + 1;
                end
              else
                begin
                $display(" * PASS * DUT data is 0x%h :: SB data is 0x%h \n", intf.out, $shortrealtobits(sb_out) );
                check_count = check_count + 1;
                end
          end
          if (sb_fpu_op == 3) //DIV
          begin
            sb_opa = sb.opa.pop_back();
            sb_opb = sb.opb.pop_back();
            sb_out = sb_opa / sb_opb;
            $display(" MONITOR DIVISION");
            $display(" SCOREBOARD opa is %h :: opb is %h ", $shortrealtobits(sb_opa),$shortrealtobits(sb_opb) );
            $display(" SCOREBOARD out is 0x%h :: decimal is %d ", $shortrealtobits(sb_out) ,sb_out );
            $display(" SALIDA DUT out is 0x%h :: decimal is %d ", intf.out,intf.out );
              if( sb_out !== $bitstoshortreal(intf.out)) // Get expected value from scoreboard and comare with DUT output
                begin
                $display(" * ERROR * DUT data is 0x%h :: SB data is 0x%h \n", intf.out, $shortrealtobits(sb_out) );
                err_count = err_count + 1;
                check_count = check_count + 1;
                end
              else
                begin
                $display(" * PASS * DUT data is 0x%h :: SB data is 0x%h \n", intf.out, $shortrealtobits(sb_out) );
                check_count = check_count + 1;
                end
          end
        end
      end
  endtask
endclass

