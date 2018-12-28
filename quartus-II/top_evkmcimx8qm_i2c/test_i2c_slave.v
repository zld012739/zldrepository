`timescale 1ms/1us
/*
module verilog test_bench for i2c slave
*/
module test_i2c_slave();
	reg i2c_rst_slv, scl, clk; 
	
	wire in_sda;
	wire  sda;
	reg out_sda;
	reg output_value_valid;
	
	assign in_sda = sda;
	assign sda = (output_value_valid==1'b1)? out_sda : 1'bz;

	i2c_slave   i2c_slave_instance(
							.clock(clk),
							.reset_n(i2c_rst_slv),
							.scl(scl),
							.sda(sda)
							);
							

	always
		#1 clk = !clk;
		
	initial begin
	i2c_rst_slv = 0;
	output_value_valid = 1;
	out_sda = 0;
	scl = 1;
	
	end

	initial begin
	clk = 1;
	#5
	i2c_rst_slv = 1;
	#5
	i2c_rst_slv = 0;
	#5
	i2c_rst_slv = 1;
	#5
	/*simulate the 8qm issue*/
	out_sda = 0;
	//scl = 0;	
	#5
	/*simulate the 8qm issue*/
	out_sda = 1;
	//scl = 1;
   #20
	/* start condition */
	output_value_valid = 1;
	scl=1;
	out_sda=0;
	/*1st bit*/
	#20 
	scl=0;
	out_sda=1;
	#20
	scl=1;
	/*2nd bit*/
	#20
	scl=0;
	out_sda=1;
	#20
	scl=1;
	/*3rd bit*/
	#20 
	scl=0;
	out_sda=1;
	#20 
	scl=1;
	/*4th bit*/
	#20
	scl=0; 
	out_sda=1;
	#20 
	scl=1;
	/*5th bit*/
	#20 
	scl=0;
	out_sda=1;
	#20 
	scl=1;
	/*6th bit*/
	#20 
	scl=0;
	out_sda=1;
	#20 
	scl=1;
	/*7th bit*/
	#20 
	scl=0;
	out_sda=0;
	#20
	scl=1;
	/*8th bit read 0/write 1*/
	#20 
	scl=0;
	out_sda=0;
	#20 
	scl=1;
	/*ack bit*/
	#20 
	scl=0;
	/*leave control to salve*/
	output_value_valid = 0;
	#20
	scl=1;
	#20
	scl=0;
		/*take control back*/
	output_value_valid = 1;	
	end

endmodule

