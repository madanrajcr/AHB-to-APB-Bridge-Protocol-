class slave_seqs extends uvm_sequence #(slave_trans);

  `uvm_object_utils(slave_seqs);

  function new(string name = "slave_seqs");
    super.new(name);
  endfunction

  task body();

    `uvm_info("SLAVE_SEQS", "This is task body", UVM_LOW)
	req= slave_trans::type_id::create("req");
      start_item(req);
      req.randomize();
      finish_item(req);
  endtask : body

endclass