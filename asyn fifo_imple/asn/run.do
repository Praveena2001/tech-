vlib work
vlog asyn_fifo_tb.v
vsim top
#vsim top +testcase=concurrent
add wave -position insertpoint sim:/top/dut/*
run -all
