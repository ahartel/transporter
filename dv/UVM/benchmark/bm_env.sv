`include "uvm_macros.svh"
import uvm_pkg::*;

class benchmark_env extends uvm_env;
    `uvm_component_utils(benchmark_env)

    parameter integer SPIKE_SIZE = 1;

    benchmark_agent #(.SIZE(SPIKE_SIZE)) spike_agent;
    // benchmark_agent #(.SIZE(12)) mem_agent;
    // benchmark_agent #(.SIZE(6)) omnibus_agent;
    // benchmark_agent #(.SIZE(5)) spi_agent;
    // benchmark_agent #(.SIZE(4)) madc_agent;
    // benchmark_agent #(.SIZE(4)) sync_agent;
    
    benchmark_scoreboard #(.SIZE(SPIKE_SIZE)) spike_sb;

    function new(string name, uvm_component parent);
	super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	spike_agent = benchmark_agent::type_id::create(.name("spike_agent"),
						       .parent(this));
	spike_sb = benchmark_scoreboard#(SPIKE_SIZE)::type_id::create(.name("spike_sb"),
								      .parent(this));
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	spike_agent.agent_ap_before.connect(spike_sb.sb_export_before);
	spike_agent.agent_ap_after.connect(spike_sb.sb_export_after);
    endfunction: connect_phase
endclass: benchmark_env
