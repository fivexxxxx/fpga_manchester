vlib work
vmap work work
vlog  -work work glbl.v

#library
#vlog  -work work ../../library/artix7/*.v

#IP
#vlog  -work work ../../../source_code/ROM_IP/rom_controller.v

#SourceCode
vlog  -work work ../src/*.v

#Testbench
vlog  -work work test_mqst.v 

#vsim -voptargs=+acc -L unisims_ver -L unisim -L work -Lf unisims_ver work.glbl work.test_mqst
vsim -voptargs=+acc work.glbl work.test_mqst

#Add signal into wave window
do wave.do

#run -all

run 48ns
