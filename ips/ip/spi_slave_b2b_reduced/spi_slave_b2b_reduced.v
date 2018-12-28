`timescale 1ns / 1ps

/*******************************************************************************
* Engineer: Robin zhang

* Create Date: 2016.09.10

* Module Name: spi_slave_b2b

* this module will get 64 bytes and then return the count 64 at next clks
*******************************************************************************/
module spi_slave_b2b_reduced(
clk,sck,mosi,miso,ssel,rst_n,recived_status
);

input clk;
input rst_n;
input sck,mosi,ssel;
output miso;
output recived_status;

reg recived_status;
reg sselr;

reg [7:0] byte_data_sent;
reg [7:0] last_byte_data_sent;



wire ssel_active;
wire sck_risingedge;
wire sck_fallingedge;
wire ssel_startmessage;
wire ssel_endmessage;

/*******************************************************************************
*detect the rising edge and falling edge of sck
*******************************************************************************/
reg curr, last;
always@(posedge clk)
begin
	if(!rst_n) begin
		curr <= 1'b0;
		last <= 1'b0;
	end
	else begin
    curr <= sck;
    last <= curr;
	end
end
//Raising edge
assign sck_risingedge = curr & (~last);


//failing edge
assign sck_fallingedge = ~curr & (last);


/*******************************************************************************
*detect ssel status
*******************************************************************************/
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		sselr <= 1'h1;
	else
		sselr <= ssel;
end

assign  ssel_active = (~sselr) ? 1'b1 : 1'b0;  // SSEL is active low

/*******************************************************************************
*read from mosi
*******************************************************************************/

/*******************************************************************************
*SPI slave reveive in 8-bits format
*******************************************************************************/

/*******************************************************************************
*SPI  slave send data
*******************************************************************************/
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
		byte_data_sent <= 8'h0;
		last_byte_data_sent <= 8'h0;
	 end
	 else begin
      if(ssel_active && sck_fallingedge) 
		begin
          if(last_byte_data_sent == 8'h3f)
               last_byte_data_sent <= 8'h0;
			 else if (byte_data_sent == 8'hff)
			   begin
						byte_data_sent <= last_byte_data_sent;
				 end			
			 else
               byte_data_sent <= {byte_data_sent[6:0], 1'b1};
		end
		else begin
			if(ssel_active && sck_risingedge) begin
				 if(byte_data_sent == 8'h7f)
					last_byte_data_sent <= last_byte_data_sent + 1;
		 
			end
		end
	end
end


assign miso = byte_data_sent[7];  // send MSB first


endmodule