// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_test_lib
// HDL        : UVM
// Author     : Florescu Vlad-Andrei
// Description: It is a pattern to check and verify specific features and functionalities of a design. 
//              A verification plan lists all the features and other functional items that needs to be verified, and the tests neeeded to cover each of them.
// Date       : 28 June, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_base_test extends uvm_test;

    `uvm_component_utils(afvip_base_test)
    function new( string name = "afvip_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
 
    afvip_environment m_env;
    uvm_tlm_analysis_fifo#(afvip_inter_item) interrupt_fifo;  // added for interrupt
    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        m_env = afvip_environment::type_id::create("m_env", this);
        interrupt_fifo = new("interrupt_fifo", this);  // added for interrupt
    endfunction

 virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        m_env.agent_passive.mon_passive.mon_analysis_port.connect(interrupt_fifo.analysis_export);  // added for interrupt
    endfunction : connect_phase
 

     virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    task wait_interrupt();  // added for interrupt
    afvip_inter_item item;
       interrupt_fifo.get(item);
        // $display("Item de inter este = ", item.interr);
        // wait(!item.interr);

    endtask : wait_interrupt // added for interrupt
endclass : afvip_base_test

class read_all_write_all_read_all_test extends afvip_base_test;
    `uvm_component_utils(read_all_write_all_read_all_test)
      function new( string name = "read_all_write_all_read_all_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
         afvip_read_all_function.start(m_env.agent0.m_seqr0);
         afvip_write_all_function.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : read_all_write_all_read_all_test

class afvip_opcode_test extends afvip_base_test;
    `uvm_component_utils(afvip_opcode_test)
      function new( string name = "afvip_opcode_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        opcode_sequence_0_to_4 opcode_sequence_0_to_4 = opcode_sequence_0_to_4::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        sts_intr sts_intr = sts_intr::type_id::create("item");
        ev_intr_clr ev_intr_clr = ev_intr_clr::type_id::create("item");
        ev_ctrl ev_ctrl = ev_ctrl::type_id::create("item");

        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_write_all_function.start(m_env.agent0.m_seqr0);
        for (int i=0; i<550; i++) begin
        opcode_sequence_0_to_4.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);
      end
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_opcode_test

class afvip_opcodeX2_op extends afvip_base_test;
    `uvm_component_utils(afvip_opcodeX2_op)
      function new( string name = "afvip_opcodeX2_op", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        afvip_opcode_seq afvip_opcode_seq = afvip_opcode_seq::type_id::create("item");
        afvip_opcode_seq_v2 afvip_opcode_seq_v2 = afvip_opcode_seq_v2::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        back2back_sequence back2back_sequence = back2back_sequence::type_id::create("item");
        sts_intr sts_intr = sts_intr::type_id::create("item");
        ev_intr_clr ev_intr_clr = ev_intr_clr::type_id::create("item");
        ev_ctrl ev_ctrl = ev_ctrl::type_id::create("item");

        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
        afvip_write_all_function.start(m_env.agent0.m_seqr0);
        afvip_opcode_seq_v2.start(m_env.agent0.m_seqr0);
        // afvip_opcode_seq.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);
       
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_opcodeX2_op

class read_all_no_write_test extends afvip_base_test;
    `uvm_component_utils(read_all_no_write_test)
      function new( string name = "read_all_no_write_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : read_all_no_write_test

class read_none_write_all_test extends afvip_base_test;
    `uvm_component_utils(read_none_write_all_test)
      function new( string name = "read_none_write_all_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_write_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : read_none_write_all_test

class read_all_write_all_test extends afvip_base_test;
    `uvm_component_utils(read_all_write_all_test)
      function new( string name = "read_all_write_all_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);
        afvip_write_all_function.start(m_env.agent0.m_seqr0);
      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : read_all_write_all_test

class no_read_no_write_test extends afvip_base_test;
    `uvm_component_utils(no_read_no_write_test)
      function new( string name = "no_read_no_write_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : no_read_no_write_test

class write_reset_read_test extends afvip_base_test;
    `uvm_component_utils(write_reset_read_test)
      function new( string name = "write_reset_read_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);


        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
     
        afvip_write_all_function.start(m_env.agent0.m_seqr0);
        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : write_reset_read_test

class write_until_addr15_read_that_addr_reset_write_and_read_all_test extends afvip_base_test;  //should have Pwirte / Prdata ok as coverage
    `uvm_component_utils(write_until_addr15_read_that_addr_reset_write_and_read_all_test)
      function new( string name = "write_until_addr15_read_that_addr_reset_write_and_read_all_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        read_until_addr15 read_until_addr15 = read_until_addr15::type_id::create("item");
        write_until_addr15 write_until_addr15 = write_until_addr15::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);


        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
        
        write_until_addr15.start(m_env.agent0.m_seqr0);
        read_until_addr15.start(m_env.agent0.m_seqr0);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);

        afvip_write_all_function.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : write_until_addr15_read_that_addr_reset_write_and_read_all_test

class afvip_opcode_seq_overlapped_test extends afvip_base_test;  // FFFF FFFF * 2 = FFFF FFFFE 
    `uvm_component_utils(afvip_opcode_seq_overlapped_test) 
      function new( string name = "afvip_opcode_seq_overlapped_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        afvip_write_all_function_for_overlapped afvip_write_all_function_for_overlapped = afvip_write_all_function_for_overlapped::type_id::create("item");
        afvip_opcode_seq afvip_opcode_seq = afvip_opcode_seq::type_id::create("item");
        afvip_opcode_seq_v2 afvip_opcode_seq_v2 = afvip_opcode_seq_v2::type_id::create("item");
        afvip_opcode_seq_overlapped afvip_opcode_seq_overlapped = afvip_opcode_seq_overlapped::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        back2back_sequence back2back_sequence = back2back_sequence::type_id::create("item");
        sts_intr sts_intr = sts_intr::type_id::create("item");
        ev_intr_clr ev_intr_clr = ev_intr_clr::type_id::create("item");
        ev_ctrl ev_ctrl = ev_ctrl::type_id::create("item");

        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_write_all_function_for_overlapped.start(m_env.agent0.m_seqr0);
        afvip_opcode_seq_overlapped.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_opcode_seq_overlapped_test

class afvip_opcode_seq_overlapped_test_with_adder extends afvip_base_test;   // FFFF FFFE + 2 = 0
    `uvm_component_utils(afvip_opcode_seq_overlapped_test_with_adder)
      function new( string name = "afvip_opcode_seq_overlapped_test_with_adder", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        afvip_write_all_function_for_overlapped_with_adder afvip_write_all_function_for_overlapped_with_adder = afvip_write_all_function_for_overlapped_with_adder::type_id::create("item");
        afvip_opcode_seq afvip_opcode_seq = afvip_opcode_seq::type_id::create("item");
        afvip_opcode_seq_v2 afvip_opcode_seq_v2 = afvip_opcode_seq_v2::type_id::create("item");
        afvip_opcode_seq_overlapped_adder afvip_opcode_seq_overlapped_adder = afvip_opcode_seq_overlapped_adder::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        back2back_sequence back2back_sequence = back2back_sequence::type_id::create("item");
        sts_intr sts_intr = sts_intr::type_id::create("item");
        ev_intr_clr ev_intr_clr = ev_intr_clr::type_id::create("item");
        ev_ctrl ev_ctrl = ev_ctrl::type_id::create("item");

        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_write_all_function_for_overlapped_with_adder.start(m_env.agent0.m_seqr0);
        afvip_opcode_seq_overlapped_adder.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_opcode_seq_overlapped_test_with_adder

class afvip_opcode_seq_err_put0_on_restricted_bits_test extends afvip_base_test;   // FFFF FFFE + 2 = 0
    `uvm_component_utils(afvip_opcode_seq_err_put0_on_restricted_bits_test)
      function new( string name = "afvip_opcode_seq_err_put0_on_restricted_bits_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        afvip_write_all_function_for_overlapped_with_adder afvip_write_all_function_for_overlapped_with_adder = afvip_write_all_function_for_overlapped_with_adder::type_id::create("item");
        afvip_opcode_seq afvip_opcode_seq = afvip_opcode_seq::type_id::create("item");
        afvip_opcode_seq_err_put0_on_restricted_bits afvip_opcode_seq_err_put0_on_restricted_bits = afvip_opcode_seq_err_put0_on_restricted_bits::type_id::create("item");
        afvip_opcode_seq_overlapped_adder afvip_opcode_seq_overlapped_adder = afvip_opcode_seq_overlapped_adder::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        back2back_sequence back2back_sequence = back2back_sequence::type_id::create("item");
        sts_intr sts_intr = sts_intr::type_id::create("item");
        ev_intr_clr ev_intr_clr = ev_intr_clr::type_id::create("item");
        ev_ctrl ev_ctrl = ev_ctrl::type_id::create("item");

        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_write_all_function_for_overlapped_with_adder.start(m_env.agent0.m_seqr0);
        afvip_opcode_seq_err_put0_on_restricted_bits.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_opcode_seq_err_put0_on_restricted_bits_test

class afvip_opcode_same_dest_address_test extends afvip_base_test;   
    `uvm_component_utils(afvip_opcode_same_dest_address_test)
      function new( string name = "afvip_opcode_same_dest_address_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        afvip_write_all_function_for_overlapped_with_adder afvip_write_all_function_for_overlapped_with_adder = afvip_write_all_function_for_overlapped_with_adder::type_id::create("item");
        afvip_opcode_seq afvip_opcode_seq = afvip_opcode_seq::type_id::create("item");
        afvip_opcode_same_dest_address afvip_opcode_same_dest_address = afvip_opcode_same_dest_address::type_id::create("item");
        afvip_opcode_seq_overlapped_adder afvip_opcode_seq_overlapped_adder = afvip_opcode_seq_overlapped_adder::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        back2back_sequence back2back_sequence = back2back_sequence::type_id::create("item");
        sts_intr sts_intr = sts_intr::type_id::create("item");
        ev_intr_clr ev_intr_clr = ev_intr_clr::type_id::create("item");
        ev_ctrl ev_ctrl = ev_ctrl::type_id::create("item");

        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_write_all_function.start(m_env.agent0.m_seqr0);
        afvip_opcode_same_dest_address.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_opcode_same_dest_address_test

class afvip_write_FFF_test extends afvip_base_test;
    `uvm_component_utils(afvip_write_FFF_test)
      function new( string name = "afvip_write_FFF_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_FFF afvip_write_FFF = afvip_write_FFF::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);

        afvip_write_FFF.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);
      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_write_FFF_test

class afvip_write_0_test extends afvip_base_test;
    `uvm_component_utils(afvip_write_0_test)
      function new( string name = "afvip_write_0_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_0 afvip_write_0 = afvip_write_0::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);

        afvip_write_0.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);
      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_write_0_test

class afvip_write_all_function_dec_test extends afvip_base_test;  // for all 32 address, at each addr we have 32 pwdata. (for in for)
    `uvm_component_utils(afvip_write_all_function_dec_test)
      function new( string name = "afvip_write_all_function_dec_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function_dec afvip_write_all_function_dec = afvip_write_all_function_dec::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);

        afvip_write_all_function_dec.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);
      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_write_all_function_dec_test

class afvip_apb_sequence_mada_test extends afvip_base_test;
    `uvm_component_utils(afvip_apb_sequence_mada_test)
      function new( string name = "afvip_apb_sequence_mada_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_apb_sequence_mada afvip_apb_sequence_mada = afvip_apb_sequence_mada::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);

        afvip_apb_sequence_mada.start(m_env.agent0.m_seqr0);
      //  afvip_read_all_function.start(m_env.agent0.m_seqr0);
      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_apb_sequence_mada_test

class afvip_write_all_err_data_not_mul_4_test extends afvip_base_test;
    `uvm_component_utils(afvip_write_all_err_data_not_mul_4_test)
      function new( string name = "afvip_write_all_err_data_not_mul_4_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_err_data_not_mul_4 afvip_write_all_err_data_not_mul_4 = afvip_write_all_err_data_not_mul_4::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);

        afvip_write_all_err_data_not_mul_4.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);
      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_write_all_err_data_not_mul_4_test

class afvip_opcode_all_seq1_test extends afvip_base_test;
    `uvm_component_utils(afvip_opcode_all_seq1_test)
      function new( string name = "afvip_opcode_all_seq1_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        afvip_opcode0_all_seq1 afvip_opcode0_all_seq1 = afvip_opcode0_all_seq1::type_id::create("item");
        afvip_opcode1_all_seq1 afvip_opcode1_all_seq1 = afvip_opcode1_all_seq1::type_id::create("item");
        afvip_opcode2_all_seq1 afvip_opcode2_all_seq1 = afvip_opcode2_all_seq1::type_id::create("item");
        afvip_opcode3_all_seq1 afvip_opcode3_all_seq1 = afvip_opcode3_all_seq1::type_id::create("item");
        afvip_opcode4_all_seq1 afvip_opcode4_all_seq1 = afvip_opcode4_all_seq1::type_id::create("item");
        afvip_opcode5_all_seq1 afvip_opcode5_all_seq1 = afvip_opcode5_all_seq1::type_id::create("item");
        afvip_opcode6_all_seq1 afvip_opcode6_all_seq1 = afvip_opcode6_all_seq1::type_id::create("item");
        afvip_opcode7_all_seq1 afvip_opcode7_all_seq1 = afvip_opcode7_all_seq1::type_id::create("item");
        afvip_opcode_seq_v2 afvip_opcode_seq_v2 = afvip_opcode_seq_v2::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        back2back_sequence back2back_sequence = back2back_sequence::type_id::create("item");
        sts_intr sts_intr = sts_intr::type_id::create("item");
        ev_intr_clr ev_intr_clr = ev_intr_clr::type_id::create("item");
        ev_ctrl ev_ctrl = ev_ctrl::type_id::create("item");

        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_write_all_function.start(m_env.agent0.m_seqr0);
        afvip_opcode0_all_seq1.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);
        afvip_opcode1_all_seq1.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);        
        afvip_opcode2_all_seq1.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);        
        afvip_opcode3_all_seq1.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);        
        afvip_opcode4_all_seq1.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);        
        afvip_opcode5_all_seq1.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);        
        afvip_opcode6_all_seq1.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);        
        afvip_opcode7_all_seq1.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_opcode_all_seq1_test

