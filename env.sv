class env extends uvm_env;

  `uvm_component_utils(env);

  slave_agent  sl_agt_h;
  master_agent ma_agt_h;

  scoreboard   sb_h;

  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    `uvm_info("ENV", "This is build_phase", UVM_LOW)

    sl_agt_h = slave_agent::type_id::create("sl_agt_h", this);
    ma_agt_h = master_agent::type_id::create("ma_agt_h", this);

    sb_h = scoreboard::type_id::create("sb_h", this);

  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    `uvm_info("ENV", "This is connect_phase", UVM_LOW)

    sl_agt_h.mon_h.slave_port.connect(sb_h.slave_fifo.analysis_export);
    ma_agt_h.mon_h.master_port.connect(sb_h.master_fifo.analysis_export);

  endfunction : connect_phase

endclass
