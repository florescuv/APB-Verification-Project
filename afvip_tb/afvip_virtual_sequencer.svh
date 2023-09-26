// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_virtual_sequencer
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: It generates data transactions as class objects and sends it to the driver for execution.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_virtual_sequencer extends uvm_sequencer;

//______________________________________________

    `uvm_component_utils(afvip_virtual_sequencer)
    afvip_sequencer m_seqr0;                                        // Initialize the apb sequencer
    afvip_rst_sequencer m_rst_seqr0;                                // Initialize the reset sequencer


     function new( string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
//___________________ build phase ___________________________

     function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase

endclass //afvip_virtual_sequencer 