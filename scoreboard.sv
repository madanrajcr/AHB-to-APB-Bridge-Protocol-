class scoreboard extends uvm_component;

  `uvm_component_utils(scoreboard)

//Analysis FIFOs declaration

  uvm_tlm_analysis_fifo #(slave_trans) slave_fifo;
  uvm_tlm_analysis_fifo #(master_trans) master_fifo;

//declare the handles for ahb_xtns and apb_xtns

  slave_trans slave_data;
  master_trans master_data;

//handles for read and write coverage data

  slave_trans slave_cov_data;
  master_trans master_cov_data;

     covergroup master_cg;
		option.per_instance = 1;

		//RST: coverpoint master_cov_data.Hresetn;
		
		SIZE: coverpoint master_cov_data.Hsize {bins b2[] = {[0:2]} ;}//1,2,4 bytes of data
		
		TRANS: coverpoint master_cov_data.Htrans {bins nonseq = {2};
						          bins seq    = {3};} //NS and S
		
		//BURST: coverpoint master_cov_data.Hburst {bins burst[] = {[0:7]} ;}
		
		ADDR: coverpoint master_cov_data.Haddr {bins first_slave  = {[32'h8000_0000:32'h8000_03ff]};
						        bins second_slave = {[32'h8400_0000:32'h8400_03ff]};
                                                        bins third_slave  = {[32'h8800_0000:32'h8800_03ff]};
                                                        bins fourth_slave = {[32'h8C00_0000:32'h8C00_03ff]};}

		DATA_IN: coverpoint master_cov_data.Hwdata {bins low  = {[0:32'h0000_ffff]};
                                                            bins mid1 = {[32'h0001_ffff:32'hffff_ffff]};}

                DATA_OUT : coverpoint master_cov_data.Hrdata {bins low  = {[0:32'h0000_ffff]};
                                                              bins mid1 = {[32'h0001_ffff:32'hffff_ffff]};}
		WRITE : coverpoint master_cov_data.Hwrite;

		//SIZEXWRITE: cross SIZE, WRITE;

		//ADDRXDATA: cross ahb_cov_data.Haddr, ahb_cov_data.Hwdata;
	endgroup: master_cg

   covergroup slave_cg;
		option.per_instance = 1;
		
		ADDR : coverpoint slave_cov_data.Paddr {bins first_slave = {[32'h8000_0000:32'h8000_03ff]};
                                                       bins second_slave = {[32'h8400_0000:32'h8400_03ff]};
                                                       bins third_slave  = {[32'h8800_0000:32'h8800_03ff]};
                                                       bins fourth_slave = {[32'h8C00_0000:32'h8C00_03ff]};}
				
		DATA_IN : coverpoint slave_cov_data.Pwdata {bins low = {[0:32'h0000_ffff]};
                                                           bins mid1 = {[32'h0001_ffff:32'hffff_ffff]};}

                DATA_OUT : coverpoint slave_cov_data.Prdata {bins low = {[0:32'hffff_ffff]};}

                WRITE : coverpoint slave_cov_data.Pwrite;

                SEL : coverpoint slave_cov_data.Pselx {bins first_slave  = {4'b0001};
                                                       bins second_slave = {4'b0010};
                                                       bins third_slave  = {4'b0100};
                                                       bins fourth_slave = {4'b1000};}

		//WRITEXSEL: cross WRITE, SEL;
		//ADDRXWRITE: cross slave_cov_data.Paddr, apb_cov_data.Pwrite;
	endgroup: slave_cg

  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
    slave_fifo  = new("slave_fifo", this);
    master_fifo = new("master_fifo", this);
     slave_cg = new();
     master_cg = new();
     master_cov_data = new();
     slave_cov_data  = new();
  endfunction

  virtual task run_phase(uvm_phase phase);
    `uvm_info("SCOREBOARD", "This is run_phase", UVM_LOW)
	
	forever
		begin
	        	fork
				begin
					master_fifo.get(master_data);
					master_cg.sample();
			        end

				begin		
					slave_fifo.get(slave_data);
					slave_cg.sample();
			 	end
			join
				check_data(master_data,slave_data);
		end

  endtask : run_phase

 task check_data(master_trans ahb,slave_trans apb);
        
        if(ahb.Hwrite)
        begin
                case(ahb.Hsize)

                2'b00:
                begin
                        if(ahb.Haddr[1:0] == 2'b00)
                                compare(ahb.Hwdata[7:0], apb.Pwdata[7:0], ahb.Haddr, apb.Paddr);
                        if(ahb.Haddr[1:0] == 2'b01)
                                compare(ahb.Hwdata[15:8], apb.Pwdata[7:0], ahb.Haddr, apb.Paddr);
                        if(ahb.Haddr[1:0] == 2'b10)
                                compare(ahb.Hwdata[23:16], apb.Pwdata[7:0], ahb.Haddr, apb.Paddr);
                        if(ahb.Haddr[1:0] == 2'b11)
                                compare(ahb.Hwdata[31:24], apb.Pwdata[7:0], ahb.Haddr, apb.Paddr);

                end
		2'b01:
                begin
                        if(ahb.Haddr[1:0] == 2'b00)
                                compare(ahb.Hwdata[15:0], apb.Pwdata[15:0], ahb.Haddr, apb.Paddr);
                        if(ahb.Haddr[1:0] == 2'b10)
                                compare(ahb.Hwdata[31:16], apb.Pwdata[15:0], ahb.Haddr, apb.Paddr);
                end

                2'b10:
                        compare(ahb.Hwdata, apb.Pwdata, ahb.Haddr, apb.Paddr);

                endcase
        end

        else
        begin
                case(ahb.Hsize)

                2'b00:
                begin
                        if(ahb.Haddr[1:0] == 2'b00)
                                compare(ahb.Hrdata[7:0], apb.Prdata[7:0], ahb.Haddr, apb.Paddr);
                        if(ahb.Haddr[1:0] == 2'b01)
                                compare(ahb.Hrdata[7:0], apb.Prdata[15:8], ahb.Haddr, apb.Paddr);
                        if(ahb.Haddr[1:0] == 2'b10)
                                compare(ahb.Hrdata[7:0], apb.Prdata[23:16], ahb.Haddr, apb.Paddr);
                        if(ahb.Haddr[1:0] == 2'b11)
                                compare(ahb.Hrdata[7:0], apb.Prdata[31:24], ahb.Haddr, apb.Paddr);

                end

                2'b01:
                begin
			if(ahb.Haddr[1:0] == 2'b00)
                                compare(ahb.Hrdata[15:0], apb.Prdata[15:0], ahb.Haddr, apb.Paddr);
			if(ahb.Haddr[1:0] == 2'b10)
                                compare(ahb.Hrdata[15:0], apb.Prdata[31:16], ahb.Haddr, apb.Paddr);
                end

                2'b10:
                        compare(ahb.Hrdata, apb.Prdata, ahb.Haddr, apb.Paddr);

                endcase
        end
endtask

task compare(int Hdata, Pdata, Haddr, Paddr);

        if(Haddr == Paddr)
	begin
                $display("Address compared Successfully");
		$display("HADDR=%h, PADDR=%h", Haddr, Paddr);
	end
        else
        begin
                $display("Address not compared Successfully");
		$display("HADDR=%h, PADDR=%h", Haddr, Paddr);
        end

        if(Hdata == Pdata) 
	begin
                $display("Data compared Successfully");
		$display("HDATA=%h, PDATA=%h", Hdata, Pdata);
	end
        else
        begin
                $display("Data not compared Successfully");
		$display("HDATA=%h, PDATA=%h", Hdata, Pdata);
        end
endtask

endclass
