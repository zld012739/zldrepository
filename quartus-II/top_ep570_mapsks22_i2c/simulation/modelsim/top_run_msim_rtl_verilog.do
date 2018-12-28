transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c/top.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c/I2C_MASTER.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c/I2C_wr.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c/i2c_slave.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c/i2c_slave_op.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c/speed_select.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c/uart_rx.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_ep570_mapsks22_i2c/uart_tx.v}

