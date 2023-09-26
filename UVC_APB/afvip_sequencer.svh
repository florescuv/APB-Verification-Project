// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_sequencer
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: Is a mediator who establishes a connection between sequence and driver. Ultimately, it passes transactions or sequence items to the driver so that they can be driven to the DUT.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_sequencer extends uvm_sequencer #(afvip_item);
    `uvm_component_utils (afvip_sequencer)

// ------------------------ Constructor ---------------------

    function new(string name="m_sequencer", uvm_component parent);
        super.new (name, parent);
    endfunction 

endclass