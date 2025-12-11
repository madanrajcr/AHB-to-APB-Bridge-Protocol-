class master_monitor extends uvm_monitor;

  `uvm_component_utils(master_monitor);
  virtual ahb_if.MON_MP vif;
  master_config my_config;
  master_trans data_sent;

  uvm_analysis_port #(master_trans) master_port;

  function new(string name = "master_monitor", uvm_component parent);
    super.new(name, parent);
    master_port = new("master_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MASTER_MONITOR", "This is build_phase", UVM_LOW)

    if (!uvm_config_db#(master_config)::get(this, "", "master_config", my_config)) begin
      `uvm_fatal("MASTER_MONITOR", "Set the master_config")
    end
  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = my_config.vif;
    `uvm_info("MASTER_MONITOR", "This is connect_phase", UVM_LOW)
  endfunction : connect_phase

   virtual task run_phase(uvm_phase phase);
     `uvm_info("MASTER_MONITOR", "This is run_phase", UVM_LOW)
     forever begin
       collect_data();
     end
   endtask : run_phase

  virtual task collect_data();

    `uvm_info("MASTER_MONITOR", "This is collect_data", UVM_LOW)
    data_sent = master_trans :: type_id :: create("data_sent");
    
      wait(vif.ahb_mon_cb.Hreadyout==1)
      @(vif.ahb_mon_cb);
      wait(vif.ahb_mon_cb.Htrans == 2 || vif.ahb_mon_cb.Htrans == 3)
      @(vif.ahb_mon_cb);

      data_sent.Haddr    =  vif.ahb_mon_cb.Haddr; 
      data_sent.Hsize    =  vif.ahb_mon_cb.Hsize; 
      data_sent.Hwrite   =  vif.ahb_mon_cb.Hwrite;
      data_sent.Htrans   =  vif.ahb_mon_cb.Htrans; 
      data_sent.Hreadyin =  vif.ahb_mon_cb.Hreadyin;
      //data_sent.Hburst   =  vif.ahb_mon_cb.Hburst;
      @(vif.ahb_mon_cb);
      wait(vif.ahb_mon_cb.Hreadyout==1)
      if(data_sent.Hwrite) 
        data_sent.Hwdata = vif.ahb_mon_cb.Hwdata;
      else
        data_sent.Hrdata = vif.ahb_mon_cb.Hrdata;
  `uvm_info("AHB_MONITOR", $sformatf("printing from monitor \n %s", data_sent.sprint()), UVM_LOW)
	master_port.write(data_sent);
  endtask


endclass
