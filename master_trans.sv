class master_trans extends uvm_sequence_item;

  `uvm_object_utils(master_trans);
     rand bit  Hresetn;
     rand bit  [1:0] Htrans;
		 rand bit	[2:0]Hsize; 
		 bit 	Hreadyin;
     bit   Hreadyout;
		 rand bit 	[31:0]Hwdata; 
		 rand bit 	[31:0]Haddr;
		 rand bit   Hwrite;
		 rand bit 	Hresp;
     bit  [31:0] Hrdata;
    rand bit [9:0]length;
    rand bit [2:0] Hburst;
     constraint valid_haddr_c1 {
      Haddr inside {[32'h8000_000 : 32'h8000_03ff],[32'h8400_000 : 32'h8400_03ff],
                    [32'h8800_000 : 32'h8800_03ff],[32'h8c00_000 : 32'h8c00_03ff]};}

    constraint valid_hsize_c2 {Hsize inside {0,1,2};}

    constraint valid_haddr_aligned_c3 {
      (Hsize == 1) -> (Haddr % 2 == 0);
      (Hsize == 2) -> (Haddr % 2 == 4);
    }

    constraint boundary_c4 {(Haddr%1024)+(length*(2**Hsize))<=1023;}

    constraint length_of_burst_c5 { 
      (Hburst == 2) -> (length == 4);
      (Hburst == 3) -> (length == 4);
      (Hburst == 4) -> (length == 8);
      (Hburst == 5) -> (length == 8);
      (Hburst == 6) -> (length == 16);
      (Hburst == 7) -> (length == 16);
    }
		
  function new(string name = "master_trans");
    super.new(name);
  endfunction

  function void do_print(uvm_printer printer);
    super.do_print(printer);

    printer.print_field("Hresetn",this.Hresetn,1,UVM_BIN);
    printer.print_field("Hreadyin",this.Hreadyin,1,UVM_BIN);
    printer.print_field("Hreadyout",this.Hreadyout,1,UVM_BIN);
    printer.print_field("Hwrite",this.Hwrite,1,UVM_BIN);
    printer.print_field("Hresp",this.Hresp,1,UVM_BIN);
    printer.print_field("Htrans",this.Htrans,2,UVM_DEC);
    printer.print_field("Hsize",this.Hsize,3,UVM_DEC);
    printer.print_field("Hburst",this.Hburst,3,UVM_DEC);
    printer.print_field("Hlength",this.length,10,UVM_DEC);
    printer.print_field("Haddr",this.Haddr,32,UVM_DEC);
    printer.print_field("Hwdata",this.Hwdata,32,UVM_DEC);
    printer.print_field("Hrdata",this.Hrdata,32,UVM_DEC);
    
endfunction : do_print

endclass


