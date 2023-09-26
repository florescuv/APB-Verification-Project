// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_scoreboard
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: A verification component that contains checkers and verifies the functionality of a design. 
//              It usually receives transaction level objects captured from the interfaces of a DUT via Analysys Ports.
//              The scoreboard can compare between the expected and actual values to see if they match.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_scoreboard extends uvm_scoreboard;

//--------------------------- Analysis port declaration ----------------------------
    
`uvm_component_utils        (afvip_scoreboard)   
`uvm_analysis_imp_decl      (_apb_port) 
`uvm_analysis_imp_decl      (_interrupt_port) 
`uvm_analysis_imp_decl      (_reset_port) 

uvm_analysis_imp_apb_port       #(afvip_item, afvip_scoreboard) ap_imp;                 //  Declaration and creation of a TLM Analysis Port to recieve data obj from other TB components (apb port)
uvm_analysis_imp_reset_port     #(afvip_rst_item, afvip_scoreboard) ap_imp_reset;       //  Declaration and creation of a TLM Analysis Port to recieve data obj from other TB components (reset pott)
uvm_analysis_imp_interrupt_port #(afvip_inter_item, afvip_scoreboard) ap_imp_interrupt; //  Declaration and creation of a TLM Analysis Port to recieve data obj from other TB components (interrupt port)

function new( string name = "afvip_scoreboard", uvm_component parent);
    super.new(name , parent);
endfunction 

// ___________________________________ Build phase ______________________________________________
// ---------------------------- instantiate the analysis ports ------------------------------------

function void build_phase (uvm_phase phase);
ap_imp =            new      ("ap_imp", this);
ap_imp_reset =      new      ("ap_imp_reset", this);
ap_imp_interrupt =  new      ("ap_imp_interrupt", this);
endfunction : build_phase

// ---------------------------- variables declaration  ------------------------------------

bit [31:0]    Mem[32]           ;                   // Initialize the memory
bit [2:0]     OPCODE            ;                   // Initialize the opcode
bit [4:0]     RS0               ;                   // Initialize the RS0
bit [4:0]     RS1               ;                   // Initialize the RS1
bit [4:0]     DST               ;                   // Initialize the destination
bit [7:0]     IMM               ;                   // Initialize the IMM
bit           ev_ctrl_start     ;                   // Initialize the event control start
bit           sts_intr_err_cfg  ;                   // Initialize the status interrupt error config
bit           ev_intr_clr_err   ;                   // Initialize the event interrupt clear error
bit [31:0]    opcode_check      ;                   // Initialize the opcode checker
bit [31:0]    reg80config       ;                   // Initialize the register 80 configuration


    virtual function void write_apb_port(afvip_item data);
  //  sts_intr_err_cfg = 0 ;

// ---------------------------- We are starting the scoreboard ------------------------------------

        `uvm_info (get_type_name(), $sformatf ("START THE SCOREBOARD FOR THE ADDR = %h", data.addr), UVM_LOW);
     
// ---------------------------- Verify if the address multiple of 4 ------------------------------------ 

       if (data.addr % 4 != 0 ) begin
            `uvm_fatal (get_type_name (), "PROBLEM !! The Address is not multiple of 4") end else begin
            $display("%s", data.sprint()); end

