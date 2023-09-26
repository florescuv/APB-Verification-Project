// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_top_verification
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: All verification components, interfaces and DUT are instantiated in a top level module called testbench. 
//              It is a static container to hold everything required to be simulated and becomes the root node in the hierarchy.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

module afvip_top_verification;

`include "uvm_macros.svh"


import uvm_pkg::*;
import afvip_package::*;
import afvip_intr_package::*;
import afvip_tb_package::*;
import afvip_hw_rst_package::*;
import afvip_test_package::*;


bit        clk             ;         // Clock
reg        rst_n           ;         // Asynchronous Reset - Active low
reg        psel            ;         // Selector
reg        penable         ;         // Enable
reg [31:0] pwdata          ;         // Write data
reg [15:0] paddr           ;         // Address
reg        pready          ;         // Ready
reg        pwrite          ;         // Write data
reg [31:0] prdata          ;         // READ DATA
reg        afvip_intr      ;         // APB INTERRUPT 
reg        pslverr         ;         // Slave error

// ------------------------   --------------------------------
afvip_interface afvip_if (.clk(clk),
                          .rst_n(rst_n));    
    
afvip_interrupt_interface afvip_int_if (.clk(clk),
                                        .rst_n(rst_n));  

afvip_rst_interface afvip_rst_if (.clk(clk));  

// ------------------------ Connection with DUT --------------------------------

afvip_top #(.TP(0)
    )alu_dut(

        .clk        (clk)       ,
        .rst_n      (rst_n)     ,
        .afvip_intr (afvip_intr),
        .psel       (psel)      ,
        .penable    (penable)   ,
        .paddr      (paddr)     ,
        .pwrite     (pwrite)    ,
        .pwdata     (pwdata)    ,
        .pready     (pready)    ,
        .prdata     (prdata)    ,
        .pslverr    (pslverr)
    );

// ------------------------ Generate the clock --------------------------------

initial begin 
forever 
    #5 clk = ~clk;
end

// ------------------------ Instantiate and connect to interface  --------------------------------

initial begin
    uvm_config_db#(virtual afvip_interface)::set(uvm_root::get(), "*.agent0.*", "vif", afvip_if);                           // APB Interface
    uvm_config_db#(virtual afvip_interrupt_interface)::set(uvm_root::get(), "*.agent_passive.*", "vif", afvip_int_if);      // Interrupt Interface
    uvm_config_db#(virtual afvip_rst_interface)::set(uvm_root::get(), "*.agent_rst.*", "vif_rst", afvip_rst_if);            // Reset Interface

// ------------------------ Run the tests --------------------------------

// run_test("reset_read_all_reg_test");                                                  // # 1 test  if we have reset, all the registers must have the default values
// run_test("write_reset_read_test");                                                    // # 2 test  we check if after reset the signals is correct 
// run_test("afvip_write_FFF_test");                                                     // # 3 test  we have to set the value of all registers to some specific data (FFFF)
// run_test("afvip_write_0_test");                                                       // # 4 test  we have to set the value of all registers to some specific data (0)
// run_test("read_all_write_all_read_all_test");                                         // # 5 test  to see if the data is read / write correctly
// run_test("afvip_write_all_err_data_not_mul_4_test");                                  // # 6 test  check if the addresses meet the required conditions (multiple of 4) 
// run_test("afvip_opcodeX2_op");                                                        // # 7 test  check if the interrupt must be raised in minimum 10 cycles from APB transfer completion 
// run_test("opcode_6_err_test");                                                        // # 8 test  check what happened if we assign opcode 'd5, 'd6, 'd7
// run_test("afvip_opcode_seq_err_put0_on_restricted_bits_test");                        // # 9 test  check what happened if we assign something on restricted bits (where should be 0)   
// run_test("afvip_opcode_test");                                                       // # 10 test  check if the opcode requirements is right and do it with 500 iteration ( to match all possible opcodes)
// run_test("afvip_opcode_same_dest_address_test");                                     // # 11 test  put the same destination address for opcode
// run_test("afvip_opcode_seq_overlapped_test");                                        // # 12 test  If the arithmetic operation result exceeds 32 bits, the result written in the destination register will be overlapped
// run_test("afvip_opcode_seq_overlapped_test_with_adder");                             // # 13 test  If the arithmetic operation result exceeds 32 bits, the result written in the destination register will be overlapped
// run_test("write_d24_write_test");                                                    // # 14 test   write one register, and read multiples to see if it is some issues
// run_test("write_until_addr15_read_that_addr_reset_write_and_read_all_test");         // # 15 test  Write all adress until 15 and read that address, reset, write all and read all 
// run_test("write_all_read_all_with_back2_back_test");                                 // # 16 test  back to back transaction with delay 0 (for 10 times )
// run_test("write_all_read_all_with_back2_back_10x_rounds_test");                      // # 17 test  back to back transaction with delay 0
// run_test("read_all_no_write_test");                                                  // # 18 test  read all registers withoud writing anything
// run_test("read_all_write_all_test");                                                 // # 19 test  read all and write all test
// run_test("no_read_no_write_test");                                                   // # 20 test  no read no write just reset  test
// run_test("afvip_write_all_with_delay_3_test");                                       // # 21 test  set the transaction delay for a specific number ( 3 ) [and write ]
// run_test("afvip_write_all_with_delay_between_0_and_3_test");                         // # 22 test  set the transaction delay for a random number [and write]
// run_test("read_none_write_all_test");                                                // # 23 test  read no register and write all test
// run_test("afvip_write_all_function_dec_test");                                       // # 24 test  write all functions decremental
// run_test("write_20_read_20_read_all_test");                                          // # 25 test  write first 20 registers, read that 20 and after, read all
// run_test("afvip_test_instruction_register_field_0");                                 // # 26 test  set Opcode, RS0, with 0  
 run_test("coverage_full_test");// Test 100%Coverage / DST / IMM / RS0 /RS1 / DELAY     // # 27 test  sequence wich made 100% coverage for PWDATA / PRDATA / PADDR / RS0 / RS1 / IMM /DSTs
// run_test("afvip_opcode_test"); // test with 550 iteration                            // # 28 test  test with 550 iteration ( for reached all opcodes ) 
// run_test("afvip_opcode_all_seq1_test");                                              // # 29 test  test with all opcodes ( inclusive the restricted one ) to see all the opcodes & errors
// run_test("afvip_test_with_wait_interrupt_and_30_iteration");                         // # 30 test  testing the wait interrupt to verify it
// run_test("read_all_write_all_read_all_to_catch_pslverr_test");                       //Not write on TP 
// run_test("afvip_opcode_verification_test_w_pwdata_incremental");                     //Not write on TP      


//_____________________________
//run_test("afvip_opcode_verification_test_w_pwdata_incremental_test_for_opcode_edits");  // to catch the fall of interrupt
//run_test("afvip_apb_sequence_mada_test");                                               // to test a sequence send by Madalina
//run_test("coverage_test");                                                              // to test a sequence send by Antonia

end
// ------------------------ Assign the signals --------------------------------
assign psel                     =   afvip_if.psel           ;
assign afvip_if.pready          =   pready                  ;
assign penable                  =   afvip_if.penable        ;
assign paddr                    =   afvip_if.paddr          ;
assign pwdata                   =   afvip_if.pwdata         ;
assign pwrite                   =   afvip_if.pwrite         ;
assign afvip_int_if.afvip_intr  =   afvip_intr              ; 
assign rst_n                    =   afvip_rst_if.intf_reset ;
assign afvip_if.prdata          =   prdata                  ;
assign afvip_if.pslverr         =   pslverr                 ;

 `include "afvip_assertion.svh"  // assertion path

endmodule : afvip_top_verification


