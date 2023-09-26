// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_passive_agent_interrupt
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: An agent encapsulates a Sequencer and Monitor into a single entity by instantiating and connecting the components together via interfaces.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_passive_agent_interrupt extends uvm_agent;

// --------------- Create handles to all agent components ( monitor ) --------------- 

  afvip_passive_monitor mon_passive;
  
  `uvm_component_utils(afvip_passive_agent_interrupt)
  
  function new(string name = "afvip_passive_agent_interrupt", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
// ______________________________ Build phase _________________________________
// ---------------------- Build the driver, seuqncer --------------------------
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_PASSIVE) begin
     
      mon_passive = afvip_passive_monitor::type_id::create("mon_passive", this);

      `uvm_info(get_name(), "This is Passive agent", UVM_LOW);
    end
  endfunction
endclass