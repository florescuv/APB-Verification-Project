// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_rst_monitor
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: Is responsible for capturing signal activity from the design interface and translate it into transaction level data objects that can be sent to other components.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------


class afvip_rst_monitor extends uvm_monitor;
    
    `uvm_component_utils (afvip_rst_monitor)

// ------------------------------ Constructor -------------------------------------
    function new(string name = "afvip_rst_monitor", uvm_component parent = null);
        super.new (name, parent);
    endfunction 

// ------------------- create the handle -------------------------
virtual afvip_rst_interface vif_rst;                            // Handle for reset virtual interface 
uvm_analysis_port #(afvip_rst_item) mon_analysis_port_rst;

// _________________________ Build phase ___________________________________

virtual function void build_phase (uvm_phase phase);
super.build_phase (phase);

mon_analysis_port_rst = new ("mon_analysis_port_rst", this);

if (! uvm_config_db #(virtual afvip_rst_interface) :: get (this, "", "vif_rst", vif_rst )) begin
    `uvm_error (get_type_name (), "DUT interface not found")
end
endfunction : build_phase


// _________________________ Run phase ___________________________________

virtual task run_phase (uvm_phase phase);

afvip_rst_item data_rst_mon = afvip_rst_item::type_id::create ("data_rst_mon", this);       // Create the reset item for monitor

forever begin

    @ ( posedge vif_rst.intf_reset);
     $display(" %s ", data_rst_mon.sprint ());
    mon_analysis_port_rst.write(data_rst_mon);  //de modif maybe

   end

endtask :run_phase

endclass 