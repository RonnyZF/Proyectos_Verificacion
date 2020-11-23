//----------------Inicio de Agente Activo--------------------------//
class fpu_agent_active extends uvm_agent;
  `uvm_component_utils(fpu_agent_active)
  function new(string name="fpu_agent_active", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  //instacias
  virtual fpu_intf intf;
  fpu_driver fpu_drv;
  uvm_sequencer #(fpu_item)	fpu_seqr;
  fpu_monitor_op fpu_mntr_op;

  //Creacion de los 3 objetos activos
  virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    
  if(uvm_config_db #(virtual fpu_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) 
  begin
    `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
  end
    
  fpu_drv = fpu_driver::type_id::create ("fpu_drv", this); 
    
  fpu_seqr = uvm_sequencer#(fpu_item)::type_id::create("fpu_seqr", this);
    
  fpu_mntr_op = fpu_monitor_op::type_id::create ("fpu_mntr_op", this);
    
  endfunction

  //Conexion de sequencer con driver 
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    fpu_drv.seq_item_port.connect(fpu_seqr.seq_item_export);
  endfunction
endclass
//-------------------FIN de Agente Activo--------------------------//
//-----------------------------------------------------------------//
//----------------Inicio de Agente Pasivo--------------------------//

class fpu_agent_passive extends uvm_agent;
  `uvm_component_utils(fpu_agent_passive)
  function new(string name="fpu_agent_passive", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  //instancias
  virtual fpu_intf intf;
  fpu_monitor_read fpu_mntr_read;

  //Creacion del objeto pasivo
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
  if(uvm_config_db #(virtual fpu_intf)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) 
    begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
  fpu_mntr_read = fpu_monitor_read::type_id::create ("fpu_mntr_read", this);
  endfunction

  //No hay conexion
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
//-------------------FIN de Agente Pasivo --------------------------//
endclass
