module asyn_fifo(wr_clk_i,rd_clk_i,res_i,wr_en_i,rd_en_i,wdata_i,rdata_o,full_o,overflow_o,empty_o,underflow_o);
	parameter WIDTH=8;
	parameter DEPTH=16;
	parameter PTR_WIDTH=$clog2(DEPTH);

	input wr_clk_i,rd_clk_i,res_i,wr_en_i,rd_en_i;
	input [WIDTH-1:0]wdata_i;
	output reg [WIDTH-1:0]rdata_o;
	output reg full_o,overflow_o,empty_o,underflow_o;

	reg[PTR_WIDTH-1:0]wr_ptr,rd_ptr,wr_ptr_rd_clk,rd_ptr_wr_clk;
	reg [WIDTH-1:0]fifo[DEPTH-1:0];
	reg wr_toggle_f,rd_toggle_f,wr_toggle_f_rd_clk,rd_toggle_f_wr_clk;
	integer i;
	always @(posedge wr_clk_i) begin
		if(res_i==1) begin
			rdata_o=0;
			full_o=0;
			empty_o=1;
			overflow_o=0;
			underflow_o=0;
			wr_ptr=0;
			rd_ptr=0;
			wr_toggle_f=0;
			rd_toggle_f=0;
			for(i=0;i<DEPTH;i=i+1) fifo[i]=0;
		end
		else begin	
			if(wr_en_i==1) begin
				if(full_o==1) begin
					overflow_o=1;
				end
				else begin
					fifo[wr_ptr]=wdata_i;
					if(wr_ptr==DEPTH-1) begin
						wr_toggle_f=~wr_toggle_f;
						wr_ptr=0;
					end
					else wr_ptr=wr_ptr+1;
				end
			end
		end
	end
	
	always @(posedge rd_clk_i) begin
		if(res_i==0) begin
			if(rd_en_i==1) begin
				if(empty_o==1) underflow_o=1;
				else begin
					rdata_o=fifo[rd_ptr];
					if(rd_ptr==DEPTH-1) begin
						rd_toggle_f=~rd_toggle_f;
						rd_ptr=0;
					end
					else rd_ptr=rd_ptr+1;
				end
			end
		end
	end
	always @(posedge wr_clk_i) begin
		rd_ptr_wr_clk<=rd_ptr;
		rd_toggle_f_wr_clk<=rd_toggle_f;
	end
	always @(posedge rd_clk_i) begin
		wr_ptr_rd_clk<=wr_ptr;
		wr_toggle_f_rd_clk<=wr_toggle_f;
	end
always @(*) begin
	if(rd_ptr==wr_ptr_rd_clk && rd_toggle_f == wr_toggle_f_rd_clk) empty_o=1;
	else empty_o=0;
	if(wr_ptr==rd_ptr_wr_clk && wr_toggle_f !=rd_toggle_f_wr_clk) full_o=1;
	else full_o=0;
end
endmodule
