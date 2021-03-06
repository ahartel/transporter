interface sys_if();
    logic clk, reset;
    logic[31:0] systime;
endinterface // sys_if

module id (Byte_if.arbiter asic,
	   Byte_if.client fpga);

    assign fpga.tx_data = asic.tx_data;
    assign fpga.tx_req = asic.tx_req;
    assign fpga.rx_acc = asic.rx_acc;
    
    assign asic.tx_acc = fpga.tx_acc;
    assign asic.rx_data = fpga.rx_data;
    assign asic.rx_req = fpga.rx_req;
    
endmodule

module benchmark_tb_top;
    import uvm_pkg::*;

    parameter NUM_CLIENTS = 6;
    
    sys_if sif();
    Byte_if bif_asic[NUM_CLIENTS]();
    Byte_if bif_fpga[NUM_CLIENTS]();

    // DUT
    id pseudo_dut [NUM_CLIENTS] (bif_asic, bif_fpga);

    generate
    	for (genvar i=0; i<NUM_CLIENTS; i++) begin
	    assign bif_fpga[i].tx_acc = 1'b1;
	    assign bif_asic[i].rx_acc = 1'b1;
	    
    	    initial uvm_resource_db#(virtual Byte_if)::set("ifs",
							   $psprintf("bif_asic_%0d", i),
    							   bif_asic[i]);
	    initial uvm_resource_db#(virtual Byte_if)::set("ifs",
							   $psprintf("bif_fpga_%0d", i),
    							   bif_fpga[i]);
    	end
    endgenerate

    initial begin
	// From Section 4.4 of the UVM manual:
	// "uvm_resource_db provides side-band (non-hierarchical) data sharing"
	// uvm_resource_db takes the following parameters and arguments:
	// - The parameter is the type of the value to store
	// - The database name (?) is the first argument
	// - The second argument is the name of the field wherein to store
	// - The third field contains the value
	// - The fourth field stores the class instance for debugging purposes
	
	uvm_resource_db#(virtual sys_if)::set("ifs", "sif", sif);
	
	run_test();
    end

    // Variable initialization
    initial begin
	sif.clk <= 1'b1;
	sif.systime <= 0;
	// for (integer i=0; i<NUM_CLIENTS; i++) begin
	//     bif_asic[i].tx_acc = 1'b1;
	//     bif_asic[i].rx_acc = 1'b1;
	//     bif_fpga[i].tx_acc = 1'b1;
	//     bif_fpga[i].rx_acc = 1'b1;
	// end
    end

    // Clock generation
    always
	#5 sif.clk = ~sif.clk;
    // systime increment
    always @(posedge sif.clk)
	sif.systime = sif.systime + 1;

endmodule
