`include "uvm_macros.svh"
import uvm_pkg::*;

class benchmark_transaction extends uvm_sequence_item;
    parameter SIZE = 1;
    rand bit[7:0] data[SIZE];
    bit[31:0] timestamp;

    function new(string name = "");
	super.new(name);
    endfunction: new

    function logic equals(benchmark_transaction rhs);
	logic ret = data == rhs.data;
	return ret;
    endfunction

    // `uvm_object_utils_begin(benchmark_transaction)
    // 	`uvm_field_int_array(data, UVM_ALL_ON)
    // 	`uvm_field_int(timestamp, UVM_ALL_ON)
    // `uvm_object_utils_end
  
endclass : benchmark_transaction

// class timed_release_sequence extends uvm_sequence#(timed_release_transaction);
//     `uvm_object_utils(timed_release_sequence)
//     integer num_samples;
    
//     function new(string name = "");
// 	super.new(name);
// 	num_samples = 150;
//     endfunction // new

//     task body();
// 	timed_release_transaction tr_tx;
// 	`uvm_info("body", $psprintf("Generating %0d samples.", num_samples), UVM_LOW);
// 	repeat(num_samples) begin
// 	    tr_tx = timed_release_transaction::type_id::create(.name("tr_tx"),
// 							       .contxt(get_full_name()));

// 	    start_item(tr_tx);
// 	    assert(tr_tx.randomize());
// 	    //`uvm_info("tr_sequence", tr_tx.sprint(), UVM_LOW);
// 	    finish_item(tr_tx);
// 	end
//     endtask // body

// endclass : timed_release_sequence


// typedef uvm_sequencer#(timed_release_transaction) timed_release_sequencer;
