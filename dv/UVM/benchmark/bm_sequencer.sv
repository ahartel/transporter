`include "uvm_macros.svh"
import uvm_pkg::*;

class benchmark_transaction #(parameter integer SIZE=1)
    extends uvm_sequence_item;
    `uvm_object_utils(benchmark_transaction);

    rand bit[7:0] data[SIZE];
    bit[31:0] timestamp;

    function new(string name = "");
	super.new(name);
    endfunction: new

    function logic equals(benchmark_transaction rhs);
	logic ret = data == rhs.data;
	return ret;
    endfunction // equals

    function set_time(integer t);
	timestamp = t;
    endfunction // set_time
    

    //`uvm_object_utils_begin(benchmark_transaction)
    // 	`uvm_field_int_array(data, UVM_ALL_ON)
    // 	`uvm_field_int(timestamp, UVM_ALL_ON)
    //`uvm_object_utils_end
  
endclass : benchmark_transaction

class benchmark_sequence #(parameter integer SIZE=1)
    extends uvm_sequence#(benchmark_transaction#(.SIZE(SIZE)));
    `uvm_object_utils(benchmark_sequence)

    integer timestamps[$];
    
    function new(string name = "");
	super.new(name);
	timestamps = {};
    endfunction // new

    function set_times(integer times[$]);

	timestamps = times;
    endfunction

    task body();
	benchmark_transaction#(SIZE) bm_tx;
	`uvm_info("body", $psprintf("Generating %0d samples.", timestamps.size()),
		  UVM_LOW);
	foreach (timestamps[i]) begin
	    bm_tx = benchmark_transaction#(SIZE)::type_id::create(.name("bm_tx"),
	 							  .contxt(get_full_name()));
    
	    start_item(bm_tx);
	    assert(bm_tx.randomize());
	    bm_tx.set_time(timestamps[i]);
	    `uvm_info("bm_sequence", bm_tx.sprint(), UVM_LOW);
	    finish_item(bm_tx);
	end
    endtask // body

endclass : benchmark_sequence

class benchmark_sequencer #(parameter integer SIZE=1)
    extends uvm_sequencer#(benchmark_transaction#(.SIZE(SIZE)));
    `uvm_object_utils(benchmark_sequencer)

    function new(string name = "");
	super.new(name);

    endfunction // new
endclass // benchmark_sequencer

