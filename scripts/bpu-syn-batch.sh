for hlen in {2..10}
do
  for btbBits in {2..10}
  do
    sed -i "/HLEN/ s/>.*/>${hlen}/" bpu-syn.tcl
    sed -i "/BTB_BITS/ s/>.*/>${btbBits}/" bpu-syn.tcl
    dc_shell-xg-t -f bpu-syn.tcl
  done
done