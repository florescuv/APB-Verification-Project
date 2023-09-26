// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_inter_coverage
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description:It is a user-defined metric that measures how much of the design specification that are captured in the test plan has been exercised.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_inter_coverage extends uvm_subscriber #(afvip_inter_item);  // taken from monitor

  `uvm_component_utils(afvip_inter_coverage)

  function new(string name="afvip_inter_coverage",uvm_component parent);
    super.new(name,parent);
    dut_cov_intr             =new();

  endfunction


  afvip_inter_item cov_proj_item_intr     ;
  real  cov_interrupt           ;
  
// __________________ COVERGROUP FOR PSLVERR ________________________
  covergroup dut_cov_intr;
  INTERRUPT: coverpoint cov_proj_item_intr.inter_itm {
    bins interval1 = {0};
    bins interval2 = {1};
  }
  endgroup

 function void write(afvip_inter_item t);
    cov_proj_item_intr = t;
    dut_cov_intr.sample();
    
  endfunction

  // __________________ Extract Phase ________________________

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov_interrupt=dut_cov_intr.get_coverage();

    endfunction


    function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Coverage for INTERRUPT is %f",cov_interrupt),UVM_MEDIUM)
    endfunction 

endclass : afvip_inter_coverage

