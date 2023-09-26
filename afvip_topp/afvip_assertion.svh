// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_assertion
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: The behavior of a system can be written as an assertion that should be true at all times. 
//               Hence assertions are used to validate the behavior of a system defined as properties.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------


// ________________________________________________ ASSERTION FOR APB ______________________________

sequence idle_phase ;
   !psel ;
endsequence
sequence setup_phase ;
   psel && !penable ;
endsequence
sequence access_phase_wait ;
   psel && penable && !pready ;
endsequence
sequence access_phase_last ;
   psel && penable && pready ;
endsequence
sequence error_ctrl_opcode ;
   paddr % 4 != 0 || paddr > 'h8c ;
endsequence
sequence afvip_intr_ver ;
   paddr == 'h8c && pwdata == 1 ;
endsequence

//----- Properties for genenric stable 
//------Parametric property to check signal is not X/Z
    property pr_generic_stable_pwrite;
   @(posedge clk) disable iff(!rst_n)
      !$stable(pwrite) |-> pwdata or (setup_phase or idle_phase)  ;  
    endproperty

    property pr_generic_stable_paddr ;
   @(posedge clk) disable iff(!rst_n)
      !$stable(paddr) |-> setup_phase or idle_phase ;  
    endproperty

    property pr_generic_stable_psvlerr ;
   @(posedge clk) disable iff(!rst_n)
      !$stable(pslverr) |-> pslverr or (setup_phase or idle_phase) ;  
    endproperty

//_____________________ Generic not unknow assertion ______________________________
 
    property pr_generic_not_unknown_psel ;
        @(posedge clk) disable iff(rst_n) 
            !$isunknown(psel) ;
    endproperty

    property pr_generic_not_unknown_penable ;
        @(posedge clk) disable iff(rst_n) 
            !$isunknown(penable) ;
    endproperty

    property pr_generic_not_unknown_pwrite ;
        @(posedge clk) disable iff(rst_n) 
            !$isunknown(pwrite) ;
    endproperty

    property pr_generic_not_unknown_paddr ;
        @(posedge clk) disable iff(rst_n) 
            !$isunknown(paddr) ;
    endproperty

    property pr_generic_not_unknown_pready ;
        @(posedge clk) disable iff(rst_n) 
            !$isunknown(pready) ;
    endproperty

    property pr_generic_not_unknown_pwdata ;
        @(posedge clk) disable iff(rst_n) 
            !$isunknown(pwdata) ;
    endproperty

    property pr_generic_not_unknown_prdata ;
        @(posedge clk) disable iff(rst_n) 
            !$isunknown(prdata) ;
    endproperty
//________________________________________________
    
    // in transfer
// same as pr_generic_stable but for PWDATA. it should be stable only in WRITE transfers, i.e. PWRITE=1
    property pwdata_in_wr_transfer_prop ;
      @(posedge clk) disable iff(!rst_n)
         !$stable(pwdata) |-> (!pwrite) or (setup_phase or idle_phase) ;
    endproperty

// for PENABLE and PSEL i can't use phases, since the phases are defined using these lines
    property penable_in_transfer_prop ;
       @(posedge clk) disable iff(!rst_n)
          $fell(penable) |-> ($past(psel) && $past(pready)) ;

    endproperty
// check if PSEL stable during transfer. i.e. PSEL can fall only after tranfer completed (PREADY=1)
    property psel_stable_in_transfer_prop ;
   @(posedge clk) disable iff(!rst_n)
      !psel && $past(psel) |-> $past(penable) && $past(pready) ; //The antecedent is NOT equal to ($fell) since 'X'->'0' also activates $fell
    endproperty

    // paddr
        property paddr_stable_in_transfer_prop ;
   @(posedge clk) disable iff(!rst_n)
       $rose(psel) |-> $past(psel && !penable); //The antecedent is NOT equal to ($fell) since 'X'->'0' also activates $fell
    endproperty

    // pwrite
        property pwrite_stable_in_transfer_prop ;
   @(posedge clk) disable iff(!rst_n)
      !psel && $past(psel) |-> $past(penable) && $past(pready) ; //The antecedent is NOT equal to ($fell) since 'X'->'0' also activates $fell
        endproperty

    // pslverr
       property pslverr_stable_in_transfer_prop ;
   @(posedge clk) disable iff(!rst_n)
    $past(psel) |-> $past(penable) and $past(pready) ; //The antecedent is NOT equal to ($fell) since 'X'->'0' also activates $fell
        endproperty

