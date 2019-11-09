#!/bin/sh
# The line argument is the history length

BENCH_PATH=/home/marco/Documents/CSE240A/traces
REPORT_FILE=bench-report.txt

printf -v date '%(%Y-%m-%d %H:%M:%S)T' -1
bench=("fp_1" "fp_2" "int_1" "int_2" "mm_1" "mm_2")

# Run all the trace benchmarks
declare -a results
echo "Running benchmark fp_1..."
results+=("$(bunzip2 -kc $BENCH_PATH/fp_1.bz2 | ./predictor --hlen:$1 --btb:$2)")
echo "Running benchmark fp_2..."
results+=("$(bunzip2 -kc $BENCH_PATH/fp_2.bz2 | ./predictor --hlen:$1 --btb:$2)")
echo "Running benchmark int_1..."
results+=("$(bunzip2 -kc $BENCH_PATH/int_1.bz2 | ./predictor --hlen:$1 --btb:$2)")
echo "Running benchmark int_2..."
results+=("$(bunzip2 -kc $BENCH_PATH/int_2.bz2 | ./predictor --hlen:$1 --btb:$2)")
echo "Running benchmark mm_1..."
results+=("$(bunzip2 -kc $BENCH_PATH/mm_1.bz2 | ./predictor --hlen:$1 --btb:$2)")
echo "Running benchmark mm_2..."
results+=("$(bunzip2 -kc $BENCH_PATH/mm_2.bz2 | ./predictor --hlen:$1 --btb:$2)")

# Create result arrays
declare -a accuracy
declare -a mpki

for i in "${results[@]}"
do
  accuracy+=("$(echo "$i" | awk '/Accuracy/ {printf "%-15s ", $2}')")
  mpki+=("$(echo "$i" | awk '/MPKI/ {printf "%s\n", $2}')")
done

# Print results to file
cat > $REPORT_FILE << EOF
============================================
    Benchmark report $date
============================================


Benchmark    Accuracy (%)    MPKI
--------------------------------------
EOF

for i in "${!bench[@]}"
do
  printf "%-12s %-15s %s\n" ${bench[$i]} ${accuracy[$i]} ${mpki[$i]} >> $REPORT_FILE
done

# For easy pasting to Google Sheet
echo >> $REPORT_FILE
echo "CSV-friendly copy/paste lines:" >> $REPORT_FILE
for i in "${accuracy[@]}"
do
  printf "%s%%," $i
done | sed 's/,$/\n/' >> $REPORT_FILE

for i in "${mpki[@]}"
do
  printf "%s," $i
done | sed 's/,$/\n/' >> $REPORT_FILE

echo Done.
