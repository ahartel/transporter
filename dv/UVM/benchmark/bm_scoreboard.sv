`uvm_analysis_imp_decl(_before)
`uvm_analysis_imp_decl(_after)

class benchmark_scoreboard #(parameter integer SIZE=1)
    extends uvm_scoreboard;
    `uvm_component_utils(benchmark_scoreboard)

    uvm_analysis_export #(benchmark_transaction) sb_export_before;
    uvm_analysis_export #(benchmark_transaction) sb_export_after;

    uvm_tlm_analysis_fifo #(benchmark_transaction) before_fifo;
    uvm_tlm_analysis_fifo #(benchmark_transaction) after_fifo;

    benchmark_transaction#(SIZE) transaction_before;
    benchmark_transaction#(SIZE) transaction_after;

    function new(string name, uvm_component parent);
	super.new(name, parent);

	transaction_before = benchmark_transaction#(SIZE)::type_id::create(.name("transaction_before"),
									   .contxt(get_full_name()));
	transaction_after = benchmark_transaction#(SIZE)::type_id::create(.name("transaction_after"),
									  .contxt(get_full_name()));
    endfunction: new

    function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	sb_export_before = new("sb_export_before", this);
	sb_export_after  = new("sb_export_after", this);

	before_fifo = new("before_fifo", this);
	after_fifo  = new("after_fifo", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
	sb_export_before.connect(before_fifo.analysis_export);
	sb_export_after.connect(after_fifo.analysis_export);
    endfunction: connect_phase

    task run();
	forever begin
	    before_fifo.get(transaction_before);
	    after_fifo.get(transaction_after);

	    compare();
	end
    endtask: run

    virtual function void compare();
	if(transaction_before.compare(transaction_after)) begin
	   `uvm_info("compare", {"Test: OK!"}, UVM_LOW);
	end else begin
	   `uvm_info("compare", {"Test: Fail!"}, UVM_LOW);
	end
    endfunction: compare
endclass: benchmark_scoreboard
