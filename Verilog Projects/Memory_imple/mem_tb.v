//--> Implementation of Memory test bench:-

`include "memory.v"

module top;
//--> Paramters declaration:-
	parameter DEPTH=16;
	parameter WIDTH=08; 
	parameter ADDR_WIDTH=$clog2(DEPTH);

	reg clk_i,rst_i,wr_rd_i,valid_i; 
	reg [ADDR_WIDTH-1:0] addr_i; 
	reg [WIDTH-1:0] wdata_i; 
	wire [WIDTH-1:0] rdata_o; 
	wire ready_o;

	integer i;
	reg [25*8:0] testname;
//--> DUT Instance:-
	memory #(.DEPTH(DEPTH),.WIDTH(WIDTH)) dut(
								.clk_i		(clk_i),
								.rst_i		(rst_i),
								.wr_rd_i	(wr_rd_i),
								.addr_i		(addr_i),
								.wdata_i	(wdata_i),
								.rdata_o	(rdata_o),
								.valid_i	(valid_i),
								.ready_o	(ready_o));

//--> Clock generation:-
	initial begin
		clk_i=0;
		forever #5 clk_i=~clk_i;
	end

//--> Calling the tasks:-
	initial begin
		reset();
		$value$plusargs("testname=%0s",testname);//--> we can pass the arguments from commandline argument/run.do
		$display("=================================================");
		$display("Passing Testcase:- %0s",testname);
		$display("=================================================");
		case(testname)
			"test_quater_wr_rd":begin
				write_mem('d0,DEPTH/4);
				read_mem('d0,DEPTH/4);
			end
			"test_half_wr_rd":begin
				write_mem('d0,DEPTH/2);
				read_mem('d0,DEPTH/2);
			end
			"test_3/4_wr_rd":begin
				write_mem('d0,3*DEPTH/4);
				read_mem('d0,3*DEPTH/4);
			end
			"test_full_wr_rd":begin
				write_mem(0,DEPTH);
				read_mem(0,DEPTH);
			end
			"test_parti_wr_rd":begin
				write_mem('d14,'d15);
				read_mem('d14,'d15);
			end
//---------------------------------------------------
			"test_bd_wr_bd_rd":begin
				bd_wr(0,DEPTH-1);
				bd_rd(0,DEPTH-1);
			end
			"test_bd_wr_fd_rd":begin
				bd_wr(0,DEPTH-1);
				read_mem(0,DEPTH-1);
			end
			"test_fd_wr_bd_rd":begin
				write_mem(0,DEPTH-1);
				bd_rd(0,DEPTH-1);
			end
			"test_fd_wr_fd_rd":begin
				write_mem(0,DEPTH-1);
				read_mem(0,DEPTH-1);
			end
		endcase
		#100;
		$finish();
	end

//--> Reset Task:-
	task reset();
		begin
			rst_i=1; //--> appling the reset
			wr_rd_i=0; //--> all reg variables in the tb make it as a "0"
			addr_i=0;
			wdata_i=0;
			valid_i=0;
			repeat(2)@(posedge clk_i); //--> waiting for the 2 +ve edges of the clk
			rst_i=0; //--> relesaing the reset
		end
	endtask

//--> back_door acces:-(write & read)

	task bd_wr(input integer srt_loc, input integer end_loc);
		begin
			$readmemh("praveen.hex",dut.mem,srt_loc,end_loc);
		end
	endtask

	task bd_rd(input integer srt_loc, input integer end_loc);
		begin
			$writememb("praveen.bin",dut.mem,srt_loc,end_loc);
		end
	endtask

//--> Write_task:-
	task write_mem(input integer strt_addr, end_addr);
		begin
			for(i=strt_addr; i<end_addr; i=i+1)begin
				@(posedge clk_i);
				valid_i=1;
				wr_rd_i=1;
				addr_i=i; //-> 0,1,2...F
				wdata_i=$random; //-> 122, 55, 25, ....150
				wait(ready_o==1);
				if(testname=="test_wr_rd")$display("\t--> Write_data [%0d]:- %0d",i,wdata_i);
			end
			$display("-------------------------------------------");
				@(posedge clk_i);
				valid_i=0;
				wr_rd_i=0;
				addr_i=0;
				wdata_i=0;
		end
	endtask

//--> Read_task:-
	task read_mem(input integer strt_addr,end_addr);
		begin
			for(i=strt_addr; i<end_addr; i=i+1)begin
				@(posedge clk_i);
				valid_i=1;
				wr_rd_i=0;
				addr_i=i;
				wait(ready_o==1);
			if(testname=="test_wr_rd")$display("\t--> Read_data [%0d]:- %0d",i,rdata_o);
			end
				@(posedge clk_i);
				valid_i=0;
				wr_rd_i=0;
				addr_i=0;
		end
	endtask
endmodule
