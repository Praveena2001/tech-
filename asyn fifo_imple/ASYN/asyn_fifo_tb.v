`include "asyn_fifo.v"
module tb;
	parameter WIDTH=8;
	parameter DEPTH=16;
	parameter PTR_WIDTH=$clog2(DEPTH);

	reg wr_clk_i,rd_clk_i,res_i,wr_en_i,rd_en_i;
	reg [WIDTH-1:0]wdata_i;
	wire [WIDTH-1:0]rdata_o;
	wire full_o,over_flow_o,empty_o,under_flow_o;
	asyn_fifo dut (wr_clk_i,rd_clk_i,res_i,wr_en_i,rd_en_i,wdata_i,rdata_o,full_o,overflow_o,empty_o,underflow_o);
	integer i,j,k,wr_delay,rd_delay;
	always #5 wr_clk_i=~wr_clk_i;
	always #7 rd_clk_i=~rd_clk_i;
	reg[20*8-1:0]testcase;
	initial begin
		$value$plusargs("testcase=%0s",testcase);
	end
	initial begin
		wr_clk_i=0;
		rd_clk_i=0;
		res_i=1;
		reset();
		repeat(2) @(posedge wr_clk_i);
		res_i=0;
		//writes(5);
		//reads(5);
		case(testcase)
			"5WR_5RD": begin
				writes(5);
				reads(5);
			end
			"FULL" : begin
				writes(DEPTH);
			end
			"OVER_FLOW": begin
				writes(DEPTH+1);
			end
			"EMPTY" :begin
				writes(DEPTH);
				reads(DEPTH);
			end
			"UNDER_FLOW" :begin
				writes(DEPTH);
				reads(DEPTH+1);
			end
			"CONCURRENT": begin
				fork
					begin
						for(j=0;j<20;j=j+1) begin
							writes(1);
							wr_delay=$urandom_range(5,15);
							#(wr_delay);
						end
					end
					begin
						wait(empty_o==0);
						for(k=0;k<20;k=k+1) begin
							reads(1);
							rd_delay=$urandom_range(5,15);
							#(rd_delay);
						end
					end
				join
			end
		endcase
		#100;
		$finish;

	end
	task  reset(); begin
		wr_en_i=0;
		rd_en_i=0;
		wdata_i=0;
	end
	endtask

//write task
task writes(input integer num_writes); begin
	for(i=0;i<num_writes;i=i+1) begin
		@(posedge wr_clk_i);
		wr_en_i=1;
		wdata_i=$urandom_range(100,500);			
	end
	@(posedge wr_clk_i);
	wr_en_i=0;
	wdata_i=0;
end
endtask

//read task

task reads(input integer num_reads); begin
	for(i=0;i<num_reads;i=i+1) begin
		@(posedge rd_clk_i);
		rd_en_i=1;
	end
	@(posedge rd_clk_i);
	rd_en_i=0;
end
endtask


endmodule
