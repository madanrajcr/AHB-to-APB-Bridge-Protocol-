class slave_trans extends uvm_sequence_item;

  `uvm_object_utils(slave_trans);

   bit [31:0] Paddr;
   bit [31:0] Pwdata;
   rand bit [31:0] Prdata;
   bit [3:0] Pselx;
   bit Penable;
   bit Pwrite;

   constraint Pselx_count { Pselx dist { 4'b0001:=4, 4'b0010:=4, 4'b0100:=4, 4'b1000:=4  } ;}

  function new(string name = "slave_trans");
    super.new(name);
  endfunction

  function void do_print(uvm_printer printer);
    super.do_print(printer);

        printer.print_field("Paddr", this.Paddr, 32, UVM_HEX);
        printer.print_field("Penable", this.Penable, 1, UVM_DEC);
        printer.print_field("Pwrite", this.Pwrite, 1, UVM_DEC);
        printer.print_field("Pselx", this.Pselx, 4, UVM_DEC);
        printer.print_field("Prdata", this.Prdata, 32, UVM_HEX);
        printer.print_field("Pwdata", this.Pwdata, 32, UVM_HEX);

  endfunction : do_print

endclass


