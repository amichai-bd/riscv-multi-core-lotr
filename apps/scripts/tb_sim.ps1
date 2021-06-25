Push-Location ../../modelsim/

$files = Get-ChildItem ..\verif\Tests\
if ($args[0] -eq "All"){
    $tests = $files
    for ($i=0; $i -lt $tests.Count; $i++) {
    $tests[$i] = $tests[$i].Name
    }
}
else
{
    $tests = $args
}

write-host "    ############~~ Adi & Saar GPC_4T Simulation TestBench ~~############    "
write-host ""
write-host ""
write-host "##There are a total of $($tests.count) test entered##"
write-host ""
write-host ""
for ( $i = 0; $i -lt $tests.count; $i++ ) {
     write-host "***********Compiling Test number $i which is $($tests[$i]) test***********"
     write-host ""
     if (Test-Path -Path ..\target\$($tests[$i])) {
    
     } else {
         mkdir ..\target\$($tests[$i])
     }
     vlog.exe +define+HPATH=$($tests[$i]) -f ..\source\gpc_4t\gpc_4t_list.f
     write-host ""
     write-host "***********Simulating Test: $($tests[$i])***********"
     write-host ""
     vsim.exe work.gpc_4t_tb -c -do 'run -all'
     write-host ""
     write-host ""
} 
Pop-Location