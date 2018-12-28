transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c/i2c_slave.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c/i2c_slave_op.v}

vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c/test_i2c_slave.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L maxii_ver -L rtl_work -L work -voptargs="+acc"  test_i2c_slave

add wave *
view structure
view signals
run -all
