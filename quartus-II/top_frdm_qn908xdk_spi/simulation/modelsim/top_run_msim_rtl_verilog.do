transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi/top.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi/spi_ctrl.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi/spi_master.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi/spi_slave_cpha0.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi/speed_select.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi/uart_rx.v}
vlog -vlog01compat -work work +incdir+D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi {D:/projects/07_source_code/auto_tools/mcu_cpld_prd/Auto_Generator/pycpld/quartus-II/top_frdm_qn908xdk_spi/uart_tx.v}

