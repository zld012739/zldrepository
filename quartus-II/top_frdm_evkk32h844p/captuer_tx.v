`timescale 1ns/1ps
/***************************************************************************
Name:
Date: 7/11/2016
Founction: Send out capture value
Note:
****************************************************************************/
module captuer_tx( 
clk,rst_n,tx_start,capture_ready,periodcounter,dutycyclecounter,tx_data,tx_complete,capture_tx_rst,tx_end,bps_start_t
);

input clk;
input rst_n;
input capture_ready;
input tx_complete;
input bps_start_t;
input capture_tx_rst;
input[31:0] periodcounter;
input[31:0] dutycyclecounter;

output tx_start;
output tx_end;
output [7:0] tx_data;

reg tx_start;
reg[15:0] tx_counter;
reg[3:0] tx_count;
reg[7:0] tx_data;
reg tx_end;

reg convert_finish;
/*
reg [7:0] t0;
reg [7:0] t1;
reg [7:0] t2;
reg [7:0] t3;
reg [7:0] t4;
reg [7:0] t5;
reg [7:0] t6;
*/
 


always @ (posedge clk or negedge rst_n) begin

  if (!rst_n)begin
	convert_finish = 1'b0;
	t0 = 8'b0;
	t1 = 8'b0;
	t2 = 8'b0;
	t3 = 8'b0;
	t4 = 8'b0;
	t5 = 8'b0;
	t6 = 8'b0;
  end
  else if(capture_ready && (tx_counter >'d600)) begin
	 //maxinum number is 9M
/*
	 t6 = (periodcounter/32'd1000000) % 32'd10;
	 t5 = (periodcounter/32'd100000) % 32'd10;
    t4 = (periodcounter/32'd10000) % 32'd10;
    t3 = (periodcounter/32'd1000) % 32'd10;
    t2 = (periodcounter/32'd100) % 32'd10;
    t1 = (periodcounter/32'd10) % 32'd10;
    t0 = periodcounter % 32'd10;
*/
	 convert_finish = 1'b1;
  end
end

always @ (posedge clk or negedge rst_n) begin

	if (!rst_n)begin
		tx_start <= 1'b1;
        tx_data <= 'hzz;
	end
	else if(capture_ready && (tx_counter >'d600))begin
	   case(tx_count)
			4'b0000:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= "C";
			end
			4'b0001:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= "0" + t0;
			end
			4'b0010:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= "0" + t1;
			end
			4'b0011:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= "0" + t2;
			end
			4'b0100:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= "0" + t3;
			end
			4'b0101:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= "0" + t4;
			end
			4'b0110:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= "0" + t5;
			end
			4'b0111:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= "0" + t6;
			end
			default:begin
				tx_start <= 1'b1;
				tx_data <= 'hzz;
			end
		endcase
	end

end 

always @ (posedge tx_complete or negedge capture_tx_rst) begin

	if (!capture_tx_rst)begin
		tx_count <= 'h0;
		tx_end <= 'h0;
	end
	else if(tx_complete && (tx_count<7)&&capture_ready)begin
		tx_count <= tx_count + 1'b1;
	end
	else begin
		tx_end <= 'h1;
		end
end

always @ (posedge clk or negedge rst_n) begin

	if (!rst_n)begin
		tx_counter <= 'h0;
	end
	else if(!bps_start_t)begin
		tx_counter <= tx_counter + 1'b1;
	end
	else begin
		tx_counter <= 'h0;
		end
end

endmodule 