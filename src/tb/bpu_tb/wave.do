onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary -radixshowbase 1 /bpu_tb/dut/clk_i
add wave -noupdate -radix binary -radixshowbase 1 /bpu_tb/dut/rst_n_i
add wave -noupdate -radix binary -radixshowbase 1 /bpu_tb/dut/flush_i
add wave -noupdate -divider {BPU top}
add wave -noupdate -radix decimal -radixshowbase 1 /bpu_tb/dut/pc_i
add wave -noupdate -radix unsigned -childformat {{/bpu_tb/dut/pred_o.pc -radix unsigned} {/bpu_tb/dut/pred_o.target -radix unsigned} {/bpu_tb/dut/pred_o.taken -radix unsigned}} -radixshowbase 1 -expand -subitemconfig {/bpu_tb/dut/pred_o.pc {-height 16 -radix unsigned -radixshowbase 1} /bpu_tb/dut/pred_o.target {-height 16 -radix unsigned -radixshowbase 1} /bpu_tb/dut/pred_o.taken {-height 16 -radix unsigned -radixshowbase 1}} /bpu_tb/dut/pred_o
add wave -noupdate -radix unsigned -childformat {{/bpu_tb/dut/res_i.valid -radix unsigned} {/bpu_tb/dut/res_i.pc -radix unsigned} {/bpu_tb/dut/res_i.target -radix unsigned} {/bpu_tb/dut/res_i.taken -radix unsigned} {/bpu_tb/dut/res_i.mispredict -radix unsigned}} -radixshowbase 1 -expand -subitemconfig {/bpu_tb/dut/res_i.valid {-height 16 -radix unsigned -radixshowbase 1} /bpu_tb/dut/res_i.pc {-height 16 -radix unsigned -radixshowbase 1} /bpu_tb/dut/res_i.target {-height 16 -radix unsigned -radixshowbase 1} /bpu_tb/dut/res_i.taken {-height 16 -radix unsigned -radixshowbase 1} /bpu_tb/dut/res_i.mispredict {-height 16 -radix unsigned -radixshowbase 1}} /bpu_tb/dut/res_i
add wave -noupdate -divider gshare
add wave -noupdate -radix binary -radixshowbase 1 /bpu_tb/dut/u_gshare/history
add wave -noupdate /bpu_tb/dut/u_gshare/pht_q
add wave -noupdate -radixshowbase 1 /bpu_tb/dut/u_gshare/taken_o
add wave -noupdate -divider BTB
add wave -noupdate -radix unsigned -childformat {{{/bpu_tb/dut/u_btb/btb_q[0]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[1]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[2]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[3]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[4]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[5]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[6]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[7]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[8]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[9]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[10]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[11]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[12]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[13]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[14]} -radix unsigned} {{/bpu_tb/dut/u_btb/btb_q[15]} -radix unsigned}} -radixshowbase 1 -subitemconfig {{/bpu_tb/dut/u_btb/btb_q[0]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[1]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[2]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[3]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[4]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[5]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[6]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[7]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[8]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[9]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[10]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[11]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[12]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[13]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[14]} {-height 16 -radix unsigned -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[15]} {-height 16 -radix unsigned -radixshowbase 1}} /bpu_tb/dut/u_btb/btb_q
add wave -noupdate -radix binary -radixshowbase 1 /bpu_tb/dut/u_btb/del_entry_i
add wave -noupdate /bpu_tb/dut/u_btb/valid_i
add wave -noupdate -radixshowbase 1 /bpu_tb/dut/u_btb/hit_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {97 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 157
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
WaveRestoreZoom {0 ns} {235 ns}
