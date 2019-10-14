# Compile include files
vlog ../mmm_pkg.sv

# Compile design
vlog ../*.sv

# Compile testbench
vlog *.sv

# Load design
vsim work.frontend_tb

# Load waves
do wave.do

# Run simulation
run 200 ns