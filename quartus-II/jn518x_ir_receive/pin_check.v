`timescale	1ns/1ps
//**********************************************************************
// File: check_pin.v
// Module:check_pin
// by Robin zhang 
//**********************************************************************
module check_pin(
clk,rst_n,tx_start,capture_ready,tx_data,tx_complete,bps_start_t,receive_status,capture_rst,ir_recieved_data
);

input clk;
input rst_n;
input capture_ready;
input tx_complete;
input bps_start_t;
input receive_status;
input capture_rst;
input [10:0] ir_recieved_data;

output tx_start;
output [7:0] tx_data;

reg tx_start;
reg[15:0] tx_counter;
reg[3:0] tx_count;
reg[7:0] tx_data;
reg tx_end;
reg end_ready;


always @ (posedge clk or negedge rst_n) begin

	if (!rst_n)begin
		tx_start <= 1'b1;
      tx_data <= 'hzz;
	end
	else if(capture_ready && (tx_counter >'d600) && receive_status && end_ready)begin
	   case(tx_count)
			4'b0000:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= ir_recieved_data[7:0];
			end
			4'b0001:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= {5'h0,ir_recieved_data[10:8]};
			end
//			4'b0000:begin
//				tx_start <= tx_start ? 1'b0:1'b1;
//				tx_data <= 8'd105;
//			end
//			4'b0001:begin
//				tx_start <= tx_start ? 1'b0:1'b1;
//				tx_data <= 8'd114;
//			end
//			4'b0010:begin
//				tx_start <= tx_start ? 1'b0:1'b1;
//				tx_data <= 8'd95;
//			end
//			4'b0011:begin
//				tx_start <= tx_start ? 1'b0:1'b1;
//				tx_data <= 8'd112;
//			end
//			4'b0100:begin
//				tx_start <= tx_start ? 1'b0:1'b1;
//				tx_data <= 8'd97;
//			end
//			4'b0101:begin
//				tx_start <= tx_start ? 1'b0:1'b1;
//				tx_data <= 8'd115;
//			end
//			4'b0110:begin
//				tx_start <= tx_start ? 1'b0:1'b1;
//				tx_data <= 8'd115;
//			end
//			4'b0111:begin
//				tx_start <= tx_start ? 1'b0:1'b1;
//				tx_data <= 8'h8;
//			end
			default:begin
				tx_start <= 1'b1;
				tx_data <= 8'hzz;
			end
		endcase
	end
	else if(capture_ready && (tx_counter >'d600) && (receive_status == 1'b0) && end_ready)begin
	   case(tx_count)
			4'b0000:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= 8'd102;
			end
			4'b0001:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= 8'd97;
			end
			4'b0010:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= 8'd105;
			end
			4'b0011:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= 8'd108;
			end
			4'b0100:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= 8'd7;
			end
			4'b0101:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= 8'd8;
			end
			4'b0110:begin
				tx_start <= tx_start ? 1'b0:1'b1;
				tx_data <= 8'd9;
			end
//			4'b0111:begin
//				tx_start <= tx_start ? 1'b0:1'b1;
//				tx_data <= 8'd0;
//			end
			default:begin
				tx_start <= 1'b1;
				tx_data <= 'hzz;
			end
		endcase
	end

end 

always @ (posedge tx_complete or negedge capture_rst) begin

	if (!capture_rst)begin
		tx_count <= 'h0;
		tx_end <= 'h0;
	end
//	else if(tx_complete && (tx_count<6)&&capture_ready)begin
	else if(tx_complete && (tx_count<1)&&capture_ready)begin
		tx_count <= tx_count + 1'b1;
	end
	else begin
		tx_end <= 'h1;
		end
end

always @(posedge clk or negedge rst_n)begin
   if(!rst_n)
	end_ready <= 1'b0;
	else 		
	end_ready <= tx_end ? 1'b0 : 1'b1;
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