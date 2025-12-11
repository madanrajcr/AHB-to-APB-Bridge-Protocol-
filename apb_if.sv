interface apb_if(input bit clk);

    logic [31:0] Prdata;
    logic [31:0] Pselx;
    logic Pwrite;
    logic Penable;
    logic [31:0] Paddr;
    logic [31:0] Pwdata;

    clocking drv_cb @(posedge clk);
            output Prdata;
            input Pselx;
            input Penable;
            input Pwrite;
    endclocking : drv_cb
    clocking mon_cb @(posedge clk);
            input Prdata;
            input Pselx;
            input Penable;
            input Pwrite;
            input Paddr;
            input Pwdata;
    endclocking : mon_cb

    modport DRV_MP(clocking drv_cb);
    modport MON_MP(clocking mon_cb);

endinterface