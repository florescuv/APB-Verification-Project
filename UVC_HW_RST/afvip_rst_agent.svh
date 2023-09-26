// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_rst_agent
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: An agent encapsulates a Sequencer, Driver and Monitor into a single entity by instantiating and connecting the components together via interfaces.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_rst_agent extends uvm_agent;

`uvm_component_utils (afvip_rst_agent)

function new (string name = "afvip_rst_agent", uvm_component parent = null) ;
    super.new (name, parent);
endfunction

// --------------- Create handles to all agent components ( driver, monitor, sequencer ) --------------- 

afvip_rst_driver                        m_rst_drv0;
afvip_rst_monitor                       m_rst_mon0;
afvip_rst_sequencer                     m_rst_seqr0;

// ______________________________ Build phase _________________________________
// ---------------------- Build the driver, seuqncer --------------------------

virtual function void build_phase (uvm_phase phase);
    if (get_is_active ()) begin
        
        m_rst_seqr0 = afvip_rst_sequencer::type_id::create("m_rst_seqr0", this); 
        m_rst_drv0 = afvip_rst_driver::type_id::create("m_rst_drv0", this);
    
    end

// ---------------------- Build the monitor ------------------------------------

m_rst_mon0 = afvip_rst_monitor::type_id::create ("m_rst_mon0", this);
endfunction

// __________________________Connect phase _____________________________________
// ---------------------- Connect the driver to the sequencer ( if is active ) ------------------------------------

virtual function void connect_phase (uvm_phase phase);
 if(get_is_active())
 m_rst_drv0.seq_item_port.connect (m_rst_seqr0.seq_item_export);

endfunction


endclass
