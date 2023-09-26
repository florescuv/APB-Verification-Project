// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_environment
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: UVM environment have multiple agents for different interfaces, a common scoreboard, a functional coverage collector.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_environment extends uvm_env;  
    `uvm_component_utils (afvip_environment)

 //--------------------------- class handles -----------------------------------------
afvip_agent agent0;                              // Create the apb agent handle
afvip_passive_agent_interrupt agent_passive;     // Create the interrupt agent handle
afvip_rst_agent agent_rst;                       // Create the reset agent handle
afvip_coverage coverage_h;                       // Create the apb coverage handle
afvip_inter_coverage coverage_int;               // Create the interrupt coverage handle
afvip_scoreboard scoreboard0;                    // Create the scoreboard handle

    function new(string name = "afvip_environment", uvm_component parent = null);
        super.new (name, parent);
    endfunction

//------------------------------ build phase -----------------------------------------

virtual function void build_phase (uvm_phase phase);
super.build_phase (phase); 

agent0 = afvip_agent::type_id::create("agent0", this);                                          // Create the apb agent 
agent_passive = afvip_passive_agent_interrupt::type_id::create("agent_passive", this);          // Create the interrupt agent 
agent_rst = afvip_rst_agent::type_id::create("agent_rst", this);                                // Create the reset agent 
coverage_h = afvip_coverage::type_id::create("coverage_h",this);                                // Create the apb coverage 
coverage_int = afvip_inter_coverage::type_id::create("coverage_int", this);                     // Create the interrupt coverage 

uvm_config_db #(uvm_active_passive_enum)::set(this, "agent_passive", "is_active", UVM_PASSIVE); // Declaration of interrupt passive agent 
scoreboard0 = afvip_scoreboard::type_id::create("scoreboard0", this);                           // Create the project scoreboard

endfunction 

  //-------------------------- connect phase -----------------------------------

virtual function void connect_phase (uvm_phase phase);
super.connect_phase (phase);
 agent0.m_mon0.mon_analysis_port.connect(scoreboard0.ap_imp);                       //connect the anasysis port from apb agent to the scoreboard 
 agent_passive.mon_passive.mon_analysis_port.connect(scoreboard0.ap_imp_interrupt); //connect the anasysis port from passive agent to the scoreboard 
 agent_rst.m_rst_mon0.mon_analysis_port_rst.connect(scoreboard0.ap_imp_reset);      //connect the anasysis port from reset agent to the scoreboard 
//agent_passive.data_passive_mon.mon_analysis_port.connect(scoreboard0);

 agent0.m_mon0.mon_analysis_port.connect(coverage_h.analysis_export);               // Connect functional apb coverage component with analysis ports
 agent_passive.mon_passive.mon_analysis_port.connect(coverage_int.analysis_export); // Connect functional interrupt coverage component with analysis ports

endfunction

endclass : afvip_environment