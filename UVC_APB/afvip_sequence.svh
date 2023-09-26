// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_sequence
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: container that holds data items (uvm_sequence_items) which are sent to the driver via the sequencer.
// Date       : 28 June, 2023
// It is currently unused because we use sequence lib.
// ---------------------------------------------------------------------------------------------------------------------

class afvip_sequence extends uvm_sequence;
    
   `uvm_object_utils (afvip_sequence) 
    
    
    function new(string name = "afvip_sequence");
        super.new(name);
    endfunction 


    virtual task body(); 
   afvip_item itm;
   itm = afvip_item::type_id::create("itm");

   for(int i=0; i<=31; i++) begin
   start_item(itm);
   if(!((itm.randomize()) with {delay inside {[1:5]};
                                pwdata == i ;
                                pwrite inside {[0:1]};  //32908  32768
                                addr [1:0]  == 0 ;
                                direction == 1   ;
                               // addr   inside {[32'h0:'h19],[32'h21:32'h8c]};
                               // addr == 16'h88;
                               }))
   `uvm_error(get_type_name(), "Rand error")
   finish_item(itm);
   
   start_item (itm);
    itm.direction = 0 ; 
    finish_item(itm);
    end
    endtask : body


endclass //afvip_sequence
