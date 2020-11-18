//-------------------------------------------------------------------------
//						fpu_scoreboard - www.verificationguide.com 
//-------------------------------------------------------------------------

class fpu_scoreboard extends uvm_scoreboard;
  
  //---------------------------------------
  // declaring pkt_qu to store the pkt's recived from monitor
  //---------------------------------------
  fpu_seq_item pkt_qu[$];
  
  //---------------------------------------
  // sc_fpu 
  //---------------------------------------
  bit [15:0] sc_fpu [64];

  //---------------------------------------
  //port to recive packets from monitor
  //---------------------------------------
  uvm_analysis_imp#(fpu_seq_item, fpu_scoreboard) item_collected_export;
  `uvm_component_utils(fpu_scoreboard)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  //---------------------------------------
  // build_phase - create port and initialize local fpuory
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      item_collected_export = new("item_collected_export", this);
    foreach(sc_fpu[i]) sc_fpu[i] = 16'h0000;
  endfunction: build_phase
  
  //---------------------------------------
  // write task - recives the pkt from monitor and pushes into queue
  //---------------------------------------
  virtual function void write(fpu_seq_item pkt);
    pkt.print();
    pkt_qu.push_back(pkt);
  endfunction : write

  //---------------------------------------
  // run_phase - compare's the read data with the expected data(stored in local fpuory)
  // local fpuory will be updated on the write operation.
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    fpu_seq_item fpu_pkt;
    
    forever begin
      wait(pkt_qu.size() > 0);
      fpu_pkt = pkt_qu.pop_front();
      if(~fpu_pkt.CS)begin
        if(~fpu_pkt.WE) begin
          sc_fpu[fpu_pkt.Address] = fpu_pkt.wdata;
          `uvm_info(get_type_name(),$sformatf("------ :: WRITE DATA       :: ------"),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Addr: %0h",fpu_pkt.Address),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Data: %0h",fpu_pkt.wdata),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)        
        end
        else if(~fpu_pkt.OE) begin
          if(sc_fpu[fpu_pkt.Address] == fpu_pkt.rdata) begin
            `uvm_info(get_type_name(),$sformatf("------ :: READ DATA Match :: ------"),UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("Addr: %0h",fpu_pkt.Address),UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_fpu[fpu_pkt.Address],fpu_pkt.rdata),UVM_LOW)
            `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
          end
          else begin
            `uvm_error(get_type_name(),"------ :: READ DATA MisMatch :: ------")
            `uvm_info(get_type_name(),$sformatf("Addr: %0h",fpu_pkt.Address),UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_fpu[fpu_pkt.Address],fpu_pkt.rdata),UVM_LOW)
            `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
          end
        end
      end
    end
  endtask : run_phase
endclass : fpu_scoreboard