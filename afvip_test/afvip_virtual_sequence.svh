// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_virtual_sequencer
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: It is a container to start multiple sequences on different sequencers in the environment. 
//              This virtual sequence is usually executed by a virtual sequcencer which has handles to real sequencers.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_base_vsequence extends uvm_sequence#(uvm_sequence_item);
    `uvm_object_utils(afvip_base_vsequence)
    `uvm_declare_p_sequencer(afvip_virtual_sequencer)

    function new(string name = "afvip_base_vsequence");
      super.new(name);
    endfunction : new

endclass : afvip_base_vsequence
  
  class apb_rw_sequence extends afvip_base_vsequence;
    `uvm_object_utils(apb_rw_sequence)

    typedef afvip_apb_sequence apb_obj_sequence;
    function new(string name = "apb_rw_sequence");
      super.new(name);
    endfunction : new
  
    task body();
      apb_obj_sequence afvip_apb_sequence;
      afvip_apb_sequence = apb_obj_sequence::type_id::create("afvip_apb_sequence");
      afvip_apb_sequence.start(p_sequencer.m_seqr0);
    endtask : body
    
  endclass : apb_rw_sequence