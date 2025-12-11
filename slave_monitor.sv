class slave_monitor extends uvm_monitor;

  `uvm_component_utils(slave_monitor);
   virtual apb_if.MON_MP vif;
   slave_config my_config;
   slave_trans data_sent;

  uvm_analysis_port #(slave_trans) slave_port;

  function new(string name = "slave_monitor", uvm_component parent);
    super.new(name, parent);
    slave_port = new("slave_port", this);
  endfunction

   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SLAVE_MONITOR", "This is build_phase", UVM_LOW)

    if (!uvm_config_db#(slave_config)::get(this, "", "slave_config", my_config)) begin
      `uvm_fatal("SLAVE_MONITOR", "Set the slave_config")
    end
  endfunction : build_phase

   function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = my_config.vif;
    `uvm_info("SLAVE_MONITOR", "This is connect_phase", UVM_LOW)
  endfunction : connect_phase

   task run_phase(uvm_phase phase);
    `uvm_info("SLAVE_MONITOR", "This is run_phase", UVM_LOW)
     forever begin
       collect_data();
    end
   endtask : run_phase

   task collect_data();

    `uvm_info("SLAVE_MONITOR", "This is collect_data", UVM_LOW)
     data_sent = slave_trans :: type_id :: create("data_sent");
     
      wait(vif.mon_cb.Penable==1)
      data_sent.Paddr   = vif.mon_cb.Paddr;
      data_sent.Pwrite  = vif.mon_cb.Pwrite;
      data_sent.Penable = vif.mon_cb.Penable;
      data_sent.Pselx   = vif.mon_cb.Pselx;
      
      if(data_sent.Pwrite==1) 
        data_sent.Pwdata = vif.mon_cb.Pwdata;
      else
        data_sent.Prdata = vif.mon_cb.Prdata;

      @(vif.mon_cb); //give 1 cycle delay - Setup + enable

`uvm_info("APB_MONITOR", $sformatf("printing from monitor \n %s", data_sent.sprint()), UVM_LOW)

	slave_port.write(data_sent);
  endtask



endclass
