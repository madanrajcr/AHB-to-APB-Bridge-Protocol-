class slave_driver extends uvm_driver #(slave_trans);

  `uvm_component_utils(slave_driver)

  virtual apb_if.DRV_MP vif;
  slave_trans trans;
  slave_config my_config;

  function new(string name = "slave_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("SLAVE_DRIVER", "This is build_phase", UVM_LOW)

    if (!uvm_config_db#(slave_config)::get(this, "", "slave_config", my_config)) begin
      `uvm_fatal("SLAVE_DRIVER", "Set the slave_config")
    end

  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = my_config.vif;
    `uvm_info("SLAVE_DRIVER", "This is connect_phase", UVM_LOW)
  endfunction : connect_phase

    task run_phase(uvm_phase phase);
  
     `uvm_info("SLAVE_DRIVER", "This is run_phase", UVM_LOW)
  
     forever begin
       seq_item_port.get_next_item(req);
       send_to_dut(req);
       seq_item_port.item_done();
      `uvm_info("APB driver",$sformatf("APB driver data:\n %s",req.sprint()),UVM_LOW)

     end
     
   endtask : run_phase

  task send_to_dut(slave_trans trans);

    `uvm_info("SLAVE_DRIVER", "This is send_to_dut", UVM_LOW)
    @(vif.drv_cb);
    wait(vif.drv_cb.Pselx!==0)
    if(vif.drv_cb.Pwrite==0)
       vif.drv_cb.Prdata <= trans.Prdata;
    //else
     //  vif.drv_cb.Pwdata <= trans.Pwdata;

    @(vif.drv_cb);
      `uvm_info("APB driver",$sformatf("APB driver data:\n %s",trans.sprint()),UVM_LOW)

  endtask

endclass
