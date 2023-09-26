// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_driver
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: UVM driver is an active entity that has knowledge on how to drive signals to a particular interface of the design.
//              Is the place where the protocols are realized to be tested.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_driver extends uvm_driver #(afvip_item);
   
   `uvm_component_utils (afvip_driver)

    function new(string name= "afvip_driver", uvm_component parent = null );
        super.new (name, parent);
    endfunction 

// ------------------- create the handle -------------------------
virtual afvip_interface vif           ;     // Handle for apb virtual interface  
afvip_item              data_project  ;     // Handle for apb item

// ____________________________ Build Phase _____________________________

virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if( ! uvm_config_db #(virtual afvip_interface) :: get (this, "", "vif", vif)) begin
    `uvm_fatal (get_type_name (), "Didn't get handle to virtual interface afvip_interface")
    end
endfunction 

// ____________________________ Run Phase _____________________________

virtual task run_phase(uvm_phase phase); 
   zero_values();                           // Call the zero_values task ( put all the signals on 0 )
    
    @ (posedge vif.rst_n);                  // Wait a reset posedge 
    @(vif.cb_apb);                          // Wait an apb clocking block
 
      forever begin
        `uvm_info(get_type_name(), $sformatf ("waiting for data from afvip_sequencer."), UVM_MEDIUM)
        seq_item_port.get_next_item(data_project);

        $display("%s" , data_project.sprint());
        repeat(data_project.delay) @(vif.cb_apb) ;      // Repeat used for delay

        case (data_project.direction)                   // If we have read / write , we call the correct task
         1'b0:read(data_project);                       // Read task
         1'b1:write(data_project);                      // Write task
       endcase
       
       seq_item_port.item_done();
      end

endtask



virtual task zero_values();  // Task made to put all values on '0' 

vif.cb_apb.psel     <=0;     // PSEL    = 0 
vif.cb_apb.penable  <=0;     // PENABLE = 0 
vif.cb_apb.pwdata   <=0;     // PWDATA  = 0 
vif.cb_apb.pwrite   <=0;     // PWRITE  = 0
vif.cb_apb.paddr    <=0;     // PADDR   = 0
endtask

virtual task write(afvip_item data_project);                 // Write TASK
        vif.cb_apb.psel <=1;                                // Set the psel value '1'
        vif.cb_apb.pwdata    <= data_project.pwdata;        // Get the write data value recieved from DUT to my write data from clocking block
        vif.cb_apb.paddr     <= data_project.addr;          // Get the address value recieved from DUT to my address from clocking block
        vif.cb_apb.pwrite <= 1;                             // Set the pwrite value '1'
         @(vif.cb_apb);                                     // Wait an apb clocking block
        vif.cb_apb.penable   <= 1;                          // Set the Penable value '1'
        @(vif.cb_apb iff vif.cb_apb.pready);                // On the clock when Pready is high
        vif.cb_apb.penable   <= 0;                          // Set the Penable value '0'; (put 0 to be right / Put 1 to be crashed)
      vif.cb_apb.psel <=0;                                  // Set the PSEL value '0'
endtask

virtual task read(afvip_item data_project);                   // Read TASK
        vif.cb_apb.psel <=1;                                  // Set the PSEL value '1'
        vif.cb_apb.paddr     <= data_project.addr;            // Get the address value recieved from DUT to my address from clocking block
        vif.cb_apb.pwrite    <= 0 ;                           // Set the Pwrite value '0'
         @(vif.cb_apb);                                       // Wait an apb clocking block
        vif.cb_apb.penable   <= 1;                            // Set the Penable value '1'
        @(vif.cb_apb iff vif.cb_apb.pready);                  // On the clock when Pready is high
        vif.cb_apb.penable   <= 0;                            // Set the Penable value '0'
        vif.cb_apb.psel <=0;                                  // Set the PSEL value '0'
endtask

endclass 
