add wave -divider {test_mqst}
#add wave -position insertpoint sim:/test_mqst/*

add wave -divider {Mqst_top}
#add wave -position insertpoint sim:/test_mqst/Mqst_top/*
#

add wave -position insertpoint  \
sim:/test_mqst/clk
add wave -position insertpoint  \
sim:/test_mqst/data_in
add wave -position insertpoint  \
sim:/test_mqst/data_in_valid
add wave -position insertpoint  \
sim:/test_mqst/Mqst_top/Bit_out
add wave -position insertpoint  \
sim:/test_mqst/Mqst_top/Bit_out_valid
add wave -position insertpoint  \
sim:/test_mqst/Mqst_top/Bit_out_tready
add wave -position insertpoint  \
sim:/test_mqst/Mqst_top/Mqst_BitOut
add wave -position insertpoint  \
sim:/test_mqst/Mqst_top/Mqst_tx/clk_cnt
add wave -position insertpoint  \
sim:/test_mqst/Mqst_top/Mqst_tx/send_tmp
add wave -position insertpoint  \
sim:/test_mqst/data_tready


add wave -position insertpoint  \
sim:/test_mqst/Mqst_top/Mqst_rx/Bit_in
add wave -position insertpoint  \
sim:/test_mqst/Mqst_top/Mqst_rx/Bit_in_valid
add wave -position insertpoint  \
sim:/test_mqst/Mqst_top/Mqst_rx/clk_cnt
add wave -position insertpoint  \
sim:/test_mqst/Mqst_top/Mqst_rx/Mqst_BitIn_tmp
add wave -position insertpoint  \
sim:/test_mqst/Mqst_top/Mqst_rx/Bit_sync
