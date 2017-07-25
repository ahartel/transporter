`include "uvm_macros.svh"
import uvm_pkg::*;

class benchmark_env extends uvm_env;
    `uvm_component_utils(benchmark_env)

    benchmark_agent #(.SIZE(1)) spike_agent;
    benchmark_agent #(.SIZE(12)) mem_agent;
    benchmark_agent #(.SIZE(6)) omnibus_agent;
    benchmark_agent #(.SIZE(5)) spi_agent;
    benchmark_agent #(.SIZE(4)) madc_agent;
    benchmark_agent #(.SIZE(4)) sync_agent;
    
    benchmark_scoreboard bm_sb;

    function new(string name, uvm_component parent);
	super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	spike_agent = benchmark_agent::type_id::create(.name("spike_agent"),
						       .parent(this));
	bm_sb = benchmark_scoreboard::type_id::create(.name("bm_sb"),
						      .parent(this));
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	spike_agent.agent_ap_before.connect(bm_sb.sb_export_before);
	spike_agent.agent_ap_after.connect(bm_sb.sb_export_after);
    endfunction: connect_phase
endclass: benchmark_env
