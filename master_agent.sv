class master_agent extends uvm_agent;

  `uvm_component_utils(master_agent);

  master_monitor mon_h;
  master_driver drv_h;
  master_sequencer seqr_h;

  master_config my_config;

  function new(string name = "master_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("MASTER_AGENT", "This is build_phase", UVM_LOW)

    if (!uvm_config_db#(master_config)::get(this, "", "master_config", my_config)) begin
      `uvm_fatal("MASTER_AGENT", "Set the master_config")
    end

    mon_h = master_monitor::type_id::create("mon_h", this);

    if (my_config.is_active == UVM_ACTIVE) begin
      drv_h  = master_driver::type_id::create("drv_h", this);
      seqr_h = master_sequencer::type_id::create("seqr_h", this);
    end

  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MASTER_AGENT", "This is connect_phase", UVM_LOW)
    if (my_config.is_active == UVM_ACTIVE) begin
      drv_h.seq_item_port.connect(seqr_h.seq_item_export);
    end
  endfunction : connect_phase


endclass