class write_all_read_all_with_back2_back_test extends afvip_base_test;
    `uvm_component_utils(write_all_read_all_with_back2_back_test)
      function new( string name = "write_all_read_all_with_back2_back_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function_back2back afvip_write_all_function_back2back = afvip_write_all_function_back2back::type_id::create("item");
        afvip_read_all_function_back2back afvip_read_all_function_back2back = afvip_read_all_function_back2back::type_id::create("item");
        phase.raise_objection(this);

      for(int i=0; i<10; i++) begin
        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_write_all_function_back2back.start(m_env.agent0.m_seqr0);
        afvip_read_all_function_back2back.start(m_env.agent0.m_seqr0);

      end 
      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : write_all_read_all_with_back2_back_test

class write_all_read_all_with_back2_back_10x_rounds_test extends afvip_base_test;
    `uvm_component_utils(write_all_read_all_with_back2_back_10x_rounds_test)
      function new( string name = "write_all_read_all_with_back2_back_10x_rounds_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function_back2back afvip_write_all_function_back2back = afvip_write_all_function_back2back::type_id::create("item");
        afvip_read_all_function_back2back afvip_read_all_function_back2back = afvip_read_all_function_back2back::type_id::create("item");
        phase.raise_objection(this);

      for(int i=0; i<10; i++) begin
        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_write_all_function_back2back.start(m_env.agent0.m_seqr0);
        afvip_read_all_function_back2back.start(m_env.agent0.m_seqr0);

      end 
      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : write_all_read_all_with_back2_back_10x_rounds_test

class write_20_read_20_read_all_test extends afvip_base_test;
    `uvm_component_utils(write_20_read_20_read_all_test)
      function new( string name = "write_20_read_20_read_all_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_read_20th_address_function afvip_read_20th_address_function = afvip_read_20th_address_function::type_id::create("item");
        afvip_write_20th_function afvip_write_20th_function = afvip_write_20th_function::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

     
        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_write_20th_function.start(m_env.agent0.m_seqr0);
        afvip_read_20th_address_function.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

   
      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : write_20_read_20_read_all_test

class afvip_test_instruction_register_field_0 extends afvip_base_test;

     `uvm_component_utils(afvip_test_instruction_register_field_0)
    function new( string name = "afvip_test_instruction_register_field_0", uvm_component parent = null);
        super.new(name, parent);
    endfunction

     virtual task run_phase (uvm_phase phase);
        afvip_read_all_function afvip_read_all_function= afvip_read_all_function::type_id::create("item");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        sequence_field_with_0 sequence_field_with_0 = sequence_field_with_0::type_id::create("item");
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        phase.raise_objection(this);
    
        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
        afvip_write_all_function.start(m_env.agent0.m_seqr0);
        sequence_field_with_0.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

       `uvm_info(get_type_name(),$sformatf ("To be continued...."), UVM_NONE)
        $display("TEST COMPLETE : afvip_test_instruction_register_field_0");
        phase.drop_objection (this);

     endtask
endclass : afvip_test_instruction_register_field_0

class afvip_test_with_wait_interrupt_and_30_iteration extends afvip_base_test;

     `uvm_component_utils(afvip_test_with_wait_interrupt_and_30_iteration)
    function new( string name = "afvip_test_with_wait_interrupt_and_30_iteration", uvm_component parent = null);
        super.new(name, parent);
    endfunction

     virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence        afvip_seq =                 afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence        afvip_rst_seq =             afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function  afvip_write_all_function =  afvip_write_all_function::type_id::create("item");
        opcode_sequence_0_to_4    opcode_sequence_0_to_4 =    opcode_sequence_0_to_4::type_id::create("item");
        afvip_read_all_function   afvip_read_all_function =   afvip_read_all_function::type_id::create("item");
        sts_intr                  sts_intr =                sts_intr::type_id::create("item");
        ev_intr_clr               ev_intr_clr =                ev_intr_clr::type_id::create("item");
        ev_ctrl                   ev_ctrl =                ev_ctrl::type_id::create("item");

        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
        afvip_write_all_function.start(m_env.agent0.m_seqr0);
      for(int i=0; i<30; i++)begin
        opcode_sequence_0_to_4.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        wait_interrupt();
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);
      end
        afvip_read_all_function.start(m_env.agent0.m_seqr0);
      
       `uvm_info(get_type_name(),$sformatf ("To be continued...."), UVM_NONE)
        $display("TEST COMPLETE : afvip_test_with_wait_interrupt");
        phase.drop_objection (this);

     endtask
endclass : afvip_test_with_wait_interrupt_and_30_iteration

class afvip_write_opcode_read_test extends afvip_base_test;

     `uvm_component_utils(afvip_write_opcode_read_test)
    function new( string name = "afvip_write_opcode_read_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

     virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence        afvip_seq =                 afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence        afvip_rst_seq =             afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function  afvip_write_all_function =  afvip_write_all_function::type_id::create("item");
        afvip_read_all_function   afvip_read_all_function =   afvip_read_all_function::type_id::create("item");
        sts_intr                sts_intr =                sts_intr::type_id::create("item");
        ev_intr_clr                ev_intr_clr =                ev_intr_clr::type_id::create("item");
        ev_ctrl                ev_ctrl =                ev_ctrl::type_id::create("item");

        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
        afvip_write_all_function.start(m_env.agent0.m_seqr0);
        
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);

        afvip_read_all_function.start(m_env.agent0.m_seqr0);
      
       `uvm_info(get_type_name(),$sformatf ("To be continued...."), UVM_NONE)

        phase.drop_objection (this);

     endtask
endclass : afvip_write_opcode_read_test

class coverage_full_test extends afvip_base_test;
    `uvm_component_utils(coverage_full_test)
      function new( string name = "coverage_full_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_with_delay_between_0_and_3 afvip_write_all_with_delay_between_0_and_3 = afvip_write_all_with_delay_between_0_and_3::type_id::create("item");
        opcode_sequence_0_to_4 opcode_sequence_0_to_4 = opcode_sequence_0_to_4::type_id::create("item");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        write_until_addr15 write_until_addr15 = write_until_addr15::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        sts_intr                sts_intr =                sts_intr::type_id::create("item");
        ev_intr_clr                ev_intr_clr =                ev_intr_clr::type_id::create("item");
        ev_ctrl                ev_ctrl =                ev_ctrl::type_id::create("item");
        wrong_addr           wrong_addr      = wrong_addr::type_id::create("item_addr");
        phase.raise_objection(this);


        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
        for (int j=0; j<10; j++) begin
        afvip_write_all_with_delay_between_0_and_3.start(m_env.agent0.m_seqr0);
        end
      for(int i=0; i<500; i++)begin
        afvip_write_all_function.start(m_env.agent0.m_seqr0);
        opcode_sequence_0_to_4.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        
        sts_intr.start(m_env.agent0.m_seqr0);
        wait_interrupt();
        ev_intr_clr.start(m_env.agent0.m_seqr0);
        
        wrong_addr.start(m_env.agent0.m_seqr0);

      end
      wrong_addr.start(m_env.agent0.m_seqr0);
     // afvip_write_all_function.start(m_env.agent0.m_seqr0);
      afvip_read_all_function.start(m_env.agent0.m_seqr0);
 

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : coverage_full_test

class reset_read_all_reg_test extends afvip_base_test;
    `uvm_component_utils(reset_read_all_reg_test)
      function new( string name = "reset_read_all_reg_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);


        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
     
        // afvip_write_all_function.start(m_env.agent0.m_seqr0);
        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : reset_read_all_reg_test

class opcode_6_err_test extends afvip_base_test;
    `uvm_component_utils(opcode_6_err_test)
      function new( string name = "opcode_6_err_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function afvip_write_all_function = afvip_write_all_function::type_id::create("item");
        afvip_opcode_for_opc_5 afvip_opcode_for_opc_5 = afvip_opcode_for_opc_5::type_id::create("item");
        afvip_opcode_seq_v2 afvip_opcode_seq_v2 = afvip_opcode_seq_v2::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        back2back_sequence back2back_sequence = back2back_sequence::type_id::create("item"); 
        afvip_opcode_verificatoni afvip_opcode_verificatoni = afvip_opcode_verificatoni::type_id::create("item"); 
        sts_intr sts_intr = sts_intr::type_id::create("item");
        ev_intr_clr ev_intr_clr = ev_intr_clr::type_id::create("item");
        ev_ctrl ev_ctrl = ev_ctrl::type_id::create("item");
        ev_err_clr ev_err_clr = ev_err_clr::type_id::create("item");

        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
        afvip_write_all_function.start(m_env.agent0.m_seqr0);
        afvip_opcode_for_opc_5.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        wait_interrupt();
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_err_clr.start(m_env.agent0.m_seqr0);

        afvip_opcode_verificatoni.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        wait_interrupt();
        sts_intr.start(m_env.agent0.m_seqr0);
    
        ev_intr_clr.start(m_env.agent0.m_seqr0);
       
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : opcode_6_err_test

class write_d24_write_test extends afvip_base_test;
    `uvm_component_utils(write_d24_write_test)
      function new( string name = "write_d24_write_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        write_d24 write_d24 = write_d24::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        write_d24.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);
       
      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : write_d24_write_test

class afvip_write_all_with_delay_3_test extends afvip_base_test;
    `uvm_component_utils(afvip_write_all_with_delay_3_test)
      function new( string name = "afvip_write_all_with_delay_3_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_with_delay_3 afvip_write_all_with_delay_3 = afvip_write_all_with_delay_3::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        
        afvip_write_all_with_delay_3.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);
      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_write_all_with_delay_3_test

class afvip_write_all_with_delay_between_0_and_3_test extends afvip_base_test;
    `uvm_component_utils(afvip_write_all_with_delay_between_0_and_3_test)
      function new( string name = "afvip_write_all_with_delay_between_0_and_3_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_with_delay_between_0_and_3 afvip_write_all_with_delay_between_0_and_3 = afvip_write_all_with_delay_between_0_and_3::type_id::create("item");
        
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        for (int i=0;i<10;i++) begin
        afvip_write_all_with_delay_between_0_and_3.start(m_env.agent0.m_seqr0);
        end
        afvip_read_all_function.start(m_env.agent0.m_seqr0);
      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_write_all_with_delay_between_0_and_3_test

class read_all_write_all_read_all_to_catch_pslverr_test extends afvip_base_test;
    `uvm_component_utils(read_all_write_all_read_all_to_catch_pslverr_test)
      function new( string name = "read_all_write_all_read_all_to_catch_pslverr_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_wrong_function afvip_write_all_wrong_function = afvip_write_all_wrong_function::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
         afvip_read_all_function.start(m_env.agent0.m_seqr0);
         afvip_write_all_wrong_function.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : read_all_write_all_read_all_to_catch_pslverr_test

class afvip_opcode_verification_test_w_pwdata_incremental extends afvip_base_test;
    `uvm_component_utils(afvip_opcode_verification_test_w_pwdata_incremental)
      function new( string name = "afvip_opcode_verification_test_w_pwdata_incremental", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function_pwdata_incremental afvip_write_all_function_pwdata_incremental = afvip_write_all_function_pwdata_incremental::type_id::create("item");
        afvip_opcode_verificatoni afvip_opcode_verificatoni = afvip_opcode_verificatoni::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        sts_intr sts_intr = sts_intr::type_id::create("item");
        ev_intr_clr ev_intr_clr = ev_intr_clr::type_id::create("item");
        ev_ctrl ev_ctrl = ev_ctrl::type_id::create("item");

        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_write_all_function_pwdata_incremental.start(m_env.agent0.m_seqr0);
    //    for (int i=0; i<550; i++) begin
        afvip_opcode_verificatoni.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);
    //  end
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_opcode_verification_test_w_pwdata_incremental

class coverage_test extends afvip_base_test;
    `uvm_component_utils(coverage_test)
    function new( string name = "coverage_test", uvm_component parent = null);
        super.new(name, parent);
     endfunction

     virtual task run_phase (uvm_phase phase);

        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        write_all_random    write_all_random = write_all_random::type_id::create("item_w");
         afvip_read_all_function             afvip_read_all_function        = afvip_read_all_function::type_id::create("item_r");
         good_random_opcode   opcode          = good_random_opcode::type_id::create("item_opcode");
        sts_intr sts_intr = sts_intr::type_id::create("item");
        ev_intr_clr ev_intr_clr = ev_intr_clr::type_id::create("item");
        ev_ctrl ev_ctrl = ev_ctrl::type_id::create("item");
        wrong_addr           wrong_addr      = wrong_addr::type_id::create("item_addr");

        phase.raise_objection(this);
        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
        write_all_random.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);
        for(int i = 0; i<800; i++) begin
        opcode.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
        ev_intr_clr.start(m_env.agent0.m_seqr0);
        end
        write_all_random.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);
        wrong_addr.start(m_env.agent0.m_seqr0);
        afvip_read_all_function.start(m_env.agent0.m_seqr0);
        `uvm_info(get_type_name(),$sformatf ("Write and read all regiters"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);

    endtask
endclass

 /* class afvip_opcode_verification_test_w_pwdata_incremental_test_for_opcode_edits extends afvip_base_test;
    `uvm_component_utils(afvip_opcode_verification_test_w_pwdata_incremental_test_for_opcode_edits)
      function new( string name = "afvip_opcode_verification_test_w_pwdata_incremental_test_for_opcode_edits", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual task run_phase (uvm_phase phase);
        afvip_apb_sequence  afvip_seq = afvip_apb_sequence::type_id::create("item"); // vezi numele din paranteze <3 
        afvip_rst_sequence afvip_rst_seq = afvip_rst_sequence::type_id::create("item_rst");
        afvip_write_all_function_pwdata_incremental afvip_write_all_function_pwdata_incremental = afvip_write_all_function_pwdata_incremental::type_id::create("item");
        afvip_opcode_verificatoni afvip_opcode_verificatoni = afvip_opcode_verificatoni::type_id::create("item");
        afvip_read_all_function afvip_read_all_function = afvip_read_all_function::type_id::create("item");
        sts_intr sts_intr = sts_intr::type_id::create("item");
        ev_intr_clr ev_intr_clr = ev_intr_clr::type_id::create("item");
        ev_ctrl ev_ctrl = ev_ctrl::type_id::create("item");

        phase.raise_objection(this);

        afvip_rst_seq.start(m_env.agent_rst.m_rst_seqr0);
       // afvip_seq.start(m_env.agent0.m_seqr0);
        afvip_write_all_function_pwdata_incremental.start(m_env.agent0.m_seqr0);
    //    for (int i=0; i<550; i++) begin
        afvip_opcode_verificatoni.start(m_env.agent0.m_seqr0);
        ev_ctrl.start(m_env.agent0.m_seqr0);
        sts_intr.start(m_env.agent0.m_seqr0);
          if (!(ev_intr_clr.randomize() with {

            sts_intr.prdata_saving_sts == 2 -> pwdata_value_for_test == 2;   // FIN

            sts_intr.prdata_saving_sts == 1 -> pwdata_value_for_test == 1;   // ERR

        }))
        `uvm_error(get_type_name(),"Rand error clear intr reg!")
        ev_intr_clr.start(m_env.agent0.m_seqr0);
    //  end
        afvip_read_all_function.start(m_env.agent0.m_seqr0);

      //  afvip_seq.start(m_env.m_afvip_ag.sqer);  
        `uvm_info(get_type_name(),$sformatf ("Hello world"), UVM_NONE)
        $display("test....");
        phase.drop_objection (this);
    endtask
endclass : afvip_opcode_verification_test_w_pwdata_incremental_test_for_opcode_edits  // added 
*/
