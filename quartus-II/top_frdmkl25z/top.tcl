# Copyright (C) 1991-2014 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, the Altera Quartus II License Agreement,
# the Altera MegaCore Function License Agreement, or other 
# applicable license agreement, including, without limitation, 
# that your use is for the sole purpose of programming logic 
# devices manufactured by Altera and sold by Altera or its 
# authorized distributors.  Please refer to the applicable 
# agreement for further details.

# Quartus II: Generate Tcl File for Project
# File: my_uart_top.tcl
# Generated on: Thu Jan 29 13:04:19 2015

# Load Quartus II Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "top"]} {
		puts "Project top is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists top]} {
		project_open -revision top top
	} else {
		project_new -revision top top
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	#project properties
	set_global_assignment -name FAMILY "MAX II"
	set_global_assignment -name DEVICE EPM570T100C5
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION "9.0 SP2"
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "20:55:40  SEPTEMBER 02, 2013"
	set_global_assignment -name LAST_QUARTUS_VERSION 14.0
	set_global_assignment -name USE_GENERATED_PHYSICAL_CONSTRAINTS OFF -section_id eda_blast_fpga
	set_global_assignment -name DEVICE_FILTER_PIN_COUNT 100
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name POWER_EXT_SUPPLY_VOLTAGE_TO_REGULATOR 3.3V
	set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"
	set_global_assignment -name AUTO_RESTART_CONFIGURATION OFF
	set_global_assignment -name USE_CONFIGURATION_DEVICE ON
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS_NO_OUTPUT_GND "AS INPUT TRI-STATED"
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "NO HEAT SINK WITH STILL AIR"
	set_global_assignment -name VERILOG_FILE top.v
	set_global_assignment -name VERILOG_FILE speed_select.v
set_global_assignment -name VERILOG_FILE uart_rx.v
set_global_assignment -name VERILOG_FILE uart_tx.v

	set_global_assignment -name SIGNALTAP_FILE stp1.stp
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name LL_ROOT_REGION ON -section_id "Root Region"
	set_global_assignment -name LL_MEMBER_STATE LOCKED -section_id "Root Region"

	#default configurations
	set_location_assignment PIN_12 -to clk
	set_location_assignment PIN_52 -to rst_n
	set_location_assignment PIN_6 -to rs232_rx
	set_location_assignment PIN_1 -to led

	######################
	#pin assignments part
	
	set_location_assignment PIN_3 -to BusA[3]
set_location_assignment PIN_8 -to BusA[8]
set_location_assignment PIN_3 -to BusA[3]
set_location_assignment PIN_15 -to BusA[15]
set_location_assignment PIN_16 -to BusA[16]
set_location_assignment PIN_89 -to BusE[89]
set_location_assignment PIN_21 -to BusA[21]
set_location_assignment PIN_68 -to BusD[68]
set_location_assignment PIN_20 -to BusA[20]
set_location_assignment PIN_66 -to BusD[66]
set_location_assignment PIN_56 -to BusC[56]
set_location_assignment PIN_19 -to BusA[19]
set_location_assignment PIN_18 -to BusA[18]
set_location_assignment PIN_70 -to BusD[70]
set_location_assignment PIN_83 -to BusE[83]
set_location_assignment PIN_16 -to BusA[16]
set_location_assignment PIN_3 -to BusA[3]
set_location_assignment PIN_8 -to BusA[8]
set_location_assignment PIN_3 -to BusA[3]
set_location_assignment PIN_15 -to BusA[15]
set_location_assignment PIN_3 -to BusA[3]
set_location_assignment PIN_8 -to BusA[8]
set_location_assignment PIN_3 -to BusA[3]
set_location_assignment PIN_15 -to BusA[15]
set_location_assignment PIN_3 -to BusA[3]
set_location_assignment PIN_8 -to BusA[8]
set_location_assignment PIN_3 -to BusA[3]
set_location_assignment PIN_15 -to BusA[15]
set_location_assignment PIN_70 -to BusD[70]
set_location_assignment PIN_56 -to BusC[56]
set_location_assignment PIN_68 -to BusD[68]
set_location_assignment PIN_81 -to BusE[81]
set_location_assignment PIN_66 -to BusD[66]
set_location_assignment PIN_64 -to BusD[64]
set_location_assignment PIN_99 -to BusE[99]
set_location_assignment PIN_56 -to BusC[56]
set_location_assignment PIN_70 -to BusD[70]
set_location_assignment PIN_97 -to BusE[97]
set_location_assignment PIN_4 -to BusA[4]
set_location_assignment PIN_8 -to BusA[8]
set_location_assignment PIN_4 -to BusA[4]
set_location_assignment PIN_15 -to BusA[15]
set_location_assignment PIN_66 -to BusD[66]
set_location_assignment PIN_20 -to BusA[20]
set_location_assignment PIN_18 -to BusA[18]
set_location_assignment PIN_56 -to BusC[56]
set_location_assignment PIN_70 -to BusD[70]
set_location_assignment PIN_19 -to BusA[19]
set_location_assignment PIN_68 -to BusD[68]
set_location_assignment PIN_21 -to BusA[21]
set_location_assignment PIN_16 -to BusA[16]
set_location_assignment PIN_83 -to BusE[83]
set_location_assignment PIN_4 -to BusA[4]
set_location_assignment PIN_8 -to BusA[8]
set_location_assignment PIN_4 -to BusA[4]
set_location_assignment PIN_15 -to BusA[15]
set_location_assignment PIN_4 -to BusA[4]
set_location_assignment PIN_17 -to BusA[17]
set_location_assignment PIN_16 -to BusA[16]
set_location_assignment PIN_70 -to BusD[70]
set_location_assignment PIN_91 -to BusE[91]
set_location_assignment PIN_17 -to BusA[17]
set_location_assignment PIN_4 -to BusA[4]
set_location_assignment PIN_8 -to BusA[8]
set_location_assignment PIN_4 -to BusA[4]
set_location_assignment PIN_15 -to BusA[15]
set_location_assignment PIN_16 -to BusA[16]
set_location_assignment PIN_40 -to BusB[40]


	
	######################
	
	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