// ________________________________________________ SPECIFIC ASSERTION FOR OUR RTL ___________________________

// check if pslverr is corectly updated
property pslverr_error_ctrl ;
   @(posedge clk) disable iff(!rst_n)
    error_ctrl_opcode |-> pslverr ;
endproperty

// check if afvip_intr is high between 1-10 tacs
property afvip_intr_ctrl ;
   @(posedge clk) disable iff(!rst_n)
    afvip_intr_ver |-> ##[1:10](afvip_intr) ; //The antecedent is NOT equal to ($fell) since 'X'->'0' also activates $fell
endproperty

// check if the system is active when reset is on low
property reset_active_low ;
   @(posedge clk)
   !rst_n |=> ##[0:$] $rose(rst_n);
endproperty

    // check all signal for being valid. The protocol doesn't actualy require this. only PSEL must be always valid.
    PSEL_never_X    : assert property (pr_generic_not_unknown_psel) else $display("[%0t] Error! PSEL is unknown (=X/Z)", $time) ;
    PWRITE_never_X  : assert property (pr_generic_not_unknown_pwrite) else $display("[%0t] Error! PWRITE is unknown (=X/Z)", $time) ;
    PENABLE_never_X : assert property (pr_generic_not_unknown_penable) else $display("[%0t] Error! PENABLE is unknown (=X/Z)", $time) ;
    PREADY_never_X  : assert property (pr_generic_not_unknown_pready) else $display("[%0t] Error! PREADY is unknown (=X/Z)", $time) ;
    PADDR_never_X   : assert property (pr_generic_not_unknown_paddr) else $display("[%0t] Error! PADDR is unknown (=X/Z)", $time) ;
    PWDATA_never_X  : assert property (pr_generic_not_unknown_pwdata) else $display("[%0t] Error! PWDATA is unknown (=X/Z)", $time) ;
    PRDATA_never_X  : assert property (pr_generic_not_unknown_prdata) else $display("[%0t] Error! PRDATA is unknown (=X/Z)", $time) ;


    // check signals stability during a transfer (section 4.1 in APB5 documentation)
    paddr_stable_in_transfer     : assert property (pr_generic_stable_paddr)        else $display("[%0t] Error! PADDR must not change throughout the transfer", $time) ;
    pwrite_stable_in_transfer    : assert property (pr_generic_stable_pwrite)       else $display("[%0t] Error! PWRITE must not change throughout the transfer", $time) ;
    penable_stable_in_transfer   : assert property (penable_in_transfer_prop)       else $display("[%0t] Error! PENABLE must not change throughout the access phase", $time) ;
    psel_stable_in_transfer      : assert property (psel_stable_in_transfer_prop)   else $display("[%0t] Error! PSEL must not change throughout the transfer", $time) ;
    pwdata_stable_in_wr_transfer : assert property (pwdata_in_wr_transfer_prop)     else $display("[%0t] Error! PWDATA must not change throughout the write transfer", $time) ;
    pslverr_stable_in_transfer   : assert property (pr_generic_stable_psvlerr)      else $display("[%0t] Error! PSLVERR must not change throughout the transfer", $time) ;
    asertion_pslverr_ctrl        : assert property (pslverr_error_ctrl )            else $display("[%0t] Error! ADDR must be multiple of 4 ", $time) ;
    assertion_afvip_intr_ctrl    : assert property (afvip_intr_ctrl )               else $display("[%0t] Error! Interrupt is not high between 1-10 tacs", $time) ; 
    assertion_reset_active_low   : assert property (reset_active_low )              else $display("[%0t] Error! The system is NOT active when reset is on low", $time) ; 
// ________________________________________________ SPECIFIC ASSERTION FOR OUR RTL ___________________________


