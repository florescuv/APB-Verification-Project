// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_inter_item
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: It consist of data fields required for generating the stimulus.In order to generate the stimulus, the sequence items are randomized in sequences.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_inter_item extends uvm_sequence_item;

 reg inter_itm;


`uvm_object_utils_begin (afvip_inter_item)

`uvm_field_int (inter_itm,     UVM_DEFAULT)


`uvm_object_utils_end

function new(string inter_itm = "afvip_inter_item.svh");
super.new(inter_itm);
endfunction : new 

endclass