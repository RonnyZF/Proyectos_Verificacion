
class scoreboard;
  logic[31:0] opa [$];
  logic[31:0] opb [$];
  logic[31:0] out [$];
  logic[2:0] fpu_op [$];
  logic[1:0] rmode [$];
  logic zero [$];
  logic snan [$];
  logic qnan [$];
  logic inf [$];
  logic overflow [$];
  logic underflow[$];
  logic div_by_zero [$];
endclass

function void reference_model(input shortreal a, b, logic[2:0] op, logic[1:0] round, output logic[31:0] out, logic zero, snan, qnan, inf, overflow, underflow, div_by_zero);
  // Temp Variables Inicialization
  logic[31:0] opa, opb;
  opa = $shortrealtobits(a);
  opb = $shortrealtobits(b);
  shortreal temp_out = 0;
  logic [31:0] ieee_temp = $shortrealtobits(temp_out);
  // Compute the desire operation
  if((b == 0) & (op == 3'b011)) begin // Division By Zero
    out = 32'b0;
    zero = 1'b0;
    snan = 1'b0;
    qnan = 1'b0;
    inf = 1'b0;
    overflow = 1'b0;
    underflow = 1'b0;
    div_by_Zero = 1'b1;
  end
  else if((opa[30:23] == 8'b1) | (opb[30:23] == 8'b1)) begin // SNaN
    out = 32'b0;
    zero = 1'b0;
    snan = 1'b1;
    qnan = 1'b0;
    inf = 1'b0;
    overflow = 1'b0;
    underflow = 1'b0;
    div_by_Zero = 1'b0;
  else begin // Normal Operation
    case(op)
      3'b000  : temp_out = a + b;
      3'b001  : temp_out = a - b;
      3'b010  : temp_out = a * b;
      3'b011  : temp_out = a / b;
      default : temp_out = 0;
    endcase
    ieee_temp = $shortrealtobits(temp_out);
    
    // Compute the output with corresponding rounding mode
    if(round == 2'b00) begin // Round to Nearest Even
      if(ieee_temp[0] == 1'b1) begin
        ieee_temp += 1'b1;
      end
    end
    else if(round == 2'b10) begin // Round to +Inf
      ieee_temp += 1'b1;
    end
    else if(round == 2'b11) begin // Round to -Inf
      ieee_temp += 1'b1;
    end
        
    // Compute if there is a speacial result
    if((ieee_temp[30:23] == 8'b0) & (ieee_temp[22:0] == 23'b0))begin
      out = ieee_temp;
      zero = 1'b1;
      snan = 1'b0;
      qnan = 1'b0;
      inf = 1'b0;
      overflow = 1'b0;
      underflow = 1'b0;
      div_by_Zero = 1'b0;
    end
    else if((ieee_temp[30:23] == 8'b0) & (ieee_temp[22:0] != 23'b0))begin
      out = ieee_temp;
      zero = 1'b0;
      snan = 1'b0;
      qnan = 1'b0;
      inf = 1'b0;
      overflow = 1'b0;
      underflow = 1'b1;
      div_by_Zero = 1'b0;
    end
    else if((ieee_temp[30:23] == 8'b1) & (ieee_temp[22:0] == 23'b0))begin
      out = ieee_temp;
      zero = 1'b0;
      snan = 1'b0;
      qnan = 1'b0;
      inf = 1'b1;
      overflow = 1'b1;
      underflow = 1'b0;
      div_by_Zero = 1'b0;
    end
    else if((ieee_temp[30:23] == 8'b1) & (ieee_temp[22:0] != 23'b0))begin
      out = ieee_temp;
      zero = 1'b0;
      snan = 1'b0;
      qnan = 1'b1;
      inf = 1'b0;
      overflow = 1'b1;
      underflow = 1'b0;
      div_by_Zero = 1'b0;
    end
    else begin
      out = ieee_temp;
      zero = 1'b0;
      snan = 1'b0;
      qnan = 1'b0;
      inf = 1'b0;
      overflow = 1'b0;
      underflow = 1'b0;
      div_by_Zero = 1'b0;
    end
  end
  
endfunction