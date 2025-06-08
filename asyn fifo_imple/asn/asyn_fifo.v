module asyn(wr_clk_i,rd_clk_i,rst_i,wr_en_i,rd_en_i,wdata_i,rdata_o,full_o,overflow_o,empty_o,underflow_o);

//parameter
parameter DEPTH=16;
parameter WIDTH=8;
parameter PNT_WIDTH=$clog2(DEPTH);

//port dec
input wr_clk_i,rd_clk_i,rst_i,wr_en_i,rd_en_i;
input[WIDTH-1:0]wdata_i;
output reg[WIDTH-1:0]rdata_o;
output reg full_o,overflow_o,empty_o,underflow_o;

reg[PNT_WIDTH-1:0] wr_pnt,rd_pnt,wr_pnt_rd_clk,rd_pnt_wr_clk;
reg[WIDTH-1:0]fifo[DEPTH-1:0];
reg wr_toggle,rd_toggle,wr_toggle_rd_clk,rd_toggle_wr_clk;
integer i;
always@(posedge wr_clk_i)begin
	if(rst_i==1)begin
	rdata_o=0;
	full_o=0;
	overflow_o=0;
	empty_o=1;
	underflow_o=0;
    wr_pnt=0;
   rd_pnt=0;
   wr_toggle=0;
   rd_toggle=0;

//write 
  for(i=0;i<DEPTH;i=i+1)
  	fifo[i]=0;
	end
	else begin
		if(wr_en_i==1)begin
		if(full_o==1)begin
		 overflow_o=1;
		 end
		 else begin
		 	fifo[wr_pnt]=wdata_i;
			if(wr_pnt==DEPTH-1)begin
			wr_toggle=~wr_toggle;
			wr_pnt=0;
			end
			else begin
			wr_pnt=wr_pnt+1;
			end
		end
	end
end
always @(posedge rd_clk_i)begin
		if (rst_i==0)begin
		if(rd_en_i==1)begin
		if(empty_o==1)begin
		 underflow_o=1;
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

always @(posedge wr_clk_i)begin
rd_pnt_wr_clk<=rd_pnt;
rd_toggle_wr_clk<=rd_toggle;
end
always@(posedge rd_clk_i)begin
wr_pnt_rd_clk<=wr_pnt;
wr_toggle_rd_clk<=wr_toggle;
end

//condition
always@(*)begin
if (rd_pnt==wr_pnt_rd_clk && rd_toggle==wr_toggle_rd_clk) empty_o=1;
else empty_o=0;

if(wr_pnt==rd_pnt_wr_clk && wr_toggle!=rd_toggle_wr_clk) full_o=1;
else full_o=0;
end 
endmodule










