// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_coverage
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: It is a user-defined metric that measures how much of the design specification that are captured in the test plan has been exercised.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_coverage extends uvm_subscriber #(afvip_item);  // taken from monitor

  `uvm_component_utils(afvip_coverage)

 // __________________ Super function ________________________
  
  function new(string name="afvip_coverage",uvm_component parent);
    super.new(name,parent);
    dut_cov_reg             =new();      
    dut_cov_data            =new();   
    dut_cov_register_opcode =new();   
    dut_cov_register_rs0    =new();   
    dut_cov_register_rs1    =new();   
    dut_cov_register_dst    =new();   
    dut_cov_register_imm    =new();   
    dut_cov_pwrite          =new();   
    dut_cov_read_data       =new();   
    dut_cov_delay           =new();   
    dut_cov_pslverr         =new();   

  endfunction

  afvip_item cov_proj_item     ;  

  real  cov_register           ;  // Variables to hold the coverage for ADDRESS
  real  cov_pwdata             ;  // Variables to hold the coverage for PWDATA
  real  cov_register_opcode    ;  // Variables to hold the coverage for OPCODE
  real  cov_register_rs0       ;  // Variables to hold the coverage for RS0
  real  cov_register_rs1       ;  // Variables to hold the coverage for RS1 
  real  cov_register_dst       ;  // Variables to hold the coverage for DST
  real  cov_register_imm       ;  // Variables to hold the coverage for IMM
  real  cov_pwrite             ;  // Variables to hold the coverage for PWRITE
  real  cov_read_data          ;  // Variables to hold the coverage for PRDATA
  real  cov_delay              ;  // Variables to hold the coverage for DELAY
  real  cov_pslverr            ;  // Variables to hold the coverage for PSLVERR

// __________________ COVERGROUP FOR PSLVERR ________________________
  covergroup dut_cov_pslverr;
  PSLVERR: coverpoint cov_proj_item.pslverr {
      bins interval1 = {0};
      bins interval2 = {1};
  }
  endgroup

// __________________ COVERGROUP FOR PWRITE ________________________

  covergroup dut_cov_pwrite;
    PWRITE: coverpoint cov_proj_item.direction {
        bins first_val   = {0};
        bins sec_val     = {1};
    }

  endgroup

  // __________________ COVERGROUP FOR delay ________________________

  covergroup dut_cov_delay;
    DELAY: coverpoint cov_proj_item.delay {
        bins min_val          = {0};
        bins max_val          = {4'd15};
        bins interval [8]     = {[4'd1:4'd8]};
        bins interval2[5]     = {[4'd9:4'd14]};
    }
  endgroup

// __________________ COVERGROUP FOR READ DATA ________________________

  covergroup dut_cov_read_data;
    ADDR: coverpoint cov_proj_item.prdata {

        bins prdata_1   [1]  = {['h0:       'h7FFFFFF ]};
        bins prdata_2   [1]  = {['h8000000: 'hFFFFFFF ]};
        bins prdata_3   [1]  = {['h10000000:'h17FFFFFF]} ;
        bins prdata_4   [1]  = {['h18000000:'h1FFFFFFF]} ;
        bins prdata_5   [1]  = {['h20000000:'h27FFFFFF]} ;
        bins prdata_6   [1]  = {['h28000000:'h2FFFFFFF]} ;
        bins prdata_7   [1]  = {['h30000000:'h37FFFFFF]} ;
        bins prdata_8   [1]  = {['h38000000:'h3FFFFFFF]} ;
        bins prdata_9   [1]  = {['h40000000:'h4FFFFFFF]} ;
        bins prdata_10  [1]  = {['h48000000:'h4FFFFFFF]} ;
        bins prdata_11  [1]  = {['h50000000:'h57FFFFFF]} ;
        bins prdata_12  [1]  = {['h58000000:'h5FFFFFFF]} ;
        bins prdata_13  [1]  = {['h60000000:'h67FFFFFF]} ;
        bins prdata_14  [1]  = {['h68000000:'h6FFFFFFF]} ;
        bins prdata_15  [1]  = {['h70000000:'h77FFFFFF]} ;
        bins prdata_16  [1]  = {['h78000000:'h7FFFFFFF]} ;
        bins prdata_17  [1]  = {['h80000000:'h87FFFFFF]} ;
        bins prdata_18  [1]  = {['h88000000:'h8FFFFFFF]} ;
        bins prdata_19  [1]  = {['h90000000:'h97FFFFFF]} ;
        bins prdata_20  [1]  = {['h98000000:'hFFFFFFFF]} ;
    }
endgroup

// __________________ COVERGROUP FOR ADDRESS ________________________

covergroup dut_cov_reg;

      ADDR: coverpoint cov_proj_item.addr {
        bins reg00 ={'h00};
        bins reg01 ={'h04};
        bins reg02 ={'h08};
        bins reg03 ={'h0c};
        bins reg04 ={'h10};
        bins reg05 ={'h14};
        bins reg06 ={'h18};
        bins reg07 ={'h1c};
        bins reg08 ={'h20};
        bins reg09 ={'h24};
        bins reg10 ={'h28};
        bins reg11 ={'h2c};
        bins reg12 ={'h30};
        bins reg13 ={'h34};
        bins reg14 ={'h38};
        bins reg15 ={'h3c};
        bins reg16 ={'h40};
        bins reg17 ={'h44};
        bins reg18 ={'h48};
        bins reg19 ={'h4c};
        bins reg20 ={'h50};
        bins reg21 ={'h54};
        bins reg22 ={'h58};
        bins reg23 ={'h5c};
        bins reg24 ={'h60};
        bins reg25 ={'h64};
        bins reg26 ={'h68};
        bins reg27 ={'h6c};
        bins reg28 ={'h70};
        bins reg29 ={'h74};
        bins reg30 ={'h78};
        bins reg31 ={'h7c};
     }
  endgroup:dut_cov_reg;

// __________________ COVERGROUP FOR OPCODE ________________________

  covergroup dut_cov_register_opcode;
  
  ADDR:coverpoint cov_proj_item.pwdata[2:0] {
        bins opcode_interval1    = {0};
        bins opcode_interval2    = {1};
        bins opcode_interval3    = {2};    
        bins opcode_interval4    = {3};
        bins opcode_interval5    = {4};
        illegal_bins last_opc = {[3'd5:3'd7]};
  }
  endgroup

  // __________________ COVERGROUP FOR RS0 ________________________

  covergroup dut_cov_register_rs0;

  ADDR:coverpoint cov_proj_item.pwdata[7:3] {
        bins min_value            = {0};
        bins max_value            = {31};
        bins rs0_interval [15]    = {[5'd1:5'd15]};
        bins rs0_interval2[14]    = {[5'd16:5'd30]}; 
  }
  endgroup

  // __________________ COVERGROUP FOR RS1 ________________________

  covergroup dut_cov_register_rs1;
  
  ADDR:coverpoint cov_proj_item.pwdata[12:8] {
        bins min_value          = {0};
        bins max_value          = {31};
        bins rs1_interval [15]  = {[5'd1:5'd15]};
        bins rs1_interval2[14]  = {[5'd16:5'd30]}; 
  }
  endgroup

    // __________________ COVERGROUP FOR DST ________________________

  covergroup dut_cov_register_dst;
  
  ADDR:coverpoint cov_proj_item.pwdata[20:16] {
        bins min_value         = {0};
        bins max_value         = {31};
        bins dst_interval [15] = {[5'd1:5'd15]};
        bins dst_interval2[14] = {[5'd16:5'd30]}; 
  }
  endgroup


    // __________________ COVERGROUP FOR IMM ________________________

  covergroup dut_cov_register_imm;
  
  ADDR:coverpoint cov_proj_item.pwdata[31:24] {

        bins zero = {'d0};
        bins max_value = {'d255};
        bins value_1 [10]= {[8'd1:8'd50]};
        bins value_2 [10]= {[8'd51:8'd100]};
        bins value_3 [10]= {[8'd101:8'd150]};
        bins value_4 [10]= {[8'd151:8'd200]};
        bins value_5 [10]= {[8'd201:8'd254]};
  }
  endgroup

  // __________________ COVERGROUP FOR PWDATA ________________________

     covergroup dut_cov_data;
      PWDATA: coverpoint cov_proj_item.pwdata {

        bins pwdata_1   = {['h0:       'h7FFFFFF ]};
        bins pwdata_2   = {['h8000000: 'hFFFFFFF ]};
        bins pwdata_3   = {['h10000000:'h17FFFFFF]} ;
        bins pwdata_4   = {['h18000000:'h1FFFFFFF]} ;
        bins pwdata_5   = {['h20000000:'h27FFFFFF]} ;
        bins pwdata_6   = {['h28000000:'h2FFFFFFF]} ;
        bins pwdata_7   = {['h30000000:'h37FFFFFF]} ;
        bins pwdata_8   = {['h38000000:'h3FFFFFFF]} ;
        bins pwdata_9   = {['h40000000:'h4FFFFFFF]} ;
        bins pwdata_10  = {['h48000000:'h4FFFFFFF]} ;
        bins pwdata_11  = {['h50000000:'h57FFFFFF]} ;
        bins pwdata_12  = {['h58000000:'h5FFFFFFF]} ;
        bins pwdata_13  = {['h60000000:'h67FFFFFF]} ;
        bins pwdata_14  = {['h68000000:'h6FFFFFFF]} ;
        bins pwdata_15  = {['h70000000:'h77FFFFFF]} ;
        bins pwdata_16  = {['h78000000:'h7FFFFFFF]} ;
        bins pwdata_17  = {['h80000000:'h87FFFFFF]} ;
        bins pwdata_18  = {['h88000000:'h8FFFFFFF]} ;
        bins pwdata_19  = {['h90000000:'h97FFFFFF]} ;
        bins pwdata_20  = {['h98000000:'hFFFFFFFF]} ;
      }

   endgroup : dut_cov_data;

//----------------------------------------------------------------------------


// __________________ Write method ________________________  
//---------------- sample the coverage ----------------------------
 function void write(afvip_item t);
    cov_proj_item = t;
    dut_cov_data.sample()     ;
    dut_cov_reg.sample()      ;
    dut_cov_pwrite.sample()   ;
    dut_cov_read_data.sample();
    dut_cov_delay.sample()    ;
    dut_cov_pslverr.sample()  ;

    if(t.addr == 31'h80) begin 
    dut_cov_register_rs0.sample();
    dut_cov_register_rs1.sample();
    dut_cov_register_dst.sample();
    dut_cov_register_imm.sample();
 
     end 
  endfunction

  // __________________ Extract Phase ________________________

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov_register=dut_cov_reg.get_coverage()              ;
    cov_pwdata=dut_cov_data.get_coverage()              ;
    cov_register_rs0=dut_cov_register_rs0.get_coverage() ;
    cov_register_rs1=dut_cov_register_rs1.get_coverage() ;
    cov_register_dst=dut_cov_register_dst.get_coverage() ;
    cov_register_imm=dut_cov_register_imm.get_coverage() ;
    cov_pwrite=dut_cov_pwrite.get_coverage()             ;
    cov_read_data=dut_cov_read_data.get_coverage()       ;
    cov_delay=dut_cov_delay.get_coverage()               ;
    cov_pslverr=dut_cov_pslverr.get_coverage()           ;
  endfunction

  // __________________ Report phase ________________________

 function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Coverage for ADDR is %f",cov_register),UVM_MEDIUM)
    `uvm_info(get_type_name(),$sformatf("Coverage for PWDATA is %f",cov_pwdata),UVM_MEDIUM)
    `uvm_info(get_type_name(),$sformatf("Coverage for PRDATA is %f",cov_read_data),UVM_MEDIUM) 
    `uvm_info(get_type_name(),$sformatf("Coverage for PWRITE is %f",cov_pwrite),UVM_MEDIUM)        
    `uvm_info(get_type_name(),$sformatf("Coverage for RS0 is %f",cov_register_rs0),UVM_MEDIUM)
    `uvm_info(get_type_name(),$sformatf("Coverage for RS1 is %f",cov_register_rs1),UVM_MEDIUM)
    `uvm_info(get_type_name(),$sformatf("Coverage for DST is %f",cov_register_dst),UVM_MEDIUM)
    `uvm_info(get_type_name(),$sformatf("Coverage for IMM is %f",cov_register_imm),UVM_MEDIUM)
    `uvm_info(get_type_name(),$sformatf("Coverage for DELAY is %f",cov_delay),UVM_MEDIUM)
    `uvm_info(get_type_name(),$sformatf("Coverage for PSLVERR is %f",cov_pslverr),UVM_MEDIUM)
  endfunction
  //----------------------------------------------------------------------------
  
endclass : afvip_coverage

