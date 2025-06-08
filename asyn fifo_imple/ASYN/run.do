vlib work
vlog asyn_fifo_tb.v
vsim tb +testcase=CONCURRENT
add wave -position insertpoint sim:/tb/dut/*
run -all
