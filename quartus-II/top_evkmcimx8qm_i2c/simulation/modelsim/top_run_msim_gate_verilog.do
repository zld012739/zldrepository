transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {top.vo}

vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_evkmcimx8qm_i2c/test_bench_i2c.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L maxii_ver -L gate_work -L work -voptargs="+acc"  test_i2c_slave

add wave *
view structure
view signals
run -all
