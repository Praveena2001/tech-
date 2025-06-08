onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/dut/clk_i
add wave -noupdate /top/dut/rst_i
add wave -noupdate /top/dut/wr_en_i
add wave -noupdate /top/dut/rd_en_i
add wave -noupdate -radix unsigned /top/dut/wdata_i
add wave -noupdate -radix unsigned /top/dut/rdata_o
add wave -noupdate /top/dut/full_o
add wave -noupdate /top/dut/overflow_o
add wave -noupdate /top/dut/empty_o
add wave -noupdate /top/dut/underflow_o
add wave -noupdate -radix unsigned /top/dut/wr_pnt
add wave -noupdate -radix unsigned /top/dut/rd_pnt
add wave -noupdate /top/dut/wr_toggle
add wave -noupdate /top/dut/rd_toggle
add wave -noupdate /top/dut/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 91
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 1
configure wave -timelineunits ns
update
WaveRestoreZoom {85 ps} {335 ps}
