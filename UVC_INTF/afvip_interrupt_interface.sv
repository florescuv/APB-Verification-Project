// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_interrupt_interface
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: It is a way to encapsulate signals into a block. All related signals are grouped together to form an interface block so that the same interface.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

interface afvip_interrupt_interface

(
    input clk,
    input rst_n
);

reg afvip_intr;

   clocking cb_mon_inter @ ( posedge clk ); 

    input afvip_intr;

endclocking


endinterface : afvip_interrupt_interface