### creating work library
cd source
vlib.exe ./uart_io/work

### Compilation command
vlog.exe -f ./uart_io/uart_io_list.f -work ./uart_io/work -skipsynthoffregion -lint -source -warning [] -fatal [] -note [] -error [] -suppress 2275

### simulation command
vsim.exe -Ldir "uart_io" -t 1ns work.uart_io_tb -work ./uart_io/work -gui -do "run -all" -checkvifacedrivers 1 -no_autoacc -keeploaded -suppress 8315,3584,8233,3408,3999 +UART_SIMULATION