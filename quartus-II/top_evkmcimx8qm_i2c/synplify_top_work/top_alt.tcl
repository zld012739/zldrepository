project -new
add_file -verilog {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c/top.v}
add_file -verilog {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c/I2C_MASTER.v}
add_file -verilog {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c/I2C_wr.v}
add_file -verilog {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c/i2c_slave.v}
add_file -verilog {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c/i2c_slave_op.v}
add_file -verilog {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c/speed_select.v}
add_file -verilog {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c/uart_rx.v}
add_file -verilog {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c/uart_tx.v}
add_file -verilog {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c/test_bench_i2c.v}
add_file -constraint {top.sdc}
set_option -top_module top
set_option -technology 
set_option -part 
set_option -package 
set_option -write_verilog 0
set_option -write_vhdl 0
set_option -write_vif 0
set_option -write_apr_constraint 0
project -result_file ./top.vqm
project -log_file ./top.srr
set_option -frequency auto
project -run
project -save top.prj
