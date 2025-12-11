package test_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  `include "slave_trans.sv"
  `include "master_trans.sv"

  `include "slave_config.sv"
  `include "master_config.sv"

  `include "slave_seqs.sv"
  `include "master_seqs.sv"

  `include "slave_driver.sv"
  `include "slave_monitor.sv"
  `include "slave_sequencer.sv"
  `include "slave_agent.sv"

  `include "master_driver.sv"
  `include "master_monitor.sv"
  `include "master_sequencer.sv"
  `include "master_agent.sv"

  `include "scoreboard.sv"

  `include "env.sv"

  `include "base_test.sv"

endpackage


