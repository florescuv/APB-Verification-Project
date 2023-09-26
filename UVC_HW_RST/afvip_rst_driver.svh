// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_rst_driver
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: UVM driver is an active entity that has knowledge on how to drive signals to a particular interface of the design.
//              Is the place where the protocols are realized to be tested.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_rst_driver extends uvm_driver #(afvip_rst_item);
   
   `uvm_component_utils (afvip_rst_driver)

    function new(string name= "afvip_rst_driver", uvm_component parent = null );
        super.new (name, parent);
    endfunction 

// ------------------- create the handle -------------------------

virtual afvip_rst_interface vif_rst;  // Handle for reset virtual interface  
afvip_rst_item data_rst_project;      // Handle for reset item

virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if( ! uvm_config_db #(virtual afvip_rst_interface) :: get (this, "", "vif_rst", vif_rst)) begin
    `uvm_fatal (get_type_name (), "Didn't get handle to virtual interface afvip_interface")
    end
endfunction 

// ________________________ run phase _____________________________

virtual task run_phase(uvm_phase phase);
forever begin
    
    seq_item_port.get_next_item(data_rst_project);
    vif_rst.intf_reset <= data_rst_project.intf_reset;     // drive the reset signal 
    seq_item_port.item_done();

end 

endtask


endclass 
