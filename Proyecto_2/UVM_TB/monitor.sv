class fpu_monitor extends uvm_monitor;
  `uvm_component_utils (fpu_monitor)

   virtual fpu_intf intf;
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

class fpu_monitor_wr extends fpu_monitor;
  `uvm_component_utils (fpu_monitor_wr)

   function new (string name, uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
   endfunction

   virtual task run_phase (uvm_phase phase);
      fpu_item  data_obj = fpu_item::type_id::create ("data_obj", this);
      forever begin
        @ (negedge intf.clk);  
        if( intf.wr_en == 1) begin
          data_obj.data = intf.data_in;
          mon_analysis_port.write (data_obj);
        end
      end
   endtask

endclass

class fpu_monitor_rd extends fpu_monitor;
  `uvm_component_utils (fpu_monitor_rd)

   function new (string name, uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
   endfunction

   virtual task run_phase (uvm_phase phase);
      fpu_item  data_obj = fpu_item::type_id::create ("data_obj", this);
      forever begin
        @ (negedge intf.clk);  
        if( intf.rd_en == 1) begin
          data_obj.data = intf.data_out;
          mon_analysis_port.write (data_obj);
        end
      end
   endtask

endclass
