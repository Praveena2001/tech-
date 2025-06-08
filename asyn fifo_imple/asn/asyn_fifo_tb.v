`include "asyn_fifo.v"
module top; 
//parameter
parameter DEPTH=16;
parameter WIDTH=8;
parameter PNT_WIDTH=$clog2(DEPTH);

//port dec
reg wr_clk_i,rd_clk_i,rst_i,wr_en_i,rd_en_i;
reg[WIDTH-1:0]wdata_i;
wire[WIDTH-1:0]rdata_o;
wire full_o,overflow_o,empty_o,underflow_o;

reg[PNT_WIDTH-1:0] wr_pnt,rd_pnt,wr_pnt_rd_clk,rd_pnt_wr_clk;
reg[WIDTH-1:0]fifo[DEPTH-1:0];
reg wr_toggle,rd_toggle,wr_toggle_rd_clk,rd_toggle_wr_clk;



//instatition

 asyn_fifo dut (wr_clk_i,rd_clk_i,rst_i,wr_en_i,rd_en_i,wdata_i,rdata_o,full_o,overflow_o,empty_o,underflow_o);

 //clock generation
always #5 wr_clk_i=~wr_clk_i;
always #7 rd_clk_i=~rd_clk_i;
integer i;
initial begin
	rst_i=1;
	wr_clk_i=0;
	rd_clk_i=0;
	repeat (2) @(posedge wr_clk_i);
	rst_i=0;

	reset();
	write(5);
	read(5);
	#100;
	$finish;
end
task reset();begin
	wr_en_i=0;
	rd_en_i=0;
	wdata_i=0;
end

//write task
task write(input integer num_write);begin
	@(posedge wr_clk_i);
	for (i=0;i<num_write;i=i+1)begin
		wr_en_i=1;
		wdata_i=$urandom_range(100,200);
	end
	@(posedge wr_clk_i);
	wr_en_i=0;
	wdata_i=0;
end
endtask

//read task
task read(input integer num_write);begin
	@(posedge rd_clk_i);
	for(i=0;i<num_write;i=i+1)begin
	 rd_en_i=1;
	 end
	 @(posedge rd_clk_i);
	 rd_en_i=0;
	 end
endtask
endmodule
