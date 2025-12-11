class slave_agent extends uvm_agent;

  `uvm_component_utils(slave_agent);

  slave_monitor mon_h;
  slave_driver drv_h;
  slave_sequencer seqr_h;

  slave_config my_config;

  function new(string name = "slave_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(slave_config)::get(this, "", "slave_config", my_config)) begin
      `uvm_fatal("SLAVE_AGENT", "Set the slave_config")
    end

    mon_h = slave_monitor::type_id::create("mon_h", this);

    if (my_config.is_active == UVM_ACTIVE) begin
      drv_h  = slave_driver::type_id::create("drv_h", this);
      seqr_h = slave_sequencer::type_id::create("seqr_h", this);
    end

  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (my_config.is_active == UVM_ACTIVE) begin
      drv_h.seq_item_port.connect(seqr_h.seq_item_export);
    end
  endfunction : connect_phase


endclass

