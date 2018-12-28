`timescale 1ns/1ps
/***************************************************************************
Name:
Date: 7/18/2016
Founction: I2C top module
Note:
****************************************************************************/
module I2C_MASTER(clk,rst_n,sda,scl,RD_EN,WR_EN,receive_status

);

input clk;
input rst_n;
input RD_EN;
input WR_EN;
reg WR,RD;


output scl;
output receive_status;

inout sda;

reg scl_clk;
reg receive_status;
reg[9:0] clk_div;
reg[7:0] send_count;
wire[7:0] data;

reg[7:0] data_reg;

wire ack;

reg[7:0] send_memory;
reg[7:0] receive_memory[31:0];

always @(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		scl_clk <= 1'b0;
		clk_div <= 'h0;
		send_memory <= 8'd0;
		end
	else begin 
	   if(clk_div > 'd400)begin
				scl_clk <= ~scl_clk;
				clk_div <= 'h0;
				end
	   else
		clk_div <= clk_div + 1'b1;
		end
	
end

always @(posedge ack or negedge rst_n)begin
	if(!rst_n)begin
		send_count <= 'h0;
	end
	else begin
		if((send_count < 10'd32) && (ack))begin
			send_count <= send_count + 1'b1;
			receive_memory[send_count] <= RD_EN ? data : 8'h0;
			end	
		else begin
			send_count <= send_count;
			end
		end	
end

always @(posedge clk or negedge rst_n)begin
   if(!rst_n)
	receive_status <= 1'b0;
	else 		
	receive_status <=(receive_memory[31]== 31) ? 1'b1 : 1'b0;
end

always @(posedge clk or negedge rst_n)begin
	if(!rst_n)begin	
		WR         <= 1'b0;
		RD         <= 1'b0;
		data_reg   <= 'h0;
	end
	else begin
	   if(send_count == 8'd32)begin
			WR         <= 1'b0;
			RD         <= 1'b0;
			end
		else begin
		if(RD_EN)
			RD         <= 1'b1;
		else if(WR_EN)begin
			WR         <= 1'b1;
			data_reg   <= send_memory + send_count;
			end
		end
	end
		
end

assign data = WR_EN ? data_reg :  8'hz;

I2C_wr I2C_wr_instance(
					.sda(sda),
					.scl(scl),
					.ack(ack),
					.rst_n(rst_n),
					.clk(scl_clk),
					.WR(WR),
					.RD(RD),
					.data(data)
);

endmodule 