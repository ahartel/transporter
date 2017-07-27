`include "uvm_macros.svh"
import uvm_pkg::*;

class benchmark_test extends uvm_test;
    `uvm_component_utils(benchmark_test)

    benchmark_env bm_env;
    integer spike_times[$];

    function new(string name, uvm_component parent);
	super.new(name, parent);
	spike_times = {};
	spike_times.push_back(12);
	spike_times.push_back(23);

    endfunction: new

    function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	bm_env = benchmark_env::type_id::create(.name("bm_env"), .parent(this));

    endfunction: build_phase

    task run_phase(uvm_phase phase);
	benchmark_sequence#(.SIZE(1)) spike_seq;

	phase.raise_objection(.obj(this));
	
	spike_seq = benchmark_sequence::type_id::create(.name("spike_seq"),
							.contxt(get_full_name()));
	spike_seq.set_times(spike_times);

	assert(spike_seq.randomize());
	spike_seq.start(bm_env.spike_agent.bm_seqr);
	phase.drop_objection(.obj(this));
    endtask: run_phase
endclass: benchmark_test
