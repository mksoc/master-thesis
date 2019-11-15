# Compile include files
vlog ../../mmm_pkg.sv

# Compile design
vlog ../../*.sv

# Compile testbench
vlog ../*.sv
vlog *.sv

# Load design
vsim work.bpu_tb

# Load waves
# do wave.do

# Run simulation
run -all