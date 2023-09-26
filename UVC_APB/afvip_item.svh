// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_item
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: It consist of data fields required for generating the stimulus.In order to generate the stimulus, the sequence items are randomized in sequences.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_item extends uvm_sequence_item;

// ---------------------- Signals -----------------
rand bit unsigned [3:0]     delay       ;   // Delay
rand int unsigned           prdata      ;   // Read data
rand int unsigned           pwdata      ;   // Write data
rand bit unsigned [15:0]    addr        ;   // Address
rand bit unsigned           direction   ;   // Pwrite
bit unsigned                pslverr     ;   // Slave error

`uvm_object_utils_begin (afvip_item)

// ------------- Utility and Field macros ---------------
`uvm_field_int (delay,     UVM_DEFAULT)
`uvm_field_int (addr,      UVM_DEFAULT)
`uvm_field_int (pwdata,    UVM_DEFAULT)
`uvm_field_int (prdata,    UVM_DEFAULT)
`uvm_field_int (direction, UVM_DEFAULT)
`uvm_field_int (pslverr,   UVM_DEFAULT)

`uvm_object_utils_end

// --------------------- Constructor ---------------------
function new(string itm = "afvip_item.svh");
super.new(itm);
endfunction : new 

endclass