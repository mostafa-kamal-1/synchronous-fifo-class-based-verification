vlib work
vlog -f src_fifo_files.txt -mfcu +define+SIM +cover
vsim -voptargs=+acc work.FIFO_top -classdebug -uvmcontrol=all -cover
add wave /FIFO_top/f_if/*
coverage save FIFO_top.ucdb -onexit
run -all
