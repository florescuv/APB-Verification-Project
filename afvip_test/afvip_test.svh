// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_test
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: It is a pattern to check and verify specific features and functionalities of a design. 
//              A verification plan lists all the features and other functional items that needs to be verified, and the tests neeeded to cover each of them.
// Date       : 28 June, 2023
// Currently unused because we add all this part on afvip_test_lib.
// ---------------------------------------------------------------------------------------------------------------------

class afvip_test extends uvm_test;

`uvm_component_utils (afvip_test)
    
    function new(string name = "afvip_test", uvm_component parent = null);
        super.new (name, parent);
    endfunction


afvip_environment m_top_env;

virtual function void build_phase (uvm_phase phase);
super.build_phase (phase);
m_top_env = afvip_environment::type_id::create("m_top_env", this);
endfunction

virtual task run_phase (uvm_phase phase);

afvip_sequence afvip_sequence = afvip_sequence::type_id::create ("seq");
afvip_rst_sequence afvip_rst_sequence = afvip_rst_sequence::type_id::create ("seq_rst");

phase.raise_objection (this);

fork
    afvip_sequence.start(m_top_env.agent0.m_seqr0);
    afvip_rst_sequence.start(m_top_env.agent_rst.m_rst_seqr0);
join
phase.drop_objection (this);

endtask 

endclass : afvip_test