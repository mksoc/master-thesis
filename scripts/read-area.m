z = csvread('../reports/predictor - sintesi.csv') % Read synthesis results
x = 2:size(z,2) + 1   % BTB_BITS
y = 2:size(z,1) + 1   % HLEN
mesh(x,y,z)

set(gca,"zscale","log")
set(gca,"xlabel","BTB index size (bits)")
set(gca,"ylabel","History length (bits)")
set(gca,"zlabel","Total cell area (um^2)")
