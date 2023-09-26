// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_rst_item
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: It consist of data fields required for generating the stimulus.In order to generate the stimulus, the sequence items are randomized in sequences.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_rst_item extends uvm_sequence_item;

rand bit unsigned  intf_reset;

`uvm_object_utils_begin (afvip_rst_item)

// ------------- Utility and Field macros ---------------
`uvm_field_int (intf_reset,     UVM_DEFAULT)

`uvm_object_utils_end

// --------------------- Constructor ---------------------
function new(string rst_itm = "afvip_rst_item.svh");
super.new(rst_itm);
endfunction : new 

endclass