// ---------------------------- Virtual Memory ------------------------------------
         
         if(data.addr < 'h80) begin
        if(data.direction == 1) begin
            `uvm_info (get_type_name(), $sformatf ("We have the PWDATA = %h", data.pwdata), UVM_LOW);
            Mem[(data.addr/4)] = data.pwdata;
           `uvm_info (get_type_name (), $sformatf ("RECEIVED PWDATA = %d, RECEIVED ADDR =%h, WAS RECEIVED in the Mem[%d] =%d",data.pwdata, data.addr, data.addr/4, Mem[(data.addr/4)]), UVM_LOW);
        end

        else begin
            if(Mem[(data.addr/4)] != data.prdata) begin
                `uvm_error (get_type_name(), $sformatf ("ERROR !! EXPECTED  Read data  = %d, RECEIVED Read data = %d",Mem[(data.addr/4)], data.prdata))
            end
            else  
                `uvm_info (get_type_name(), $sformatf ("RECEIVED PRDATA = %d, RECEIVED ADDR =%h",data.prdata, data.addr), UVM_LOW);
        end

    for (int i=0; i<=data.addr/4; i++) begin
        `uvm_info (get_type_name (), $sformatf ("At ADDR = %h, the Mem[%d] has %d", i*4, i, Mem[(i)]), UVM_LOW);
     end
    end

// ---------------------------- Virtual Configuration Register ------------------------------------

    if(data.addr == 'h80) begin
    `uvm_info (get_type_name (), $sformatf ("The Address 80 has reach, the configuration of register is %d",data.pwdata), UVM_LOW);
    reg80config = data.pwdata;
    OPCODE  =    reg80config[2:0]        ;    // Take the value of opcode from pwdata  
    RS0     =    reg80config[7:3]        ;    // Take the value of rs0 from pwdata 
    RS1     =    reg80config[12:8]       ;    // Take the value of rs1 from pwdata 
    DST     =    reg80config[20:16]      ;    // Take the value of dst from pwdata 
    IMM     =    reg80config[31:24]      ;    // Take the value of imm from pwdata 
    `uvm_info (get_type_name(), $sformatf ("For OPCODE :%d rs0= %d, rs1= %d, dst= %d, IMM= %d", OPCODE, RS0, RS1, DST, IMM), UVM_LOW);

        if(reg80config[15:13] != 'd0)begin
            `uvm_error(get_type_name (),$sformatf ("ERROR !!  The configuration register is wrong ! Data of 13, 14 or 15 bits need to be 0 ! "))
            `uvm_info(get_type_name(), $sformatf ("Expected Value = 0 on 13, 0 on 14, and 0 on 15 !!  Received Value = %d", reg80config[15:13]), UVM_LOW);
        end
        if(reg80config[23:21] != 'd0)begin
            `uvm_error(get_type_name (),$sformatf ("ERROR : The configuration register is wrong! Data of 21, 22 or 23 bits need to be 0 ! "))
            `uvm_info(get_type_name(), $sformatf ("Expected Value = 0 on 21, 0 on 22, and 0 on 23 , Received Value = %d", reg80config[23:21]), UVM_LOW);
        end
        if(OPCODE > 'd4) begin
            `uvm_error (get_type_name (),$sformatf ("ERROR : The configuration register is wrong ! "))
        end
    end

// ---------------------------- Event start on address 'h8c ------------------------------------

    if(data.addr == 'h8c)begin
        ev_ctrl_start = data.pwdata;
    end

// ---------------------------- Check if the addr is '80 ------------------------------------

   if (ev_ctrl_start) begin

// ---------------------------- OPCODE 0 ------------------------------------

if(OPCODE == 'd0) begin
    opcode_check = Mem[RS0]+IMM;
            `uvm_info (get_type_name(), $sformatf ("For OPCODE %d the operation is %d+%d=%d", OPCODE, Mem[RS0], IMM,opcode_check), UVM_LOW);
            Mem[DST] = Mem[RS0] + IMM;
            if(Mem[DST] != opcode_check) begin
            `uvm_error (get_type_name (),$sformatf ("ERROR : The arithmetic operation is wrong ! "))
            end
            `uvm_info (get_type_name(), $sformatf ("Expected %d , Real %d", Mem[DST], opcode_check), UVM_LOW);
                
        end
// ---------------------------- OPCODE 1 ------------------------------------

        if(OPCODE == 'd1) begin
     opcode_check = Mem[RS0]*IMM;
            `uvm_info (get_type_name(), $sformatf ("For OPCODE %d the operation is %d*%d =%d", OPCODE, Mem[RS0], IMM,opcode_check), UVM_LOW);
            Mem[DST] = Mem[RS0]*IMM;
            if(Mem[DST] !=  opcode_check) begin
            `uvm_error (get_type_name (),$sformatf ("ERROR : The arithmetic operation is wrong ! ")) 
            `uvm_info (get_type_name(), $sformatf ("Expected %d , Real %d", Mem[DST], opcode_check), UVM_LOW);
        end
    end
// ---------------------------- OPCODE 2 ------------------------------------

        if(OPCODE == 'd2) begin
     opcode_check = Mem[RS0] + Mem[RS1];        
            `uvm_info (get_type_name(), $sformatf ("For OPCODE %d the operation is %d + %d = %d", OPCODE, Mem[RS0], Mem[RS1], opcode_check), UVM_LOW);
            Mem[DST] = Mem[RS0] + Mem[RS1];
            if(Mem[DST] !=  opcode_check) begin
            `uvm_error (get_type_name (),$sformatf ("ERROR : The arithmetic operation is wrong ! "))  
            `uvm_info (get_type_name(), $sformatf ("Expected %d , Real %d", Mem[DST], opcode_check), UVM_LOW);  
        end
    end
// ---------------------------- OPCODE 3 ------------------------------------

        if(OPCODE == 'd3) begin
            opcode_check = Mem[RS0] * Mem[RS1];        
            `uvm_info (get_type_name(), $sformatf ("For OPCODE %d the operation is %d * %d = %d", OPCODE, Mem[RS0], Mem[RS1], opcode_check), UVM_LOW);
            Mem[DST] =  Mem[RS0] * Mem[RS1];
            if(Mem[DST] !=  opcode_check) begin
            `uvm_error (get_type_name (),$sformatf ("ERROR : The arithmetic operation is wrong ! "))  
            `uvm_info (get_type_name(), $sformatf ("Expected %d , Real %d", Mem[DST], opcode_check), UVM_LOW);    
        end
    end

// ---------------------------- OPCODE 4 ------------------------------------    

        if(OPCODE == 'd4) begin
        opcode_check =  Mem[RS0] * Mem[RS1] + IMM;
            `uvm_info (get_type_name(), $sformatf ("For OPCODE %d the operation is %d*%d+%d=%d", OPCODE, Mem[RS0], Mem[RS1], IMM, opcode_check), UVM_LOW);
            Mem[DST] = Mem[RS0] * Mem[RS1] + IMM;
            if(Mem[DST] !=  opcode_check) begin
            `uvm_error (get_type_name (),$sformatf ("ERROR : The arithmetic operation is wrong ! ")) 
            `uvm_info (get_type_name(), $sformatf ("Expected %d , Real %d", Mem[DST], opcode_check), UVM_LOW);      
        end
    end
         for (int i=0; i<=31; i++) begin
        `uvm_info (get_type_name (), $sformatf ("At ADDR = %h, the Mem[%d] has %d", i*4, i, Mem[(i)]), UVM_LOW);
     end
    ev_ctrl_start = 0;
    end

// ---------------------------- Register 84 config ------------------------------------    

if((data.addr == 'h84) && data.prdata == 1) begin
    `uvm_info (get_type_name (), $sformatf ("We finished the interrupt ! "), UVM_LOW);
end
if((data.addr == 'h84) && data.prdata == 0) begin
     `uvm_info (get_type_name (), $sformatf (" We have an interrupt error ! "), UVM_LOW);
end

// ---------------------------- Register 88 config ------------------------------------    

if((data.addr == 'h88) && data.prdata == 1) begin
    `uvm_info (get_type_name (), $sformatf ("We have an interrupt clear finish event ! "), UVM_LOW);
end
if((data.addr == 'h88) && data.prdata == 0) begin
     `uvm_info (get_type_name (), $sformatf (" We have an interrupt clear error event !  "), UVM_LOW);
end

// ---------------------------- Register 8C config ------------------------------------    

if((data.addr == 'h8c) && data.prdata == 0) begin
    `uvm_info (get_type_name (), $sformatf ("We started the instruction ! "), UVM_LOW);
end

endfunction

// ---------------------------- Check write reset ports   ------------------------------------    

virtual function void write_reset_port (afvip_rst_item rst_itm);
    $display ("%s", rst_itm.sprint () );
    if (!rst_itm.intf_reset ) begin
    for(int i=0; i<32; i++) begin
        Mem[i] = 0;
    end
end

    `uvm_info("RESET", $sformatf ("DISPLAY FOR THE RESET FROM ABOVE : %d", rst_itm.intf_reset), UVM_MEDIUM);
endfunction 

// ---------------------------- Check write interrupt ports   ------------------------------------   

virtual function void write_interrupt_port (afvip_inter_item inter_itm);
    $display ("%s", inter_itm.sprint () ); 
endfunction 

endclass : afvip_scoreboard

// //___________________________________________________________ END OF MY SCOREBOARD __________________________________________

