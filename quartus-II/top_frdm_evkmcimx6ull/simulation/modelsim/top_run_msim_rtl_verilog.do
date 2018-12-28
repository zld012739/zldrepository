transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull/top.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull/spi_ctrl.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull/spi_master.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull/spi_slave_cpha0.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull/spi_slave_b2b.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull/pwm_out.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull/speed_select.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull/uart_rx.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_evkmcimx6ull/uart_tx.v}

