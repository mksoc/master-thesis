# Set design parameters
set srcFiles [list\
  ../src/mmm_pkg.sv\
  ../src/branch_unit_cu.sv\
  ../src/branch_unit.sv\
  ../src/fetch_cu.sv\
  ../src/fetch_unit.sv\
  ../src/icache_interface.sv\
  ../src/instruction_selector.sv\
  ../src/presence_checker.sv\
  ../src/btb.sv\
  ../src/gshare.sv\
  ../src/bpu.sv\
  ../src/fetch_stage.sv\
]
set fileFormat sverilog
set topName fetch_stage
define_design_lib WORK -path ./lib

# Analyze and elaborate
analyze -format $fileFormat -lib WORK $srcFiles
set power_preserve_rtl_hier_names true
elaborate $topName -lib WORK > elaborate.txt
uniquify
link