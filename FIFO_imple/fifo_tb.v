`include "fifo_dn.v"
module top;

//parameter decleration
parameter DEPTH=16;
parameter WIDTH=8;
parameter PNT_WIDTH=$clog2(DEPTH);

//port declaration
reg clk_i,rst_i,wr_en_i,rd_en_i;
reg[WIDTH-1:0] wdata_i;
wire[WIDTH-1:0] rdata_o;
wire full_o,overflow_o,empty_o,underflow_o;

reg[20*8-1:0]testcase;// passing testcase
initial begin
$value$plusargs("testcase=%0s",testcase);
end
integer i,j,k,wr_delay,rd_delay;

//institation
syn_fifo dut (clk_i,rst_i,wr_en_i,rd_en_i,wdata_i,rdata_o,full_o,overflow_o,empty_o,underflow_o);

always #5 clk_i=~clk_i;

initial begin
 clk_i=0;
 rst_i=1;//make all the input reg  will be 0 
 reset();// calling the reset task
 repeat (4) @(posedge clk_i);
 rst_i=0;
 //write(DEPTH);//calling write
//read(DEPTH);// calling read


case(testcase)
"5WR_5RD":begin
 write(5);
 read(5);
end
"full":begin
write(DEPTH);
end
"overflow":begin
write(DEPTH);
end
"empty":begin
write(DEPTH);
read(DEPTH+1);
end
"underflow":begin
write(DEPTH);
read(DEPTH);
end
"concurrent":begin
fork
begin
		for(j=0;j<20;j=j+1)begin
		write(1);
		wr_delay=$urandom_range(5,15);
		#(wr_delay);
	end
	end
begin
	for(k=0;k<20;k=k+1)begin
		read(1);
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
// reset operation
task reset();
begin
 wr_en_i=0;
 rd_en_i=0;
 wdata_i=0;
end
endtask


//write task
task write(input integer num_write);begin
	for(i=0;i<num_write;i=i+1) begin
		@(posedge clk_i);
		wr_en_i=1;
		wdata_i=$urandom_range(100,200);
		end
		@(posedge clk_i);
		wr_en_i=0;
		wdata_i=0;
end
endtask
task read(input integer num_write);begin
	for(i=0;i<num_write;i=i+1) begin
		@(posedge clk_i);
		rd_en_i=1;

	end
		@(posedge clk_i);
		rd_en_i=0;
	end
endtask
endmodule

 

