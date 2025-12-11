interface ahb_if ( input bit clk);

        logic  Hresetn;
        logic  [1:0] Htrans;
	logic	[2:0]Hsize; 
	logic 	Hreadyin;
        logic   Hreadyout;
	logic 	[31:0]Hwdata; 
	logic 	[31:0]Haddr;
	logic   Hwrite;
	logic 	Hresp;
        logic   Hrdata;
		

clocking ahb_drv_cb @(posedge clk);
        output  Hresetn;
        output  Htrans;
        output  Hwrite;
        output  Hsize;
        output  Hreadyin;
        output  Hwdata;
        output  Haddr;
        input  Hreadyout; 
endclocking : ahb_drv_cb

clocking ahb_mon_cb @(posedge clk);
        input  Hresetn;
        input  Htrans;
        input  Hwrite;
        input  Hsize;
        input  Hreadyin;
        input  Hwdata;
        input  Haddr;
        input  Hreadyout;
        input  Hrdata;
        input  Hresp;
endclocking : ahb_mon_cb

modport DRV_MP(clocking ahb_drv_cb);
modport MON_MP(clocking ahb_mon_cb);


endinterface


