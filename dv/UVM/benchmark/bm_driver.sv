
class benchmark_driver extends uvm_driver#(benchmark_transaction);
    `uvm_component_utils(benchmark_driver)

    parameter NUM_BYTES = 1;
    protected virtual Byte_if bif;
    protected virtual sys_if sif;

    function new(string name, uvm_component parent);
	super.new(name, parent);
    endfunction // new

    function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	void'(uvm_resource_db#(virtual Byte_if)::read_by_name("ifs", "bif", bif));
        void'(uvm_resource_db#(virtual sys_if)::read_by_name("ifs", "sif", sif));

    endfunction // build_phase
  
    task run_phase(uvm_phase phase);
	drive();
    endtask // run_phase
  

    virtual task drive();
	benchmark_transaction bm_tx;
	integer state = 0;
	integer counter = 0;

	// 0: IDLE,
	// 1: WAIT FOR RELEASE,
	// 2: SEND,
	// 3: WAIT FOR ACCEPT

	forever begin
	    @(posedge sif.clk) begin
		if (state == 0) begin
		    seq_item_port.get_next_item(bm_tx);
		    state = 1;
		end
		else if (state == 1) begin
		    if (bm_tx.timestamp <= sif.systime) begin
			bif.tx_req = 1'b1;
			bif.tx_data = bm_tx.data[0];
			counter = NUM_BYTES-1;
			state = 2;
		    end
		end
		else if (state == 2) begin
		    if (bif.tx_acc == 1'b1) begin
			if (counter > 0) begin
			    state = 3;
			    bif.tx_data = bm_tx.data[1];
			    counter = counter - 1;
			end
			else begin
			    seq_item_port.item_done();
			    state = 0;
			end
		    end
		end
		else if (state == 3) begin
		    if (counter == 0) begin
			seq_item_port.item_done();
			state = 0;
		    end
		    else begin
			bif.tx_data <= bm_tx.data[NUM_BYTES-counter];
			counter = counter - 1;
		    end
		end

	    end
	end


endtask: drive

endclass // timed_release_driver
