`include "uvm_macros.svh"
import uvm_pkg::*;

class benchmark_agent extends uvm_agent;
    `uvm_component_utils(benchmark_agent)

    parameter SIZE = 1;

    uvm_analysis_port#(benchmark_transaction) agent_ap_before;
    uvm_analysis_port#(benchmark_transaction) agent_ap_after;

    benchmark_sequencer#(.SIZE(SIZE)) bm_seqr;
    benchmark_driver bm_drvr;
    benchmark_monitor_before bm_mon_before;
    benchmark_monitor_after bm_mon_after;

    function new(string name, uvm_component parent);
	super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	agent_ap_before = new(.name("agent_ap_before"), .parent(this));
	agent_ap_after = new(.name("agent_ap_after"), .parent(this));

	bm_seqr = benchmark_sequencer::type_id::create(.name("bm_seqr"),
						       .parent(this));
	bm_drvr = benchmark_driver::type_id::create(.name("bm_drvr"),
						    .parent(this));
	bm_mon_before = benchmark_monitor_before::type_id::create(.name("bm_mon_before"),
								  .parent(this));
	bm_mon_after = benchmark_monitor_after::type_id::create(.name("bm_mon_after"),
								.parent(this));
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);

	bm_drvr.seq_item_port.connect(bm_seqr.seq_item_export);
	// tr_mon_before.mon_ap_before.connect(agent_ap_before);
	// tr_mon_after.mon_ap_after.connect(agent_ap_after);
    endfunction: connect_phase
endclass: benchmark_agent
