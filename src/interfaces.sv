// V1: Simplest and most power-consuming version with source-synchronous clocking

interface serdes_par_if();
    logic tx_req, tx_gnt, rx_req, rx_gnt;
    logic[7:0] tx_data, rx_data;

    modport serdes(input tx_req, rx_gnt, tx_data, output tx_gnt, rx_req, rx_data);

    modport client(input tx_gnt, rx_req, rx_data, output tx_req, rx_gnt, tx_data);
endinterface // serdes_par_if

interface serdes_ser_if();
    logic tx_clk, rx_clk;
    logic tx_data, rx_data;

    modport pins(input tx_clk, tx_data, output rx_clk, rx_data);

    modport serdes(input rx_clk, rx_data, output tx_clk, tx_data);
endinterface

interface Byte_if();
    logic[7:0] tx_data, rx_data;
    logic tx_req, tx_acc;
    logic rx_req, rx_acc;

    modport arbiter(input tx_data, tx_req, rx_acc,
		    output rx_data, rx_req, tx_acc);
    modport client(output tx_data, tx_req, rx_acc,
		   input rx_data, rx_req, tx_acc);
endinterface // byte_if

