// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_rst_sequence
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: Is a container that holds data items (uvm_sequence_items) which are sent to the driver via the sequencer.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_rst_sequence extends uvm_sequence;
    
   `uvm_object_utils (afvip_rst_sequence) 
    
    function new(string name = "afvip_rst_sequence");
        super.new(name);
    endfunction 

    virtual task body(); 

   afvip_rst_item afvip_rst_item1;                                          // create the reset handle 

   afvip_rst_item1 = afvip_rst_item::type_id::create("afvip_rst_item1");    // create the ereset item 

// ---------------------------- Generate the waveform of reset ------------------------
   start_item(afvip_rst_item1);                                             
   afvip_rst_item1.intf_reset = 0;
 
   finish_item (afvip_rst_item1);
   #20;
   start_item (afvip_rst_item1);
    afvip_rst_item1.intf_reset = 1 ;
   finish_item(afvip_rst_item1);
    
    endtask 


endclass 
