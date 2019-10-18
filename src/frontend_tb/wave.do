onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /frontend_tb/clk
add wave -noupdate /frontend_tb/rst_n
add wave -noupdate /frontend_tb/flush
add wave -noupdate -divider {PC gen stage}
add wave -noupdate -radix hexadecimal -radixshowbase 1 /frontend_tb/pc
add wave -noupdate -radix hexadecimal -radixshowbase 1 /frontend_tb/dut_pc_gen_stage/next_pc
add wave -noupdate -divider {Fetch stage}
add wave -noupdate /frontend_tb/dut_fetch_stage/u_fetch_unit/u_fetch_cu/present_state
add wave -noupdate /frontend_tb/fetch_ready
add wave -noupdate -radix hexadecimal -radixshowbase 1 /frontend_tb/dut_fetch_stage/u_fetch_unit/prev_pc_q
add wave -noupdate /frontend_tb/dut_fetch_stage/u_fetch_unit/here
add wave -noupdate /frontend_tb/dut_fetch_stage/u_fetch_unit/will_be_here
add wave -noupdate -group {I-cache interface} -radix decimal -radixshowbase 1 /frontend_tb/addr
add wave -noupdate -group {I-cache interface} /frontend_tb/addr_valid
add wave -noupdate -group {I-cache interface} /frontend_tb/addr_ready
add wave -noupdate -group {I-cache interface} -childformat {{/frontend_tb/data.pc -radix decimal} {/frontend_tb/data.line -radix hexadecimal}} -expand -subitemconfig {/frontend_tb/data.pc {-height 16 -radix decimal -radixshowbase 1} /frontend_tb/data.line {-height 16 -radix hexadecimal -radixshowbase 1}} /frontend_tb/data
add wave -noupdate -group {I-cache interface} /frontend_tb/data_valid
add wave -noupdate -group {I-cache interface} /frontend_tb/data_ready
add wave -noupdate /frontend_tb/dut_fetch_stage/read_done
add wave -noupdate /frontend_tb/dut_fetch_stage/read_req
add wave -noupdate -radix hexadecimal -childformat {{/frontend_tb/dut_fetch_stage/u_fetch_unit/cache_out_i.pc -radix decimal} {/frontend_tb/dut_fetch_stage/u_fetch_unit/cache_out_i.line -radix hexadecimal}} -radixshowbase 1 -subitemconfig {/frontend_tb/dut_fetch_stage/u_fetch_unit/cache_out_i.pc {-height 16 -radix decimal -radixshowbase 1} /frontend_tb/dut_fetch_stage/u_fetch_unit/cache_out_i.line {-height 16 -radix hexadecimal -radixshowbase 1}} /frontend_tb/dut_fetch_stage/u_fetch_unit/cache_out_i
add wave -noupdate -radix hexadecimal -radixshowbase 1 /frontend_tb/dut_fetch_stage/u_fetch_unit/line_reg
add wave -noupdate -radix binary -radixshowbase 1 /frontend_tb/dut_fetch_stage/u_fetch_unit/line_valid
add wave -noupdate -radix hexadecimal -radixshowbase 1 /frontend_tb/dut_fetch_stage/u_fetch_unit/line_bak
add wave -noupdate /frontend_tb/dut_fetch_stage/u_fetch_unit/selector_line
add wave -noupdate -radix hexadecimal -radixshowbase 1 /frontend_tb/instruction
add wave -noupdate /frontend_tb/issue_valid
add wave -noupdate /frontend_tb/issue_ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 166
configure wave -valuecolwidth 198
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {200 ns}
