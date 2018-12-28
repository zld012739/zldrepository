/*
 Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
 Your use of Altera Corporation's design tools, logic functions 
 and other software and tools, and its AMPP partner logic 
 functions, and any output files from any of the foregoing 
 (including device programming or simulation files), and any 
 associated documentation or information are expressly subject 
 to the terms and conditions of the Altera Program License 
 Subscription Agreement, the Altera Quartus Prime License Agreement,
 the Altera MegaCore Function License Agreement, or other 
 applicable license agreement, including, without limitation, 
 that your use is for the sole purpose of programming logic 
 devices manufactured by Altera and sold by Altera or its 
 authorized distributors.  Please refer to the applicable 
 agreement for further details.
*/
MODEL
/*MODEL HEADER*/
/*
 This file contains Slow Corner delays for the design using part EPM570T100C5
 with speed grade 5, core voltage Auto, and temperature 2147483647 Celsius

*/
MODEL_VERSION "1.0";
DESIGN "top";
DATE "07/10/2017 15:13:40";
PROGRAM "Quartus Prime";



INOUT BusA[83];
INOUT BusA[82];
INOUT BusA[84];
INPUT clk;
INPUT rst_n;
INPUT rs232_rx;
OUTPUT led;

/*Arc definitions start here*/
pos_BusA[84]__I2C_MASTER:I2C_MASTER_instance|scl_clk__setup:		SETUP (POSEDGE) BusA[84] I2C_MASTER:I2C_MASTER_instance|scl_clk ;
pos_BusA[82]__clk__setup:		SETUP (POSEDGE) BusA[82] clk ;
pos_BusA[84]__clk__setup:		SETUP (POSEDGE) BusA[84] clk ;
pos_rst_n__clk__setup:		SETUP (POSEDGE) rst_n clk ;
pos_rs232_rx__speed_select:speed_select|buad_clk_rx_reg__setup:		SETUP (POSEDGE) rs232_rx speed_select:speed_select|buad_clk_rx_reg ;
pos_BusA[84]__I2C_MASTER:I2C_MASTER_instance|scl_clk__hold:		HOLD (POSEDGE) BusA[84] I2C_MASTER:I2C_MASTER_instance|scl_clk ;
pos_BusA[82]__clk__hold:		HOLD (POSEDGE) BusA[82] clk ;
pos_BusA[84]__clk__hold:		HOLD (POSEDGE) BusA[84] clk ;
pos_rst_n__clk__hold:		HOLD (POSEDGE) rst_n clk ;
pos_rs232_rx__speed_select:speed_select|buad_clk_rx_reg__hold:		HOLD (POSEDGE) rs232_rx speed_select:speed_select|buad_clk_rx_reg ;
pos_I2C_MASTER:I2C_MASTER_instance|scl_clk__BusA[82]__delay:		DELAY (POSEDGE) I2C_MASTER:I2C_MASTER_instance|scl_clk BusA[82] ;
pos_I2C_MASTER:I2C_MASTER_instance|scl_clk__BusA[84]__delay:		DELAY (POSEDGE) I2C_MASTER:I2C_MASTER_instance|scl_clk BusA[84] ;
pos_clk__BusA[82]__delay:		DELAY (POSEDGE) clk BusA[82] ;
pos_clk__BusA[84]__delay:		DELAY (POSEDGE) clk BusA[84] ;
pos_clk__led__delay:		DELAY (POSEDGE) clk led ;

ENDMODEL
