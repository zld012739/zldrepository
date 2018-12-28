`timescale	1ns/1ps



/* 
 * Do not change Module name 
*/
module test_spi;

reg rst_n;
reg clock;

reg ssel;
reg mosi;
wire miso;
reg sck;
reg recived_status;

integer i;


  initial 
    begin
	   #5 sck = 0;
		ssel = 1;
		mosi= 0;
		sck = 0;
		//reset
		#5 rst_n = 1;
		#5 rst_n = 0;
		#5 rst_n = 1;
		
		#10 ssel = 0;
		
		for (i=0; i< 32; i=i+1) begin
			#5 mosi = 1;
			#5 sck=0;
			#5 sck=1;
			#5 sck=0;
			#5 mosi = 0;
		end
		
		#5 ssel = 1;
      
    end
always begin
    #2 clock = ! clock;
end

spi_slave_b2b_reduced spi_slave_b2b_reduced(
clock,sck,mosi,miso,ssel,rst_n,recived_status
);


endmodule