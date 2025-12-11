module top ();

  bit clk;

  import test_pkg::*;
  import uvm_pkg::*;

  ahb_if ma_if(clk);
  apb_if sl_if(clk);

  rtl_top dut(

            .Hclk(clk),
            .Hresetn(ma_if.Hresetn),
            .Htrans(ma_if.Htrans),
            .Hsize(ma_if.Hsize),
            .Hreadyin(ma_if.Hreadyin),
            .Hwdata(ma_if.Hwdata),
            .Haddr(ma_if.Haddr),
            .Hwrite(ma_if.Hwrite),
            .Hreadyout(ma_if.Hreadyout),
            .Hresp(ma_if.Hresp),
            .Hrdata(ma_if.Hrdata),

            .Prdata(sl_if.Prdata),
            .Pselx(sl_if.Pselx),
            .Pwrite(sl_if.Pwrite),
            .Penable(sl_if.Penable),
            .Paddr(sl_if.Paddr),
            .Pwdata(sl_if.Pwdata)

  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin

      uvm_config_db#(virtual ahb_if)::set(null,"*","ma_if",ma_if);
      uvm_config_db#(virtual apb_if)::set(null,"*","sl_if",sl_if);

      run_test();

  end

endmodule
/*
property only_one_bit_high_Psel;
        @(posedge clock)  (Pselx == 4'b0000 || Pselx == 4'b1000 || Pselx == 4'b0100 || Pselx == 4'b0010 || Pselx == 4'b0001);
            
 //       @(posedge clock) $onehot0(Pselx);

endproperty

ONLY_ONE_BIT_HIGH_PSEL: assert property (only_one_bit_high_Psel);
       
*/
