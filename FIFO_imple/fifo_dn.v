//implement synchronous  fifo
module syn_fifo(clk_i,rst_i,wr_en_i,rd_en_i,wdata_i,rdata_o,full_o,overflow_o,empty_o,underflow_o);

//parameter decleration
parameter DEPTH=16;
parameter WIDTH=8;
parameter PNT_WIDTH=$clog2(DEPTH);

//port declaration
input clk_i,rst_i,wr_en_i,rd_en_i;
input[WIDTH-1:0] wdata_i;
output reg[WIDTH-1:0] rdata_o;
output reg full_o,overflow_o,empty_o,underflow_o;

//reg decl storing element

reg[PNT_WIDTH-1:0] wr_pnt,rd_pnt;

//fifo dec
reg[WIDTH-1:0] fifo[DEPTH-1:0];
reg wr_toggle,rd_toggle;
integer i;

//reset operation
always@(posedge clk_i) begin
	if (rst_i==1)begin// if rst =1 means all the reg o/p will be '0'
		rdata_o=0;
		full_o=0;
		overflow_o=0;
		empty_o=1;
		underflow_o=0;
		wr_pnt=0;
		rd_pnt=0;
		wr_toggle=0;
		rd_toggle=0;
// we can't able to make it '0'
		for(i=0;i<DEPTH;i=i+1)
			fifo[i]=0;

		end

		else begin
			if(wr_en_i==1)begin
				if(full_o==1)begin
				overflow_o=1;
				end
// its full means we need check wdata ,its not full means we do below condtion,
// when ever we reach the point i want to check its full or not
				else begin
					fifo[wr_pnt]=wdata_i;
					if(wr_pnt==DEPTH-1)begin// we don't know which location its perform ,when its last location means we need to below condition ,its full /once reach the depth its tells im full after its toggle 0 to 1,
						wr_toggle=~wr_toggle;
						wr_pnt=0;
					end
					else

// if its not last location means we need to increament the point
					wr_pnt=wr_pnt+1;
				end
			end

			if(rd_en_i==1)begin
				if(empty_o==1)begin
				underflow_o=1;
				end
				else begin
				rdata_o=fifo[rd_pnt];
				if(rd_pnt==DEPTH-1)begin
				rd_toggle=~rd_toggle;
				rd_pnt=0;
				end
				else
				rd_pnt=rd_pnt+1;
			end
		end
	end
end
//check empty full condition
always@(*) begin
if(wr_pnt==rd_pnt && wr_toggle==rd_toggle)
empty_o=1;
else
empty_o=0;
if(wr_pnt==rd_pnt && wr_toggle!=rd_toggle)
full_o=1;
else
full_o=0;
end
endmodule







