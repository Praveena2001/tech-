vlib work
vlog mem_tb.v
vsim top +testname=test_fr_wr_bd_rd
#add wave -position insertpoint sim:/top/dut/*
do wave.do
run -all
