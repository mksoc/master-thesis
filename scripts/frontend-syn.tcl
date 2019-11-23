# Set design parameters
set hlen HLEN=>8
set btbBits BTB_BITS=>8
set srcFiles [list\
  ../src/mmm_pkg.sv\
  ../src/branch_unit_cu.sv\
  ../src/branch_unit.sv\
  ../src/fetch_controller.sv\
  ../src/ifu.sv\
  ../src/icache_ifc.sv\
  ../src/instr_sel.sv\
  ../src/presence_check.sv\
  ../src/btb.sv\
  ../src/gshare.sv\
  ../src/bpu.sv\
  ../src/fetch_stage.sv\
]
set fileFormat sverilog
set topName fetch_stage
set clkName clk_i
set targetPeriod 0
set power_preserve_rtl_hier_names true
set hdlin_preserve_sequential true
define_design_lib WORK -path ./lib

# Analyze and elaborate
analyze -format $fileFormat -lib WORK $srcFiles
elaborate $topName -lib WORK -parameters "$hlen,$btbBits" > elaborate.txt
uniquify
check_design > check_design.txt

# Apply contraints
create_clock $clkName -period $targetPeriod
set_ideal_network $clkName
set_dont_touch_network $clkName
set_clock_uncertainty 0.07 [get_clocks $clkName]
set_input_delay 0.5 -max -clock $clkName [remove_from_collection [all_inputs] $clkName]
set_output_delay 0.5 -max -clock $clkName [all_outputs]
set outputLoad [load_of uk65lscllmvbbr_120c25_tc/BUFM10R/A]
set_load $outputLoad [all_outputs]

# Compile design
compile > compile.txt

# Generate reports
report_timing > timing.txt
report_area > area.txt

quit
