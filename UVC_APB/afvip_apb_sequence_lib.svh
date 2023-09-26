// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_apb_sequence_lib
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: Provides one more pre-defined UVM approach which can be utilized to ease the 
//              implementation of creating a test sequence by combining multiple sequences.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_base_sequence extends uvm_sequence; 
    `uvm_object_utils(afvip_base_sequence)

    afvip_item item;
    function new (string name="afvip_base_sequence");
        super.new(name);     
        item = afvip_item::type_id::create("item");
        // se poate face create aici 
    endfunction

endclass : afvip_base_sequence

class afvip_apb_sequence extends afvip_base_sequence;
  `uvm_object_utils(afvip_apb_sequence)

  function new (string name="afvip_apb_sequence");
      super.new(name);     
  endfunction

  virtual task body(); 
   afvip_item itm;
   itm = afvip_item::type_id::create("itm");

   for(int i=0; i < 33; i++) begin
    if(i < 32) begin
   start_item(itm);
   if(!((itm.randomize()) with {delay ==2;
                                pwdata == i ;
                                // pwrite inside {[0:1]};  //32908  32768
                                addr == i*4 ;
                                direction == 1 ;
                               // addr == 16'h88;
                               }))
   
   `uvm_error(get_type_name(), "Rand error")
   finish_item(itm);

   start_item (itm);
    itm.direction = 0 ; 
    finish_item(itm);  
   end
    if (i==32) begin
        start_item(itm);
    itm.pwdata[7:3] = 4 ;   // rs0
    itm.pwdata[12:8] = 12 ;  // rs1
    itm.pwdata[20:16] = 24 ; // dst
    itm.pwdata[31:24] = 10 ; // imm
    itm.direction = 1; 
    itm.pwdata [2:0] = 3 ; // opcode  
    itm.addr = 16'h80;  
  finish_item(itm);
    end
    
    end
    start_item (itm);
    itm.direction = 0 ; 
    itm.addr = 16'h24;
    finish_item(itm);
    endtask : body

endclass : afvip_apb_sequence

// ____________________________________________________________________________________________________________________________________\\

class afvip_write_all_function_for_overlapped extends afvip_base_sequence;
    `uvm_object_utils(afvip_write_all_function_for_overlapped)
  
    function new (string name="afvip_write_all_function_for_overlapped");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 32; i++) begin
             start_item (item);
             if(!(item.randomize() with {//delay == 2;
                                        delay inside {[0:2]}; 
                                    //    pwdata == i*2;
                                      pwdata == 'hFFFFFFFF; //  FOR OVERLAPPED
                                        addr == i*4;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_write_all_function_for_overlapped

class afvip_write_all_function_for_overlapped_with_adder extends afvip_base_sequence;
    `uvm_object_utils(afvip_write_all_function_for_overlapped_with_adder)
  
    function new (string name="afvip_write_all_function_for_overlapped_with_adder");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 32; i++) begin
             start_item (item);
             if(!(item.randomize() with {delay == 2;
                                       // delay inside {[0:2]}; 
                                    //    pwdata == i*2;
                                      pwdata == 'hFFFFFFFE; //  FOR OVERLAPPED with adder
                                        addr == i*4;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_write_all_function_for_overlapped_with_adder


class afvip_write_all_function extends afvip_base_sequence;
    `uvm_object_utils(afvip_write_all_function)
  
    function new (string name="afvip_write_all_function");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 32; i++) begin
             start_item (item);
             if(!(item.randomize() with {delay == 0;
                                        //delay inside {[0:2]}; 
                                        pwdata == i * 'd134217727; // FOR 100% read and write 
                                        //pwdata inside {['h0:'hFFFFFFFF]} ;
                                     // pwdata == 'hFFFFFFFF; FOR OVERLAPPED
                                        addr == i*4;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_write_all_function

// ____________________________________________________________________________________________________________________________________\\

class afvip_read_all_function extends afvip_base_sequence;
    `uvm_object_utils(afvip_read_all_function)
  
    function new (string name="afvip_read_all_function");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 32; i++) begin
             start_item (item);
             if(!(item.randomize() with {delay ==0;
                                        addr == i*4;
                                        direction == 0;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_read_all_function

// ____________________________________________________________________________________________________________________________________\\

class afvip_opcode_seq extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode_seq)
  
    function new (string name="afvip_opcode_seq");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     if(!((item.randomize()) with {
        pwdata[2:0]    inside  {[0:4]}     ; // opcode  
        pwdata[7:3]    inside  {[0:31]}    ;  // rs0
        pwdata[12:8]   inside  {[0:31]}    ;  // rs1
        pwdata[20:16]  inside  {[0:31]}    ; // dst
        pwdata[31:24]  inside  {[0:255]}   ; // imm
        pwdata[15:13] == 0; // bit_should_be0
        pwdata[23:21] == 0; // bit should be 0 
        
        delay == 0;
        
         }))
          item.addr = 16'h80; 
          item.direction = 1; 
         finish_item (item);
           
    endtask : body
endclass : afvip_opcode_seq

class opcode_sequence_0_to_4 extends afvip_base_sequence;
    `uvm_object_utils(opcode_sequence_0_to_4)
    function new (string name="opcode_sequence_0_to_4");
        super.new(name);    
    endfunction
      virtual task body();
        start_item (item);

     if(!(item.randomize() with {addr == 'h80 ;
                                 delay ==0;
                                 direction == 1;
                                pwdata[2:0] inside {[0:4]};         //OPCODE
                                pwdata[7:3] inside {[0:31]};        //RS0    
                                pwdata[12:8] inside {[0:31]};       //RS1  
                                pwdata[20:16] inside {[0:31]};      //DST      
                                pwdata[31:24] inside {[0:255]};     //IMM
                                pwdata[15:13]   ==  0; //Bits0
                                pwdata[23:21]   ==  0; //Bits0
                                 }))
      `uvm_error(get_type_name(), "rand_error")
     finish_item (item);
      endtask
endclass : opcode_sequence_0_to_4
//  ______________________________________________________Opcode seq 2 ___________________________________________________________

class afvip_opcode_seq_v2 extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode_seq_v2)
  
    function new (string name="afvip_opcode_seq_v2");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 10 ;   // rs0
        item.pwdata[12:8] = 19 ;  // rs1
        item.pwdata[20:16] = 10 ; // dst
        item.pwdata[31:24] = 7 ; // imm
        item.direction = 1; 
        item.pwdata [2:0] = 2 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode_seq_v2


// __________________________________________________Opcode for issue [7] ________________________________________________________________\\

class write_all_without_2c_sequence extends afvip_base_sequence;
    `uvm_object_utils(write_all_without_2c_sequence)
    function new (string name="write_all_without_2c_sequence");
        super.new(name);    
    endfunction
 
    virtual task body();
        for(int i = 0; i<32 ;i++) begin
            if(i!=11) begin
             start_item (item);
             if(!(item.randomize() with {pwdata == i;
                                         addr == i*4 ;
                                         delay == 2 ;
                                         direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);
            end

        end
    endtask : body
endclass : write_all_without_2c_sequence

// __________________________________________________Opcode for issue [8] ________________________________________________________________\\


class afvip_opcode_seq2 extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode_seq2)
  
    function new (string name="afvip_opcode_seq2");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 2 ;   // rs0
        item.pwdata[12:8] = 12 ;  // rs1
        item.pwdata[20:16] = 24 ; // dst
        item.pwdata[31:24] = 129 ; // imm
        item.direction = 1; 
        item.pwdata [2:0] = 0 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode_seq2

// __________________________________________________ Opcode sequences ________________________________________________________________\\

// ___________________  h84 ____________________________\\

class sts_intr extends afvip_base_sequence;
    `uvm_object_utils(sts_intr)
 // bit [1:0] prdata_saving_sts;  //added
    function new (string name="sts_intr");
        super.new(name);     
    endfunction
  
    virtual task body();
         
         start_item (item);
        item.addr = 16'h84;
        item.direction = 0;
         finish_item (item);
            
      //  prdata_saving_sts = item.prdata;  // to fall the interrupt

    endtask : body
endclass : sts_intr

// ___________________  h88 ____________________________\\

class ev_intr_clr extends afvip_base_sequence;
    `uvm_object_utils(ev_intr_clr)
   // rand bit pwdata_value_for_test; //added
    function new (string name="ev_intr_clr");
        super.new(name);     
    endfunction
  
    virtual task body();
         
         start_item (item);
        item.addr = 16'h88;
        item.direction = 1;
      //  item.pwdata = pwdata_value_for_test; //added
         item.pwdata = 2;
         finish_item (item);
            
    endtask : body
endclass : ev_intr_clr


// ___________________  h88 with item.pwdata = 3 ____________________________\\

class ev_err_clr extends afvip_base_sequence;
    `uvm_object_utils(ev_err_clr)
   // rand bit pwdata_value_for_test; //added
    function new (string name="ev_err_clr");
        super.new(name);     
    endfunction
  
    virtual task body();
         
         start_item (item);
        item.addr = 16'h88;
        item.direction = 1;
      //  item.pwdata = pwdata_value_for_test; //added
         item.pwdata = 3;
         finish_item (item);
            
    endtask : body
endclass : ev_err_clr

// ___________________  h8C ____________________________\\

class ev_ctrl extends afvip_base_sequence;
    `uvm_object_utils(ev_ctrl)
  
    function new (string name="ev_ctrl");
        super.new(name);     
    endfunction
  
    virtual task body();
         
          start_item (item);
        item.addr = 16'h8c;
        item.direction = 1;
        item.pwdata = 1;
         finish_item (item);
            
    endtask : body
endclass : ev_ctrl

// __________________________________________________ Opcode sequences ________________________________________________________________\\


// ________________________________ Error  if address is not divisible with 4 sequence ________________________________________________\\

class addr_not_DivTo4_sequence extends afvip_base_sequence;
    // check functionlity when address is not divisible by 4

    `uvm_object_utils(addr_not_DivTo4_sequence)

    function new (string name="addr_not_DivTo4_sequence");
        super.new(name);     
    endfunction
    virtual task body();
        for(int i = 0; i<40 ;i++) begin
             start_item (item);
             if(!(item.randomize() with {pwdata == i ;
                                         addr inside {[16'h0:16'h7c] }; 
                                         delay == 2 ;
                                         direction  inside {[0:1] } ;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);
        end
    endtask : body

endclass : addr_not_DivTo4_sequence 

// ____________________________________ Back to back transaction sequence _____________________________________________________\\

class back2back_sequence extends afvip_base_sequence;
    `uvm_object_utils(back2back_sequence)
  
    function new (string name="back2back_sequence");
        super.new(name);     
    endfunction
  
    virtual task body();
        for(int i = 0; i<40 ;i++) begin
             start_item (item);
             if(!(item.randomize() with {pwdata == i;
                                         addr inside {[16'h0:16'h7c] };
                                         delay == 0 ;
                                         direction  inside {[0:1] } ;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);
        end
    endtask : body
endclass : back2back_sequence

// ____________________________________ Read twice and write once sequence  ____________________________________________________\\

class readx2_write_sequence extends afvip_base_sequence;
    `uvm_object_utils(readx2_write_sequence)
  
    function new (string name="readx2_write_sequence");
        super.new(name);     
    endfunction
  
    virtual task body();
        for(int i = 0; i<36 ;i++) begin
            
            start_item (item);
            item.direction = 0;
            finish_item (item);

            start_item (item);
            item.direction = 0;
            finish_item (item);

             start_item (item);
             if(!(item.randomize() with {pwdata == i;
                                         addr inside {[16'h0:16'h7c] };
                                         delay == 2 ;
                                         direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

             start_item (item);
             item.direction = 0;
             finish_item (item);
 
             start_item (item);
             item.direction = 0;
             finish_item (item);
             end
     
    endtask : body
endclass : readx2_write_sequence

// __________________________________ Write an address until address 15 sequence _________________________________________________\\

class write_until_addr15 extends afvip_base_sequence;
    `uvm_object_utils(write_until_addr15)
  
    function new (string name="write_until_addr15");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 16; i++) begin
             start_item (item);
             if(!(item.randomize() with {delay == 2;
                                        // delay inside {[0:2]}; 
                                        pwdata == i*2;
                                        addr == i*4;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);
            
            end
    endtask : body
endclass : write_until_addr15

// ____________________________________ Read an address until address 15 sequence _____________________________________________________\\

class read_until_addr15 extends afvip_base_sequence;
    `uvm_object_utils(read_until_addr15)
  
    function new (string name="read_until_addr15");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 16; i++) begin
             start_item (item);
             if(!(item.randomize() with {delay == 2;
                                        // delay inside {[0:2]}; 
                                        pwdata == i*2;
                                        addr == i*4;
                                        direction == 0;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);
            
            end
    endtask : body
endclass : read_until_addr15

// ____________________________________ Opcode overlapped sequence (multiplication) _____________________________________________________\\

class afvip_opcode_seq_overlapped extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode_seq_overlapped)
  
    function new (string name="afvip_opcode_seq_overlapped");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] =      1 ;   // rs0
        item.pwdata[12:8] =     4 ;  // rs1
        item.pwdata[20:16] =    0 ; // dst
        item.pwdata[31:24] =    2 ; // imm
        item.direction =        1;  // read / write
        item.pwdata [2:0] =     1 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode_seq_overlapped

// ____________________________________ Opcode overlapped sequence (adder)  _____________________________________________________\\

class afvip_opcode_seq_overlapped_adder extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode_seq_overlapped_adder)
  
    function new (string name="afvip_opcode_seq_overlapped_adder");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] =      1 ;   // rs0
        item.pwdata[12:8] =     4 ;  // rs1
        item.pwdata[20:16] =    0 ; // dst
        item.pwdata[31:24] =    2 ; // imm
        item.direction =        1;  // read / write
        item.pwdata [2:0] =     0 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode_seq_overlapped_adder

// ________________________________ Opcode error putting another number on restricted bits sequence _____________________________________________________\\

class afvip_opcode_seq_err_put0_on_restricted_bits extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode_seq_err_put0_on_restricted_bits)
  
    function new (string name="afvip_opcode_seq_err_put0_on_restricted_bits");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 4 ;   // rs0
        item.pwdata[12:8] = 14 ;  // rs1
        item.pwdata[20:16] = 28 ; // dst
        item.pwdata[31:24] = 149 ; // imm
        item.pwdata[15:13] = 2; // bit_should_be0
        item.pwdata[23:21] = 1; // bit should be 0 
        item.direction = 1; 
        item.pwdata [2:0] = 2 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode_seq_err_put0_on_restricted_bits

// ____________________________________ Opcode same destination address sequence  _____________________________________________________\\

class afvip_opcode_same_dest_address extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode_same_dest_address)
  
    function new (string name="afvip_opcode_same_dest_address");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3]    = 4 ;   // rs0
        item.pwdata[12:8]   = 4 ;  // rs1
        item.pwdata[20:16]  = 28 ; // dst
        item.pwdata[31:24]  = 29 ; // imm
        item.pwdata[15:13]  = 0; // bit_should_be0
        item.pwdata[23:21]  = 0; // bit should be 0 
        item.direction      = 1; 
        item.pwdata [2:0]   = 2 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode_same_dest_address

// ____________________________________ Write FFF on every address sequence  _____________________________________________________\\

class afvip_write_FFF extends afvip_base_sequence;
    `uvm_object_utils(afvip_write_FFF)
  
    function new (string name="afvip_write_FFF");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 32; i++) begin
             start_item (item);
             if(!(item.randomize() with {delay == 2;
                                        // delay inside {[0:2]}; 
                                        pwdata == 'hFFFFFFFF;
                                     // pwdata == 'hFFFFFFFF; FOR OVERLAPPED
                                        addr == i*4;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_write_FFF

// ____________________________________ Write 0 on every address sequence  _____________________________________________________\\

class afvip_write_0 extends afvip_base_sequence;
    `uvm_object_utils(afvip_write_0)
  
    function new (string name="afvip_write_0");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 32; i++) begin
             start_item (item);
             if(!(item.randomize() with {delay == 2;
                                        // delay inside {[0:2]}; 
                                        pwdata == '0;
                                     // pwdata == 'hFFFFFFFF; FOR OVERLAPPED
                                        addr == i*4;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_write_0

// ____________________________________ Write all function decremental sequence  _____________________________________________________\\

class afvip_write_all_function_dec extends afvip_base_sequence;
    `uvm_object_utils(afvip_write_all_function_dec)
  
    function new (string name="afvip_write_all_function_dec");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=32; i >= 0; i--) begin
            for(int j=0; j < 32; j++) begin
             start_item (item);
             if(!(item.randomize() with {delay == 2;
                                        //delay inside {[0:2]}; 
                                        pwdata == j*2 ;
                                     // pwdata == 'hFFFFFFFF; FOR OVERLAPPED
                                        addr == i*4 ;                                      
                                      

                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);
            end
            end
    endtask : body
endclass : afvip_write_all_function_dec

// ____________________________________ Testing a sequence recieved from Madalina Dedu  _____________________________________________________\\

class afvip_apb_sequence_mada extends afvip_base_sequence;

  `uvm_object_utils(afvip_apb_sequence_mada)

  function new (string name="afvip_apb_sequence_mada");
      super.new(name);    
  endfunction

   virtual task body();
      for(int i = 0; i<40 ;i++) begin
           start_item (item);
           if(!(item.randomize() with {pwdata == i;
                                       addr inside {[16'h0:16'h7c] };
                                       addr % 4 == 0;
                                       direction  inside {[0:1] } ;}))
            `uvm_error(get_type_name(), "rand_error")
           finish_item (item);
      end
  endtask : body
endclass : afvip_apb_sequence_mada

// __________ Write all address & rise an error because we don't have correct address requirements (addr div with 4) __________________\\

class afvip_write_all_err_data_not_mul_4 extends afvip_base_sequence;
    `uvm_object_utils(afvip_write_all_err_data_not_mul_4)
  
    function new (string name="afvip_write_all_err_data_not_mul_4");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=32; i > 0; i--) begin
             start_item (item);
             if(!(item.randomize() with {delay == 2;
                                        // delay inside {[0:2]}; 
                                        pwdata == i*2;
                                     // pwdata == 'hFFFFFFFF; FOR OVERLAPPED
                                        addr == i;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_write_all_err_data_not_mul_4

// ____________________________________ Opcodes check for everyone  _____________________________________________________\\

class afvip_opcode0_all_seq1 extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode0_all_seq1)
  
    function new (string name="afvip_opcode0_all_seq1");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);

        item.pwdata[7:3] = 21 ;   // rs0
        item.pwdata[12:8] = 2 ;  // rs1
        item.pwdata[20:16] = 4 ; // dst
        item.pwdata[31:24] = 6 ; // imm
        item.direction = 1; 
        item.pwdata [2:0] = 0 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode0_all_seq1

class afvip_opcode1_all_seq1 extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode1_all_seq1)
  
    function new (string name="afvip_opcode1_all_seq1");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 2 ;   // rs0
        item.pwdata[12:8] = 4 ;  // rs1
        item.pwdata[20:16] = 6 ; // dst
        item.pwdata[31:24] = 8 ; // imm
        item.direction = 1; 
        item.pwdata [2:0] = 1 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode1_all_seq1

class afvip_opcode2_all_seq1 extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode2_all_seq1)
  
    function new (string name="afvip_opcode2_all_seq1");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 8 ;   // rs0
        item.pwdata[12:8] = 4 ;  // rs1
        item.pwdata[20:16] = 2 ; // dst
        item.pwdata[31:24] = 0 ; // imm
        item.direction = 1; 
        item.pwdata [2:0] = 2 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode2_all_seq1

class afvip_opcode3_all_seq1 extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode3_all_seq1)
  
    function new (string name="afvip_opcode3_all_seq1");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 4 ;   // rs0
        item.pwdata[12:8] = 2 ;  // rs1
        item.pwdata[20:16] = 8 ; // dst
        item.pwdata[31:24] = 10 ; // imm
        item.direction = 1; 
        item.pwdata [2:0] = 3 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode3_all_seq1

class afvip_opcode4_all_seq1 extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode4_all_seq1)
  
    function new (string name="afvip_opcode4_all_seq1");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 18 ;   // rs0
        item.pwdata[12:8] = 16 ;  // rs1
        item.pwdata[20:16] = 14 ; // dst
        item.pwdata[31:24] = 12 ; // imm
        item.direction = 1; 
        item.pwdata [2:0] = 4 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode4_all_seq1

class afvip_opcode5_all_seq1 extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode5_all_seq1)
  
    function new (string name="afvip_opcode5_all_seq1");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 25 ;   // rs0
        item.pwdata[12:8] = 24 ;  // rs1
        item.pwdata[20:16] = 54 ; // dst
        item.pwdata[31:24] = 44 ; // imm
        item.direction = 1; 
        item.pwdata [2:0] = 5 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode5_all_seq1

class afvip_opcode6_all_seq1 extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode6_all_seq1)
  
    function new (string name="afvip_opcode6_all_seq1");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 72 ;   // rs0
        item.pwdata[12:8] = 37 ;  // rs1
        item.pwdata[20:16] = 25 ; // dst
        item.pwdata[31:24] = 62 ; // imm
        item.direction = 1; 
        item.pwdata [2:0] = 6 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode6_all_seq1

class afvip_opcode7_all_seq1 extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode7_all_seq1)
  
    function new (string name="afvip_opcode7_all_seq1");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 72 ;   // rs0
        item.pwdata[12:8] = 37 ;  // rs1
        item.pwdata[20:16] = 25 ; // dst
        item.pwdata[31:24] = 62 ; // imm
        item.direction = 1; 
        item.pwdata [2:0] = 7 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode7_all_seq1

class afvip_opcode8_all_seq1 extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode8_all_seq1)
  
    function new (string name="afvip_opcode8_all_seq1");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 72 ;   // rs0
        item.pwdata[12:8] = 37 ;  // rs1
        item.pwdata[20:16] = 25 ; // dst
        item.pwdata[31:24] = 62 ; // imm
        item.direction = 1; 
        item.pwdata [2:0] = 8 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode8_all_seq1

// ____________________________________ Opcodes check for everyone  _____________________________________________________\\

// ____________________________________ Back to back write sequence  _____________________________________________________\\

class afvip_write_all_function_back2back extends afvip_base_sequence;
    `uvm_object_utils(afvip_write_all_function_back2back)
  
    function new (string name="afvip_write_all_function_back2back");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 32; i++) begin
             start_item (item);
             if(!(item.randomize() with {delay == 0;
                                        // delay inside {[0:2]}; 
                                        pwdata == i*16;
                                     // pwdata == 'hFFFFFFFF; FOR OVERLAPPED
                                        addr == i*4;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_write_all_function_back2back

// ____________________________________ Back to back read sequence  _____________________________________________________\\

class afvip_read_all_function_back2back extends afvip_base_sequence;
    `uvm_object_utils(afvip_read_all_function_back2back)
  
    function new (string name="afvip_read_all_function_back2back");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 32; i++) begin
             start_item (item);
             if(!(item.randomize() with {delay == 0;
                                        addr == i*4;
                                        direction == 0;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_read_all_function_back2back

// ____________________________________ Read a specific address (20)  _____________________________________________________\\

class afvip_read_20th_address_function extends afvip_base_sequence;
    `uvm_object_utils(afvip_read_20th_address_function)
  
    function new (string name="afvip_read_20th_address_function");
        super.new(name);     
    endfunction
  
    virtual task body();
             start_item (item);
             if(!(item.randomize() with {delay == 0;
                                        addr == 'h20;
                                        direction == 0;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

    endtask : body
endclass : afvip_read_20th_address_function

// ____________________________________ Write a specific address (20)  _____________________________________________________\\

class afvip_write_20th_function extends afvip_base_sequence;
    `uvm_object_utils(afvip_write_20th_function)
  
    function new (string name="afvip_write_20th_function");
        super.new(name);     
    endfunction
  
    virtual task body();
         begin
             start_item (item);
             if(!(item.randomize() with {delay == 0;
                                        // delay inside {[0:2]}; 
                                        pwdata == 'h12;
                                     // pwdata == 'hFFFFFFFF; FOR OVERLAPPED
                                        addr == 'h20;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_write_20th_function

// ____________________________________ Sequence filed with 0  _____________________________________________________\\

class sequence_field_with_0 extends afvip_base_sequence;
    `uvm_object_utils(sequence_field_with_0)
     function new (string name="sequence_field_with_0");
        super.new(name);    
    endfunction

      virtual task body();

      start_item(item);
      item.addr = 16'h80;
      item.direction =1;
      item.pwdata[2:0]     = 0;    //OPCODE
      item.pwdata[7:3]     = 0;    //RS0
      item.pwdata[12:8]    = 2;    //RS1
      item.pwdata[20:16]   = 4;    //DST
      item.pwdata[31:24]   = 6;    //IMM
      item.pwdata[15:13]   =  0;   //Bits0
      item.pwdata[23:21]   =  0;   //Bits0
      finish_item(item);
     endtask
endclass : sequence_field_with_0


class afvip_opc extends afvip_base_sequence;
    `uvm_object_utils(afvip_opc)
  
    function new (string name="afvip_opc");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 13 ;   // rs0
        item.pwdata[12:8] = 23 ;  // rs1
        item.pwdata[20:16] = 23 ; // dst
        item.pwdata[31:24] = 158 ; // imm
        item.direction = 1; 
        item.pwdata [2:0] = 3 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opc

// ____________________________________ Assign opcode = 6 (should be error)  _____________________________________________________\\


class afvip_opcode_for_opc_5 extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode_for_opc_5)
  
    function new (string name="afvip_opcode_for_opc_5");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 2 ;   // rs0
        item.pwdata[12:8] = 12 ;  // rs1
        item.pwdata[20:16] = 24 ; // dst
        item.pwdata[31:24] = 129 ; // imm
        item.direction = 1; 
        item.pwdata [2:0] = 6 ; // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode_for_opc_5


class write_d24 extends afvip_base_sequence;
    `uvm_object_utils(write_d24)
  
    function new (string name="write_d24");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 16; i++) begin
             start_item (item);
             if(!(item.randomize() with {delay == 2;
                                        // delay inside {[0:2]}; 
                                        pwdata == i*2;
                                        addr == 'd24;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);
            
            end
    endtask : body
endclass : write_d24


class afvip_write_all_with_delay_3 extends afvip_base_sequence;
    `uvm_object_utils(afvip_write_all_with_delay_3)
  
    function new (string name="afvip_write_all_with_delay_3");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 32; i++) begin
             start_item (item);
             if(!(item.randomize() with {delay == 3;
                                        //delay inside {[0:2]}; 
                                        pwdata == i * 'd134217727; // FOR 100% read and write 
                                        //pwdata inside {['h0:'hFFFFFFFF]} ;
                                     // pwdata == 'hFFFFFFFF; FOR OVERLAPPED
                                        addr == i*4;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_write_all_with_delay_3

class afvip_write_all_with_delay_between_0_and_3 extends afvip_base_sequence;
    `uvm_object_utils(afvip_write_all_with_delay_between_0_and_3)
  
    function new (string name="afvip_write_all_with_delay_between_0_and_3");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 32; i++) begin
             start_item (item);
             if(!(item.randomize() with {//delay == 3;
                                        delay inside {[0:15]}; 
                                        pwdata == i * 'd134217727; // FOR 100% read and write 
                                        //pwdata inside {['h0:'hFFFFFFFF]} ;
                                     // pwdata == 'hFFFFFFFF; FOR OVERLAPPED
                                        addr == i*4;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_write_all_with_delay_between_0_and_3

class afvip_write_all_wrong_function extends afvip_base_sequence;
    `uvm_object_utils(afvip_write_all_wrong_function)
  
    function new (string name="afvip_write_all_wrong_function");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 32; i++) begin
             start_item (item);
             if(!(item.randomize() with {delay == 0;
                                        //delay inside {[0:2]}; 
                                        pwdata == i * 'd134217727; // FOR 100% read and write 
                                        //pwdata inside {['h0:'hFFFFFFFF]} ;
                                     // pwdata == 'hFFFFFFFF; FOR OVERLAPPED
                                        addr == 'hb4;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_write_all_wrong_function

class afvip_opcode_verificatoni extends afvip_base_sequence;
    `uvm_object_utils(afvip_opcode_verificatoni)
  
    function new (string name="afvip_opcode_verificatoni");
        super.new(name);     
    endfunction
  
    virtual task body();
         start_item (item);
     
        item.pwdata[7:3] = 2 ;      // rs0
        item.pwdata[12:8] = 4 ;     // rs1
        item.pwdata[20:16] = 8 ;    // dst
        item.pwdata[31:24] = 12 ;   // imm
        item.direction = 1;         // pwrite
        item.pwdata [2:0] = 2 ;     // opcode  
        item.addr = 16'h80;      

         finish_item (item);
           
    endtask : body
endclass : afvip_opcode_verificatoni


class afvip_write_all_function_pwdata_incremental extends afvip_base_sequence;
    `uvm_object_utils(afvip_write_all_function_pwdata_incremental)
  
    function new (string name="afvip_write_all_function_pwdata_incremental");
        super.new(name);     
    endfunction
  
    virtual task body();
         for(int i=0; i < 32; i++) begin
             start_item (item);
             if(!(item.randomize() with {delay == 0;
                                        //delay inside {[0:2]}; 
                                        pwdata == i; // FOR 100% read and write 
                                        //pwdata inside {['h0:'hFFFFFFFF]} ;
                                     // pwdata == 'hFFFFFFFF; FOR OVERLAPPED
                                        addr == i*4;
                                        direction == 1;}))
              `uvm_error(get_type_name(), "rand_error")
             finish_item (item);

            end
    endtask : body
endclass : afvip_write_all_function_pwdata_incremental


class good_random_opcode extends afvip_base_sequence;
          `uvm_object_utils(good_random_opcode)
  
    function new (string name = "good_random_opcode");
        super.new(name);     
    endfunction
    
    virtual task body();
    start_item(item);    
             if(!(item.randomize() with {pwdata [2:0]   inside {[0:4]};     //opcode random
                                         pwdata [7:3]   inside {[0:31]};    //RS0
                                         pwdata [12:8]  inside {[0:31]};    //RS1
                                         pwdata [20:16] inside {[0:31]};    //DST
                                         pwdata [31:24] inside {[0:255]};   //imm
                                        pwdata[15:13] == 0; // bit_should_be0
                                        pwdata[23:21] == 0; // bit should be 0 
                                         addr == 'h80;
                                         delay inside {[0:5]};
                                         direction == 1; }))
            `uvm_error(get_type_name(), "rand_error")
    finish_item(item);

    endtask : body

endclass : good_random_opcode


class write_all_random extends afvip_base_sequence;
    `uvm_object_utils(write_all_random)
  
    function new (string name = "write_all_random");
        super.new(name);     
    endfunction
  
    virtual task body();
       //scriu toti registri
       for(int i = 0; i<32;i++) begin
        start_item (item);
          
             if(!(item.randomize() with {// pwdata inside {['h0:'hffffffff]} ;
                                         pwdata == i * 134217727 ;
                                         addr inside {['h0:'h7c]};
                                         addr % 4 == 0;
                                         delay == 0 ;
                                         direction  == 1; }))
            `uvm_error(get_type_name(), "rand_error")
        finish_item (item);
       end

    endtask : body
endclass : write_all_random

class wrong_addr extends afvip_base_sequence;
    `uvm_object_utils(wrong_addr)
  
    function new (string name = "wrong_addr");
        super.new(name);     
    endfunction
  
    virtual task body();

        start_item (item);
          
             if(!(item.randomize() with {pwdata == 1;
                                         addr == 'h90 ;
                                         delay == 2 ;
                                         direction  == 1; }))
            `uvm_error(get_type_name(), "rand_error")
        finish_item (item);


    endtask : body
endclass : wrong_addr