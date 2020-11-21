class fpu_monitor extends uvm_monitor;
  `uvm_component_utils (fpu_monitor)

   virtual fpu_intf intf;
   logic [2:0] sb_fpu_op; 
   logic [1:0] sb_rmode;  
   logic [31:0] sb_opa;
   logic [31:0] sb_opb;
   logic [31:0] sb_out;
   int err_count;
   int check_count;

   bit     enable_check = 0; //Turned OFF by default
   bit     enable_coverage = 0; //Turned OFF by default
  
   uvm_analysis_port #(fpu_item)   mon_analysis_port;

   function new (string name, uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);

      // Create an instance of the analysis port
      mon_analysis_port = new ("mon_analysis_port", this);

      // Get virtual interface handle from the configuration DB
      if(uvm_config_db #(virtual fpu_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
       `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
      end
   endfunction

   virtual task run_phase (uvm_phase phase);
      super.run_phase(phase);
   endtask

   virtual function void check_protocol ();
      // Function to check basic protocol specs
   endfunction
endclass

class fpu_monitor_check extends fpu_monitor;
  `uvm_component_utils (fpu_monitor_check)

   function new (string name, uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
   endfunction

   virtual task run_phase (uvm_phase phase);
      fpu_item  data_obj = fpu_item::type_id::create ("data_obj", this);
      err_count = 0;
      check_count = 0;
      forever begin
        @ (negedge intf.clk)
        if( $isunknown(intf.out)==0)
        begin
          	$display("-------------------- Monitor Operation Check%d --------------------", (check_count+1));
	    	sb.operation();
	        sb_out = sb.out;
	        $display(" SCOREBOARD  out is 0x%h :: decimal is %f ", sb_out, $bitstoshortreal(sb_out) );
	        $display(" MONITOR DUT out is 0x%h :: decimal is %f ", intf.out, $bitstoshortreal(intf.out) );
	          if( sb_out !== intf.out) // Get expected value from scoreboard and comare with DUT output
	            begin
	            $display(" * ERROR * DUT data is 0x%h :: SB data is 0x%h \n", intf.out, sb_out );
	            err_count = err_count + 1;
	            check_count = check_count + 1;
	            end
	          else
	            begin
	            $display(" * PASS * DUT data is 0x%h :: SB data is 0x%h \n", intf.out, sb_out );
	            check_count = check_count + 1;
	            end
                $display("-------------------- ------- ------- ------- -----------------");
	    end  
      end
   endtask

endclass
