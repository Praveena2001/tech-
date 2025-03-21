//--> Implementation of Memory Design File:-

module memory(clk_i,rst_i,wr_rd_i,addr_i,wdata_i,rdata_o,valid_i,ready_o);
//--> Paramters declaration:-
	parameter DEPTH=16; //--> 32 
	parameter WIDTH=08; 
	parameter ADDR_WIDTH=$clog2(DEPTH);//--> 5 

//--> Declare the input & output signals:-4
	input clk_i,rst_i,wr_rd_i,valid_i; //--> scalar signals
	input [ADDR_WIDTH-1:0] addr_i; //--> 0 - 15 ( 00000 -- 1111 -F)
	input [WIDTH-1:0] wdata_i; //--> write data(writing into the memory)
	output reg [WIDTH-1:0] rdata_o; //--> read data(Reading from the memory)
	output reg ready_o;

//--> Declaration of memory/memory allocation:-
	reg [WIDTH-1:0] mem [DEPTH-1:0];
	integer i;
	
//--> logic:-
	always@(posedge clk_i)begin
		if(rst_i==1)begin
			rdata_o=0;
			ready_o=0;
			for(i=0; i<DEPTH; i=i+1) mem[i]=0;//--> for an array i cant able to decl 0 as directly, so for that purpose 
				// im using the for loop. 0-15 locations it will make it as a "0"
		end
		else begin
			if(valid_i==1)begin
				ready_o=1;
				if(wr_rd_i == 1) mem[addr_i] = wdata_i;//--> write the data into the memory
				else rdata_o = mem[addr_i]; //--> Read the data from Memory
			end
			else ready_o=0;
		end
	end
endmodule
