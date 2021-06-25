Push-Location ../../modelsim/
write-host "    ############~~ Adi & Saar GPC_4T Simulation TestBench ~~############    "
write-host ""
write-host ""
write-host "##There are a total of $($args.count) test entered##"
write-host ""
write-host ""
for ( $i = 0; $i -lt $args.count; $i++ ) {
     write-host "***********Compiling Test number $i which is $($args[$i]) test***********"
     write-host ""
     vlog.exe +define+HPATH=$($args[$i]) -f ..\source\gpc_4t\gpc_4t_list.f
     write-host ""
     write-host "***********Simulating Test: $($args[$i])***********"
     write-host ""
     vsim.exe work.gpc_4t_tb -c -do 'run -all'
     write-host ""
     write-host ""
} 
Pop-Location