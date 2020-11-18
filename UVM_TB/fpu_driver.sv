//-------------------------------------------------------------------------
//						mem_driver - www.verificationguide.com
//-------------------------------------------------------------------------

`define DRIV_IF vif.DRIVER.driver_cb

class mem_driver extends uvm_driver #(mem_seq_item);

  //--------------------------------------- 
  // Virtual Interface
  //--------------------------------------- 
  virtual mem_if vif;
  `uvm_component_utils(mem_driver)
    
  //--------------------------------------- 
  // Constructor
  //--------------------------------------- 
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //--------------------------------------- 
  // build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual mem_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  //---------------------------------------  
  // run phase
  //---------------------------------------  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask : run_phase
  
  //---------------------------------------
  // drive - transaction level to signal level
  // drives the value's from seq_item to interface signals
  //---------------------------------------
  virtual task drive();
    `DRIV_IF.WE <= 1;
    `DRIV_IF.OE <= 1;
    `DRIV_IF.CS <= 1;
    @(posedge vif.DRIVER.clk);
    
    `DRIV_IF.Address <= req.Address;
    
    if(~req.WE) begin // write operation
      `DRIV_IF.WE <= req.WE;
      `DRIV_IF.CS <= req.CS;
      `DRIV_IF.wdata <= req.wdata;
      @(posedge vif.DRIVER.clk);
    end
    else if(~req.OE) begin //read operation
      `DRIV_IF.OE <= req.OE;
      `DRIV_IF.CS <= req.CS;
      @(posedge vif.DRIVER.clk);
      `DRIV_IF.OE <= 1;
      @(posedge vif.DRIVER.clk);
      req.rdata = `DRIV_IF.rdata;
    end

  endtask : drive
endclass : mem_driver