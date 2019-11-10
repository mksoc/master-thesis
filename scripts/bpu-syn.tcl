# Set design parameters
set srcFiles [list\
  ../src/mmm_pkg.sv\
  ../src/btb.sv\
  ../src/gshare.sv\
  ../src/bpu.sv\
]
set fileFormat sverilog
set topName bpu
set clkName clk_i
set targetPeriod 100.0
define_design_lib WORK -path ./lib

# Analyze and elaborate
analyze -format $fileFormat -lib WORK $srcFiles
set power_preserve_rtl_hier_names true
elaborate $topName -lib WORK > elaborate.txt
uniquify
link

# Apply contraints
create_clock -name CLOCK -period $targetPeriod $clkName
set_dont_touch_network CLOCK
set_clock_uncertainty 0.07 [get_clocks CLOCK]
set_input_delay 0.5 -max -clock CLOCK [remove_from_collection [all_inputs] CLOCK]
set_output_delay 0.5 -max -clock CLOCK [all_outputs]
set outputLoad [load_of uk65lscllmvbbr_120c25_tc/BUFM10R/A]
set_load $outputLoad [all_outputs]
set hdlin_preserve_sequential true

# Compile design
compile

# Generate reports
report_timing > timing.txt
report_area > area.txt

quit