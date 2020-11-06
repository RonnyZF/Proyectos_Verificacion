
class scoreboard;
  logic [31:0] opa [$];
  logic [31:0] opb [$];
  logic[2:0] fpu_op [$]; 
  logic[1:0] rmode [$];  
  logic[31:0] out;

  task operation();
    rem = new(opa.pop_back(), opb.pop_back(), fpu_op.pop_back(), rmode.pop_back());
    rem.reference_model();
    this.out = rem.out;
  endtask
endclass

class ref_model;
  // members in class
  logic[31:0] opa;
  logic[31:0] opb;
  logic[2:0] op;
  logic[1:0] round;
  logic[31:0] out;
  logic zero;
  logic snan;
  logic qnan;
  logic inf;
  logic overflow;
  logic underflow;
  logic div_by_zero;
  
  // Constructor
  function new (logic[31:0] opa, logic[31:0] opb, logic[2:0] op, logic[1:0] round);
    begin
      this.opa          = opa;
      this.opb          = opb;
      this.op           = op;
      this.round        = round;
      this.out          = 32'b0;
      this.zero         = 1'b0;
      this.snan         = 1'b0;
      this.qnan         = 1'b0;
      this.inf          = 1'b0;
      this.overflow     = 1'b0;
      this.underflow    = 1'b0;
      this.div_by_zero  = 1'b0;
    end
  endfunction


  function void reference_model();
    // Temp Variables Inicialization
    shortreal a, b;
    shortreal temp_out = 0;
    logic [31:0] ieee_temp = $shortrealtobits(temp_out);
    a = $bitstoshortreal(this.opa);
    b = $bitstoshortreal(this.opb);

    // Compute the desire operation
    if((b == 0) & (this.op == 3'b011)) begin // Division By Zero
      this.out = 32'b0;
      this.zero = 1'b0;
      this.snan = 1'b0;
      this.qnan = 1'b0;
      this.inf = 1'b0;
      this.overflow = 1'b0;
      this.underflow = 1'b0;
      this.div_by_zero = 1'b1;
    end
    else if((opa[30:23] == 8'b1) | (opb[30:23] == 8'b1)) begin // SNaN
      this.out = 32'b0;
      this.zero = 1'b0;
      this.snan = 1'b1;
      this.qnan = 1'b0;
      this.inf = 1'b0;
      this.overflow = 1'b0;
      this.underflow = 1'b0;
      this.div_by_zero = 1'b0;
    end
    else begin // Normal Operation
      case(this.op)
        3'b000  : temp_out = a + b;
        3'b001  : temp_out = a - b;
        3'b010  : temp_out = a * b;
        3'b011  : temp_out = a / b;
        default : temp_out = 0;
      endcase
      ieee_temp = $shortrealtobits(temp_out);

      // Compute the outpuut with corresponding rounding mode
      if(this.round == 2'b00) begin // Round to Nearest Even
        if(ieee_temp[0] == 1'b1) begin
          ieee_temp += 1'b1;
        end
      end
      else if(this.round == 2'b10) begin // Round to +Inf
        ieee_temp += 1'b1;
      end
      else if(this.round == 2'b11) begin // Round to -Inf
        ieee_temp += 1'b1;
      end

      // Compute if there is a speacial result
      if((ieee_temp[30:23] == 8'b0) & (ieee_temp[22:0] == 23'b0))begin
        this.out = ieee_temp;
        this.zero = 1'b1;
        this.snan = 1'b0;
        this.qnan = 1'b0;
        this.inf = 1'b0;
        this.overflow = 1'b0;
        this.underflow = 1'b0;
        this.div_by_zero = 1'b0;
      end
      else if((ieee_temp[30:23] == 8'b0) & (ieee_temp[22:0] != 23'b0))begin
        this.out = ieee_temp;
        this.zero = 1'b0;
        this.snan = 1'b0;
        this.qnan = 1'b0;
        this.inf = 1'b0;
        this.overflow = 1'b0;
        this.underflow = 1'b1;
        this.div_by_zero = 1'b0;
      end
      else if((ieee_temp[30:23] == 8'b1) & (ieee_temp[22:0] == 23'b0))begin
        this.out = ieee_temp;
        this.zero = 1'b0;
        this.snan = 1'b0;
        this.qnan = 1'b0;
        this.inf = 1'b1;
        this.overflow = 1'b1;
        this.underflow = 1'b0;
        this.div_by_zero = 1'b0;
      end
      else if((ieee_temp[30:23] == 8'b1) & (ieee_temp[22:0] != 23'b0))begin
        this.out = ieee_temp;
        this.zero = 1'b0;
        this.snan = 1'b0;
        this.qnan = 1'b1;
        this.inf = 1'b0;
        this.overflow = 1'b1;
        this.underflow = 1'b0;
        this.div_by_zero = 1'b0;
      end
      else begin
        this.out = ieee_temp;
        this.zero = 1'b0;
        this.snan = 1'b0;
        this.qnan = 1'b0;
        this.inf = 1'b0;
        this.overflow = 1'b0;
        this.underflow = 1'b0;
        this.div_by_zero = 1'b0;
      end
    end
  endfunction
endclass

ref_model rem;
