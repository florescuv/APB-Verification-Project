// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_interface
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: It is a way to encapsulate signals into a block. All related signals are grouped together to form an interface block so that the same interface.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

interface afvip_interface
(
    input clk,
    input rst_n
);

import uvm_pkg::*;

wire               pready       ;
wire               pwrite       ;        
wire               psel         ;
wire               penable      ;
wire   [15:0]      paddr        ;
wire   [31:0]      prdata       ;
wire   [31:0]      pwdata       ;
wire               pslverr      ;


//clocking blocks

    clocking cb_apb @ ( posedge clk ); // master
output         psel          ;
output         penable       ;        
output         paddr         ;
output         pwrite        ;
output         pwdata        ;
input          prdata        ;
input          pready        ;
input          pslverr       ;
endclocking 


    clocking cb_monitor @ ( posedge clk );
input    psel          ;
input    penable       ;        
input    paddr         ;
input    pwrite        ;
input    pwdata        ;
input    pready        ;
input    prdata        ;
input    pslverr       ;
endclocking 


endinterface : afvip_interface