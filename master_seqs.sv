class master_seqs extends uvm_sequence #(master_trans);

`uvm_object_utils(master_seqs);

 function new (string name = "master_seqs");
        super.new(name);
    endfunction

task body();
 `uvm_info("MASTER_SEQS","This is task body",UVM_LOW)

endtask

endclass

class single_seq extends master_seqs;

`uvm_object_utils(single_seq);

 function new (string name = "single_seq");
        super.new(name);
    endfunction

task body();
super.body();
 `uvm_info("MASTER_SEQS","This is task body",UVM_LOW)

req=master_trans::type_id::create("req");

start_item(req);
req.randomize() with {Htrans==2'b10;
                      Hburst==3'b000;};
finish_item(req);
endtask

endclass



class incr_seq extends master_seqs;

`uvm_object_utils(incr_seq)

bit [31:0] haddr;
bit [2:0] hburst,hsize;
bit hwrite;
bit [9:0] hlength;

 function new (string name = "incr_seq");
        super.new(name);
    endfunction

task body();
super.body();

`uvm_info("MASTER SEQS","This is task body",UVM_LOW)
req=master_trans::type_id::create("req");

start_item(req);
req.randomize() with {Htrans==2'b10;
                      Hburst inside {3,5,7};};
finish_item(req);

haddr=req.Haddr;
hsize=req.Hsize;
hburst=req.Hburst;
hwrite=req.Hwrite;
hlength=req.length;

for(int i=0;i<hlength;i++)
 begin
  start_item(req);
  req.randomize() with { 
                       Htrans==2'b11;
                       Hwrite==hwrite;
                       Hsize==hsize;
                       Hburst==hburst;
                       Haddr==haddr+(2**hsize);};
  finish_item(req);
  haddr=req.Haddr;
end

endtask

endclass

class wrap_seq extends master_seqs;

`uvm_object_utils(wrap_seq)


bit [31:0] haddr,start_addr,boundary_addr;
bit [2:0] hburst,hsize;
bit hwrite;
bit [9:0] hlength;

 function new (string name = "wrap_seq");
        super.new(name);
    endfunction

task body();
 super.body();

 `uvm_info("MASTER SEQS","This is task body",UVM_LOW)

req=master_trans::type_id::create("req");

start_item(req);
req.randomize() with {Htrans==2'b10;
                      Hburst inside {2,4,6};};
finish_item(req);

haddr=req.Haddr;
hsize=req.Hsize;
hburst=req.Hburst;
hwrite=req.Hwrite;
hlength=req.length;

start_addr=int'(req.Haddr/((2**hsize)*(hlength))) * (2**hsize)* hlength;

boundary_addr= start_addr + (2**hsize*hlength);
haddr=req.Haddr + 2**hsize;

for(int i=0;i<hlength;i++)
 begin
   if(haddr>=boundary_addr)
    haddr=start_addr;

  start_item(req);
  req.randomize() with {Htrans==2'b11;
                       Hwrite==hwrite;
                       Hsize==hsize;
                       Hburst==hburst;
                       Haddr==haddr;};
  finish_item(req);
  haddr=req.Haddr + (2**hsize);

end

endtask

endclass

