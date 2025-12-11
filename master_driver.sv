class master_driver extends uvm_driver #(master_trans);

  `uvm_component_utils(master_driver);
  
  virtual ahb_if.DRV_MP vif;
  
  master_config my_config;


  function new(string name = "master_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    `uvm_info("MASTER_DRIVER", "This is build_phase", UVM_LOW)

    if (!uvm_config_db#(master_config)::get(this, "", "master_config", my_config)) begin
      `uvm_fatal("MASTER_DRIVER", "Set the master_config")
    end

  endfunction : build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = my_config.vif;
    `uvm_info("MASTER_DRIVER", "This is connect_phase", UVM_LOW)
  endfunction : connect_phase

   virtual task run_phase(uvm_phase phase);
 
     `uvm_info("MASTER_DRIVER", "This is run_phase", UVM_LOW)
    @(vif.ahb_drv_cb); // 1st cycle
    vif.ahb_drv_cb.Hresetn <= 1'b1; 
   repeat(1)
      @(vif.ahb_drv_cb); // 2nd cycle
      vif.ahb_drv_cb.Hresetn <= 1'b0; 
      wait(vif.ahb_drv_cb.Hreadyout)
      $display("started driving");
     forever begin
       seq_item_port.get_next_item(req);
       send_to_dut(req);
       seq_item_port.item_done();
     end
   endtask : run_phase

  task send_to_dut(master_trans trans);

    `uvm_info("MASTER_DRIVER", "This is send_to_dut", UVM_LOW)
      wait(vif.ahb_drv_cb.Hreadyout==1)
      @(vif.ahb_drv_cb);
      vif.ahb_drv_cb.Haddr <= trans.Haddr;
      vif.ahb_drv_cb.Hsize <= trans.Hsize;
      vif.ahb_drv_cb.Hwrite <= trans.Hwrite;
      vif.ahb_drv_cb.Htrans <= trans.Htrans;
      vif.ahb_drv_cb.Hreadyin <= 1'b1;
      //vif.ahb_drv_cb.Hburst <= trans.Hburst;
      @(vif.ahb_drv_cb);
      wait(vif.ahb_drv_cb.Hreadyout==1)
      @(vif.ahb_drv_cb);
      if(trans.Hwrite) 
        vif.ahb_drv_cb.Hwdata <= trans.Hwdata;
      else
      vif.ahb_drv_cb.Hwdata <= 32'd0;
      `uvm_info("AHB driver",$sformatf("AHB driver data:\n %s",req.sprint()),UVM_LOW)

  endtask

endclass
