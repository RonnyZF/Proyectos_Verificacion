`uvm_analysis_imp_decl( _drv )
`uvm_analysis_imp_decl( _mon ) 

class fpu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils (fpu_scoreboard)

    function new (string name, uvm_component parent=null);
		super.new (name, parent);
	endfunction

    uvm_analysis_imp_drv #(fpu_item, fpu_scoreboard) fpu_drv;
    uvm_analysis_imp_mon #(fpu_item, fpu_scoreboard) fpu_mon;

    logic [7:0] ref_model [$];  
    logic [31:0] ref_opa [$];
  	logic [31:0] ref_opb [$];
  	logic[2:0] ref_fpu_op [$]; 
  	logic[1:0] ref_rmode [$];  
  	logic[31:0] ref_out [$];
    logic[31:0] temporal;
    logic[31:0] out_dut;
  
	function void build_phase (uvm_phase phase);
      fpu_drv = new ("fpu_drv", this);
      fpu_mon = new ("fpu_mon", this);
	endfunction

    task operation();
      $display("ENTRO EN OPERATION");
      rem = new(ref_opa.pop_back(), ref_opb.pop_back(), ref_fpu_op.pop_back(), ref_rmode.pop_back());
      rem.reference_model();
      ref_out.push_back(rem.out);
      //this.ref_out = rem.out;
    endtask

    virtual function void write_drv (fpu_item item);
      $display("TASK write_drv\n");
      $display("OPA write_drv = 0x%0h",item.opa);
      $display("OPB write_drv = 0x%0h",item.opb);
      ref_opa.push_back(item.opa);
      ref_opb.push_back(item.opb);
      ref_fpu_op.push_back(item.fpu_op);
      ref_rmode.push_back(item.rmode);
      operation();
	endfunction
  
    virtual function void write_mon (fpu_item item);
      $display("TASK write_mon\n");
      `uvm_info ("mon", $sformatf("out received = 0x%0h", item.out), UVM_MEDIUM)//CAMBIAR
      out_dut = item.out;
      temporal = ref_out.pop_front();
      //temporal = ref_out;

      $display("OUT MODELO DE REFERENCIA 0x%0h \n", temporal);
      if (out_dut != temporal) begin
        `uvm_error("SB error", "Data mismatch");
      end
      else begin
        `uvm_info("SB PASS", $sformatf("Data received = 0x%0h", item.out), UVM_MEDIUM);//CAMBIAR
        $display("PRINT SI PASO \n");
      end
    endfunction
    //POSICION CORRECTA????
	virtual task run_phase (uvm_phase phase);
		//rem = new(opa.pop_back(), opb.pop_back(), fpu_op.pop_back(), rmode.pop_back());
	  //  rem.reference_model();
	  //  this.out = rem.out;
	endtask

	virtual function void check_phase (uvm_phase phase);
      if(ref_model.size() > 0)
        `uvm_warning("SB Warn", $sformatf("fpu not empty at check phase. fpu still has 0x%0h data items allocated", ref_model.size()));//CAMBIAR
	endfunction
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
    $display("FPU_OP = %d and RMODE = %d \n", this.op, this.round);

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
          //ieee_temp += 1'b1;
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
