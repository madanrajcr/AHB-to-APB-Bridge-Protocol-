class base_test extends uvm_test;

  `uvm_component_utils(base_test);

  env env_h;

  slave_config s_cfg;
  master_config m_cfg;

  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // For slave config

    s_cfg = slave_config::type_id::create("s_cfg");

    if (!uvm_config_db#(virtual apb_if)::get(this, "", "sl_if", s_cfg.vif)) begin
      `uvm_fatal("BASE_TEST", "Set the slave interface")
    end

    s_cfg.is_active = UVM_ACTIVE;

    uvm_config_db#(slave_config)::set(this, "*", "slave_config", s_cfg);

    // For master_config

    m_cfg = master_config::type_id::create("m_cfg");

     if (!uvm_config_db#(virtual ahb_if)::get(this, "", "ma_if", m_cfg.vif)) begin
       `uvm_fatal("BASE_TEST", "Set the master interface")
     end

    m_cfg.is_active = UVM_ACTIVE;

    uvm_config_db#(master_config)::set(this, "*", "master_config", m_cfg);

    env_h = env::type_id::create("env_h", this);

  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    `uvm_info("BASE_TEST", "This is run_phase", UVM_LOW)
  endtask : run_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

endclass

class single_test extends base_test;
`uvm_component_utils(single_test)

single_seq s1;

function new(string name="single_test",uvm_component parent=null);
 super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  `uvm_info("SHORT_TEST", "This is build_phase", UVM_LOW)
endfunction : build_phase

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);
  `uvm_info("Single_TEST", "This is before start", UVM_LOW)
  s1=single_seq::type_id::create("s1");
  s1.start(env_h.ma_agt_h.seqr_h);
	#50;
  phase.drop_objection(this);
endtask

endclass

class incr_test extends base_test;
`uvm_component_utils(incr_test)

incr_seq i1;

function new(string name="incr_test",uvm_component parent=null);
 super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  `uvm_info("SHORT_TEST", "This is build_phase", UVM_LOW)
endfunction : build_phase

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);
  `uvm_info("INCR_TEST", "This is before start", UVM_LOW)
  i1=incr_seq::type_id::create("i1");
  i1.start(env_h.ma_agt_h.seqr_h);
  phase.drop_objection(this);
endtask

endclass



class wrap_test extends base_test;
`uvm_component_utils(wrap_test)

wrap_seq w1;

function new(string name="wrap_test",uvm_component parent=null);
 super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
 super.build_phase(phase);
  `uvm_info("WRAP_TEST", "This is build_phase", UVM_LOW)
endfunction : build_phase

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  phase.raise_objection(this);
  `uvm_info("Single_TEST", "This is before start", UVM_LOW)
  w1=wrap_seq::type_id::create("w1");
  w1.start(env_h.ma_agt_h.seqr_h);
  phase.drop_objection(this);
endtask

endclass

