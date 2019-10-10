# Compile include files
vlog ../*.svh

# Compile design
vlog ../gshare.sv ../btb.sv ../bpu.sv

# Compile testbench
vlog *.sv

# Load design
vsim work.bpu_tb

# Load waves
do wave.do

# Run simulation
run -all