//-------------------------------------------------------------------------
//						fpu_seq_item - www.verificationguide.com 
//-------------------------------------------------------------------------

class fpu_seq_item extends uvm_sequence_item;
  //---------------------------------------
  //data and control fields
  //---------------------------------------
  rand bit [5:0]  Address;
  rand bit        CS;
  rand bit        WE;
  rand bit        OE;
  rand bit [15:0] wdata;
       bit [15:0] rdata;
  
  //---------------------------------------
  //Utility and Field macros
  //---------------------------------------
  `uvm_object_utils_begin(fpu_seq_item)
    `uvm_field_int(Address,UVM_ALL_ON)
    `uvm_field_int(CS,UVM_ALL_ON) 
    `uvm_field_int(WE,UVM_ALL_ON)
    `uvm_field_int(OE,UVM_ALL_ON)
    `uvm_field_int(wdata,UVM_ALL_ON)
  `uvm_object_utils_end
  
  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "fpu_seq_item");
    super.new(name);
  endfunction
  
  //---------------------------------------
  //constaint, to generate any one among write and read
  //---------------------------------------
  constraint WE_OE_c { WE != OE; }; 
  //constraint CS_c { CS == 1; }; 
  
endclass