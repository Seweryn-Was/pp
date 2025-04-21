echo "Starting Compialtion"
vcom -work work -2008 -autoorder *.vhd 
echo "Compile Finished" 

echo "Running wave simulation"
vsim -voptargs=+acc work.sw2display_tb

add wave -position insertpoint  \
sim:/sw2display_tb/sw \
sim:/sw2display_tb/hex5 \
sim:/sw2display_tb/hex4 \
sim:/sw2display_tb/hex3 \
sim:/sw2display_tb/hex2 \
sim:/sw2display_tb/hex1 \
sim:/sw2display_tb/hex0

radix -hexadecimal

run 400ns