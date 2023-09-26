// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_passive_monitor
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: Is responsible for capturing signal activity from the design interface and translate it into transaction level data objects that can be sent to other components.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_passive_monitor extends uvm_monitor;
    
    `uvm_component_utils (afvip_passive_monitor)
    
    function new(string name = "afvip_passive_monitor", uvm_component parent = null);
        super.new (name, parent);
    endfunction 

// ------------------- create the handle -------------------------

virtual afvip_interrupt_interface vif;                  // Handle for interrupt virtual interface  
uvm_analysis_port #(afvip_inter_item) mon_analysis_port;

// __________________________ Build phase ________________________
virtual function void build_phase (uvm_phase phase);
super.build_phase (phase);

mon_analysis_port = new ("mon_analysis_port", this);

if (! uvm_config_db #(virtual afvip_interrupt_interface) :: get (this, "", "vif", vif )) begin
    `uvm_error (get_type_name (), "DUT interface not found")
end
endfunction : build_phase

// __________________________ BuiRunld phase ________________________

virtual task run_phase (uvm_phase phase);

afvip_inter_item data_passive_mon = afvip_inter_item::type_id::create ("data_passive_mon", this);   // Create the interrupt item for monitor

  @(posedge vif.rst_n);
        forever begin
            @(posedge vif.cb_mon_inter.afvip_intr);                          // Do the following instruction as long as we have posedge the interrupt 
            data_passive_mon.inter_itm = vif.cb_mon_inter.afvip_intr;        // Take the reset signal from the interface
            
            mon_analysis_port.write(data_passive_mon);
        end


endtask :run_phase

endclass : afvip_passive_monitor 