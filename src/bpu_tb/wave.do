onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary -radixshowbase 1 /bpu_tb/dut/clk_i
add wave -noupdate -radix binary -radixshowbase 1 /bpu_tb/dut/rst_n_i
add wave -noupdate -radix binary -radixshowbase 1 /bpu_tb/dut/flush_i
add wave -noupdate -divider {BPU top}
add wave -noupdate -radix decimal -radixshowbase 1 /bpu_tb/dut/pc_i
add wave -noupdate -radix binary -radixshowbase 1 /bpu_tb/dut/res_valid_i
add wave -noupdate -radix decimal -radixshowbase 1 /bpu_tb/dut/res_pc_i
add wave -noupdate -radix hexadecimal -radixshowbase 1 /bpu_tb/dut/res_index_i
add wave -noupdate -radix decimal -radixshowbase 1 /bpu_tb/dut/res_target_i
add wave -noupdate -radix binary -radixshowbase 1 /bpu_tb/dut/res_taken_i
add wave -noupdate -radix binary -radixshowbase 1 /bpu_tb/dut/res_mispredict_i
add wave -noupdate -radix decimal -radixshowbase 1 /bpu_tb/dut/pred_pc_o
add wave -noupdate -radix hexadecimal -radixshowbase 1 /bpu_tb/dut/pred_index_o
add wave -noupdate -radix decimal -radixshowbase 1 /bpu_tb/dut/pred_target_o
add wave -noupdate -radixshowbase 1 /bpu_tb/dut/pred_taken_o
add wave -noupdate -divider gshare
add wave -noupdate -radix hexadecimal -radixshowbase 1 /bpu_tb/dut/u_gshare/history
add wave -noupdate {/bpu_tb/dut/u_gshare/pht_q[3]}
add wave -noupdate {/bpu_tb/dut/u_gshare/pht_q[32771]}
add wave -noupdate {/bpu_tb/dut/u_gshare/pht_q[49155]}
add wave -noupdate -radixshowbase 1 /bpu_tb/dut/u_gshare/taken_o
add wave -noupdate -divider BTB
add wave -noupdate -radix binary -radixshowbase 1 /bpu_tb/dut/u_btb/update_valid_i
add wave -noupdate -radix binary -radixshowbase 1 /bpu_tb/dut/u_btb/del_entry_i
add wave -noupdate -radixshowbase 1 /bpu_tb/dut/u_btb/hit_o
add wave -noupdate -childformat {{{/bpu_tb/dut/u_btb/btb_q[3].valid} -radix binary} {{/bpu_tb/dut/u_btb/btb_q[3].tag} -radix decimal} {{/bpu_tb/dut/u_btb/btb_q[3].target} -radix decimal}} -expand -subitemconfig {{/bpu_tb/dut/u_btb/btb_q[3].valid} {-radix binary -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[3].tag} {-radix decimal -radixshowbase 1} {/bpu_tb/dut/u_btb/btb_q[3].target} {-radix decimal -radixshowbase 1}} {/bpu_tb/dut/u_btb/btb_q[3]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {77 ns} 0}
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
