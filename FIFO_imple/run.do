vlib work
vlog fifo_tb.v
vsim top +testcase=concurrent
add wave -position insertpoint sim:/top/dut/*
run -all
