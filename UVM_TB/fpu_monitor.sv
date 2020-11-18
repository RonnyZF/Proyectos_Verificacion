//-------------------------------------------------------------------------
//						fpu_monitor - www.verificationguide.com 
//-------------------------------------------------------------------------

class fpu_monitor extends uvm_monitor;

  //---------------------------------------
  // Virtual Interface
  //---------------------------------------
  virtual fpu_if vif;

  //---------------------------------------
  // analysis port, to send the transaction to scoreboard
  //---------------------------------------
  uvm_analysis_port #(fpu_seq_item) item_collected_port;
  
  //---------------------------------------
  // The following property holds the transaction information currently
  // begin captured (by the collect_address_phase and data_phase methods).
  //---------------------------------------
  fpu_seq_item trans_collected;

  `uvm_component_utils(fpu_monitor)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  //---------------------------------------
  // build_phase - getting the interface handle
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fpu_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase
  
  //---------------------------------------
  // run_phase - convert the signal level activity to transaction level.
  // i.e, sample the values on interface signal ans assigns to transaction class fields
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.MONITOR.clk);
      wait((~vif.monitor_cb.WE) || (~vif.monitor_cb.OE));
        trans_collected.Address = vif.monitor_cb.Address;
      if(~vif.monitor_cb.WE) begin
        trans_collected.WE = vif.monitor_cb.WE;
        trans_collected.CS = vif.monitor_cb.CS;
        trans_collected.wdata = vif.monitor_cb.wdata;
        trans_collected.OE = 1;
        @(posedge vif.MONITOR.clk);
      end
      if(~vif.monitor_cb.OE) begin
        trans_collected.OE = vif.monitor_cb.OE;
        trans_collected.CS = vif.monitor_cb.CS;
        trans_collected.WE = 1;
        @(posedge vif.MONITOR.clk);
        @(posedge vif.MONITOR.clk);
        trans_collected.rdata = vif.monitor_cb.rdata;
      end
	  item_collected_port.write(trans_collected);
      end 
  endtask : run_phase

endclass : fpu_monitor