onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /frontend_tb/clk
add wave -noupdate /frontend_tb/rst_n
add wave -noupdate /frontend_tb/flush
add wave -noupdate -divider {PC gen stage}
add wave -noupdate -radix decimal -radixshowbase 1 /frontend_tb/pc
add wave -noupdate -radix decimal -radixshowbase 1 /frontend_tb/dut_pc_gen_stage/next_pc
add wave -noupdate -divider {Fetch stage}
add wave -noupdate /frontend_tb/dut_fetch_stage/u_ifu/u_fetch_controller/present_state
add wave -noupdate /frontend_tb/fetch_ready
add wave -noupdate -radix decimal -radixshowbase 1 /frontend_tb/dut_fetch_stage/u_ifu/prev_pc_q
add wave -noupdate /frontend_tb/dut_fetch_stage/u_ifu/here
add wave -noupdate /frontend_tb/dut_fetch_stage/u_ifu/will_be_here
add wave -noupdate -expand -group {I-cache interface} /frontend_tb/dut_fetch_stage/u_icache_ifc/present_state
add wave -noupdate -expand -group {I-cache interface} -radix decimal -radixshowbase 1 /frontend_tb/addr
add wave -noupdate -expand -group {I-cache interface} /frontend_tb/addr_valid
add wave -noupdate -expand -group {I-cache interface} /frontend_tb/addr_ready
add wave -noupdate -expand -group {I-cache interface} -radix decimal -childformat {{/frontend_tb/data.pc -radix decimal} {/frontend_tb/data.line -radix decimal}} -subitemconfig {/frontend_tb/data.pc {-height 16 -radix decimal -radixshowbase 1} /frontend_tb/data.line {-height 16 -radix decimal -radixshowbase 1}} /frontend_tb/data
add wave -noupdate -expand -group {I-cache interface} /frontend_tb/data_valid
add wave -noupdate -expand -group {I-cache interface} /frontend_tb/data_ready
add wave -noupdate /frontend_tb/dut_fetch_stage/read_done
add wave -noupdate /frontend_tb/dut_fetch_stage/read_req
add wave -noupdate -radix decimal -childformat {{/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.pc -radix decimal} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line -radix decimal -childformat {{{[15]} -radix decimal} {{[14]} -radix decimal} {{[13]} -radix decimal} {{[12]} -radix decimal} {{[11]} -radix decimal} {{[10]} -radix decimal} {{[9]} -radix decimal} {{[8]} -radix decimal} {{[7]} -radix decimal} {{[6]} -radix decimal} {{[5]} -radix decimal} {{[4]} -radix decimal} {{[3]} -radix decimal} {{[2]} -radix decimal} {{[1]} -radix decimal} {{[0]} -radix decimal}}}} -radixshowbase 1 -expand -subitemconfig {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.pc {-height 16 -radix decimal -radixshowbase 1} /frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line {-height 16 -radix decimal -childformat {{{[15]} -radix decimal} {{[14]} -radix decimal} {{[13]} -radix decimal} {{[12]} -radix decimal} {{[11]} -radix decimal} {{[10]} -radix decimal} {{[9]} -radix decimal} {{[8]} -radix decimal} {{[7]} -radix decimal} {{[6]} -radix decimal} {{[5]} -radix decimal} {{[4]} -radix decimal} {{[3]} -radix decimal} {{[2]} -radix decimal} {{[1]} -radix decimal} {{[0]} -radix decimal}} -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[15]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[14]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[13]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[12]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[11]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[10]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[9]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[8]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[7]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[6]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[5]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[4]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[3]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[2]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[1]} {-radix decimal -radixshowbase 1} {/frontend_tb/dut_fetch_stage/u_ifu/cache_out_i.line[0]} {-radix decimal -radixshowbase 1}} /frontend_tb/dut_fetch_stage/u_ifu/cache_out_i
add wave -noupdate -radix decimal -radixshowbase 1 /frontend_tb/dut_fetch_stage/u_ifu/line_reg
add wave -noupdate -radix binary -radixshowbase 1 /frontend_tb/dut_fetch_stage/u_ifu/line_valid
add wave -noupdate -radix decimal -radixshowbase 1 /frontend_tb/dut_fetch_stage/u_ifu/line_bak
add wave -noupdate /frontend_tb/dut_fetch_stage/u_ifu/line_sel
add wave -noupdate -radix decimal -radixshowbase 1 /frontend_tb/instruction
add wave -noupdate /frontend_tb/issue_valid
add wave -noupdate /frontend_tb/issue_ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {65 ns} 0}
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
WaveRestoreZoom {10 ns} {210 ns}
