// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_monitor
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: Is responsible for capturing signal activity from the design interface and translate it into transaction level data objects that can be sent to other components.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_monitor extends uvm_monitor;
    
    `uvm_component_utils (afvip_monitor)

// ------------------- constructor -------------------------    
    function new(string name = "afvip_monitor", uvm_component parent = null);
        super.new (name, parent);
    endfunction 

// ------------------- create the handle -------------------------
virtual afvip_interface vif;                        // Handle for apb virtual interface 
uvm_analysis_port #(afvip_item) mon_analysis_port;

bit [14:0] delay_counter;                            // Delay counter to count the delay

// _________________________ Build phase ___________________________________
virtual function void build_phase (uvm_phase phase);
super.build_phase (phase);
mon_analysis_port = new ("mon_analysis_port", this);

if (! uvm_config_db #(virtual afvip_interface) :: get (this, "", "vif", vif )) begin
    `uvm_error (get_type_name (), "DUT interface not found")
end
endfunction : build_phase


// _________________________ Run phase ___________________________________

virtual task run_phase (uvm_phase phase);

afvip_item data_mon = afvip_item::type_id::create ("data_mon", this);  // Create the apb item for monitor

fork            // we use fork to run this task before the following forever begins
  delay_task(); // call the delay task
join_none

forever begin

// --------------------------------------------- Take the specified data from interface ------------------------------------- 
 @ (vif.cb_monitor iff vif.cb_monitor.psel && vif.cb_monitor.penable && vif.cb_monitor.pready  );   // Do the following instruction as long as we have PSEL, PREADY and PENABLE
     data_mon.direction = vif.cb_monitor.pwrite;
     data_mon.delay = delay_counter;                    // Reset the delay value to 0 at each finished transaction
     delay_counter = 0 ;    
     if ( vif.cb_monitor.pwrite == 1) begin             // As long as pwrite is '1'
        data_mon.addr = vif.cb_monitor.paddr;           // Send to monitor the address from interface
        data_mon.pwdata = vif.cb_monitor.pwdata;        // Send to monitor the write data from interface
        data_mon.pslverr = vif.cb_monitor.pslverr;      // Send to monitor the slave error from interface

     end else if ( vif.cb_monitor.pwrite == 0) begin    // As long as pwrite is '0' 
        data_mon.addr = vif.cb_monitor.paddr ;          // Send to monitor the address from interface           
        data_mon.prdata = vif.cb_monitor.prdata  ;      // Send to monitor the read data from interface    
        data_mon.pslverr = vif.cb_monitor.pslverr;      // Send to monitor the slave error from interface
     end
   
     $display("%s", data_mon.sprint());
    mon_analysis_port.write (data_mon);
    `uvm_info("Monitor", $sformatf ("I saw the item %s", data_mon.sprint() ), UVM_NONE )

end 

endtask :run_phase

// -------------------------- Delay task ( to count the delays ) --------------
task delay_task();
    forever begin
    @ (vif.cb_monitor) if (vif.cb_monitor.psel == 0)
    delay_counter = delay_counter + 1;
    end
endtask :delay_task


endclass