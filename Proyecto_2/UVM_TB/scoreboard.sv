`uvm_analysis_imp_decl( _drv )
`uvm_analysis_imp_decl( _mon ) 

class fpu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils (fpu_scoreboard)

    function new (string name, uvm_component parent=null);
		super.new (name, parent);
	endfunction

    uvm_analysis_imp_drv #(fpu_item, fpu_scoreboard) fpu_drv;
    uvm_analysis_imp_mon #(fpu_item, fpu_scoreboard) fpu_mon;
    // Variables para almacenar las salidas del DUT
    logic [31:0] dut_out;
    logic dut_zero;  
    logic dut_snan;
    logic dut_qnan;
    logic dut_inf;
    logic dut_overflow;
    logic dut_underflow;
    logic dut_div_by_zero;
    // Fifos para almacenar los valores del modelo de referencia
    logic [7:0]   ref_model [$];  
    logic [31:0]  ref_opa [$];
  	logic [31:0]  ref_opb [$];
  	logic [2:0]   ref_fpu_op [$]; 
  	logic [1:0]   ref_rmode [$];  
  	logic [31:0]  ref_out [$];
    logic ref_zero [$];
    logic ref_snan [$];
    logic ref_qnan [$];
    logic ref_inf [$];
    logic ref_overflow [$];
    logic ref_underflow [$];
    logic ref_div_by_zero [$];
    // Variables para almacenar datos temporales del modelo de referencia
    logic [31:0] temp_out;
    logic temp_zero;  
    logic temp_snan;
    logic temp_qnan;
    logic temp_inf;
    logic temp_overflow;
    logic temp_underflow;
    logic temp_div_by_zero;
    // Banderas para realizar el checkeo del modelo
    logic flag_out;
    logic flag_zero;    
    logic flag_snan;
    logic flag_qnan;
    logic flag_inf;
    logic flag_overflow;
    logic flag_underflow;
    logic flag_div_by_zero;
  
	function void build_phase (uvm_phase phase);
      fpu_drv = new ("fpu_drv", this);
      fpu_mon = new ("fpu_mon", this);
	endfunction

    task operation();
      $display("ENTRO EN OPERATION");
      rem = new(ref_opa.pop_back(), ref_opb.pop_back(), ref_fpu_op.pop_back(), ref_rmode.pop_back());
      rem.reference_model();
      ref_out.push_back(rem.out);
      ref_zero.push_back(rem.zero);
      ref_snan.push_back(rem.snan);
      ref_qnan.push_back(rem.qnan);
      ref_inf.push_back(rem.inf);
      ref_overflow.push_back(rem.overflow);
      ref_underflow.push_back(rem.underflow);
      ref_div_by_zero.push_back(rem.div_by_zero);
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
      dut_out = item.out;
      dut_zero = item.zero;  
      dut_snan = item.snan;
      dut_qnan = item.qnan;
      dut_inf = item.inf;
      dut_overflow = item.overflow;
      dut_underflow = item.underflow;
      dut_div_by_zero = item.div_by_zero;
      temp_out = ref_out.pop_front();
      temp_zero = ref_zero.pop_front();
      temp_snan = ref_snan.pop_front();
      temp_qnan = ref_qnan.pop_front();
      temp_inf = ref_inf.pop_front();
      temp_overflow = ref_overflow.pop_front();
      temp_underflow = ref_underflow.pop_front();
      temp_div_by_zero = ref_div_by_zero.pop_front();
      //temporal = ref_out;

      //$display("OUT MODELO DE REFERENCIA 0x%0h \n", temporal);
      //$display("PRINT SI PASO \n");
      if (dut_out != temp_out) begin
        `uvm_error("SB(Out) error", "Data mismatch");
        flag_out = 0;
      end
      else begin
        `uvm_info("SB(Out) PASS", $sformatf("Data received = 0x%0h", item.out), UVM_MEDIUM);//CAMBIAR
        flag_out = 1;
      end

      if (dut_zero != temp_zero) begin
        `uvm_error("SB(Zero) error", "Data mismatch");
        flag_zero = 0;
      end
      else begin
        `uvm_info("SB(Zero) PASS", $sformatf("Data received = 0x%0h", item.zero), UVM_MEDIUM);
        flag_zero = 1;
      end

      if (dut_snan != temp_snan) begin
        `uvm_error("SB(SNaN) error", "Data mismatch");
        flag_snan = 0;
      end
      else begin
        `uvm_info("SB(SNaN) PASS", $sformatf("Data received = 0x%0h", item.snan), UVM_MEDIUM);
        flag_snan = 1;
      end

      if (dut_qnan != temp_qnan) begin
        `uvm_error("SB(QNaN) error", "Data mismatch");
        flag_qnan = 0;
      end
      else begin
        `uvm_info("SB(QNaN) PASS", $sformatf("Data received = 0x%0h", item.qnan), UVM_MEDIUM);
        flag_qnan = 1;
      end

      if (dut_inf != temp_inf) begin
        `uvm_error("SB(Inf) error", "Data mismatch");
        flag_inf = 0;
      end
      else begin
        `uvm_info("SB(Inf) PASS", $sformatf("Data received = 0x%0h", item.inf), UVM_MEDIUM);
        flag_inf = 1;
      end

      if (dut_overflow != temp_overflow) begin
        `uvm_error("SB(Overflow) error", "Data mismatch");
        flag_overflow = 0;
      end
      else begin
        `uvm_info("SB(Overflow) PASS", $sformatf("Data received = 0x%0h", item.overflow), UVM_MEDIUM);
        flag_overflow = 1;
      end

      if (dut_underflow != temp_underflow) begin
        `uvm_error("SB(Undeflow) error", "Data mismatch");
        flag_underflow = 0;
      end
      else begin
        `uvm_info("SB(Underflow) PASS", $sformatf("Data received = 0x%0h", item.underflow), UVM_MEDIUM);
        flag_underflow = 1;
      end

      if (dut_div_by_zero != temp_div_by_zero) begin
        `uvm_error("SB(Div by Zero) error", "Data mismatch");
        flag_div_by_zero = 0;
      end
      else begin
        `uvm_info("SB(Div by Zero) PASS", $sformatf("Data received = 0x%0h", item.div_by_zero), UVM_MEDIUM);
        flag_div_by_zero = 1;
      end

      if (flag_out && flag_zero && flag_snan && flag_qnan && flag_inf && flag_overflow && flag_underflow && flag_div_by_zero) begin
        $display("SB PASS - All data was correct!!");
        // Reset de las banderas
        flag_out          = 0;
        flag_zero         = 0;    
        flag_snan         = 0;
        flag_qnan         = 0;
        flag_inf          = 0;
        flag_overflow     = 0;
        flag_underflow    = 0;
        flag_div_by_zero  = 0;
      end
      else begin
        $display("SB ERROR - One or more data did not match");
        // Reset de las banderas
        flag_out          = 0;
        flag_zero         = 0;
        flag_snan         = 0;
        flag_qnan         = 0;
        flag_inf          = 0;
        flag_overflow     = 0;
        flag_underflow    = 0;
        flag_div_by_zero  = 0;
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
