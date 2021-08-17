Push-Location ../../../modelsim/
$FailedTests = @()
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
write-host ""
write-host ""
write-host ""
write-host ""
write-host "    ####################################################################    "
write-host "    ############~~ Adi & Saar GPC_4T Simulation TestBench ~~############    "
write-host "    ####################################################################    "
write-host ""
write-host ""
write-host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
write-host "        There are a total of $($tests.count) test entered"
write-host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
write-host ""
write-host ""
for ( $i = 0; $i -lt $tests.count; $i++ ) {
     write-host ""
     write-host "***********Compiling Test number $i : $($tests[$i]) test***********"
     write-host ""
     write-host ""
     write-host "Initiate Compilation..."
     write-host "."
     write-host "."
     write-host "."     
     if (Test-Path -Path ..\target\$($tests[$i])) {
    
     } else {
         mkdir ..\target\$($tests[$i])
     }
     vlog.exe +define+HPATH=$($tests[$i]) -f ..\source\gpc_4t\gpc_4t_list.f
     write-host ""
     write-host "."
     write-host "."     
     write-host "Compilation Ended. Details above"
     write-host ""
     write-host ""   
     write-host "***********Simulating Test: $($tests[$i])***********"
     write-host ""
     write-host "Initiate Simulation..."
     write-host "."
     write-host "."
     write-host "."       
     vsim.exe work.gpc_4t_tb -c -do 'run -all'
     write-host ""
     write-host ""
     write-host "."
     write-host "."       
     write-host "Simulation Ended. Details above"
     write-host ""
     write-host ""     
     write-host "Initiate Verification..."
     write-host "."
     write-host "."
     write-host "." 
     $fileA = "..\verif\Tests\$($tests[$i])\golden_shrd_mem_snapshot.log"
     $fileB = "..\target\$($tests[$i])\shrd_mem_snapshot.log"
     write-host ""
     write-host ""        
     if(Compare-Object -ReferenceObject $(Get-Content $fileA) -DifferenceObject $(Get-Content $fileB))
     
        {"Verification for test $($tests[$i]) failed : Memory snapshot is different from Gloden Memory Snapshot"
         $FailedTests+=$tests[$i]
         }
     
     Else {
         "Verification Succeeded ! Memory snapshot match Gloden Memory Snapshot"
     }  
     write-host "."
     write-host "."       
     write-host "Verification Ended. Details above"
     write-host ""
     write-host ""         
     write-host ""
     write-host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"       
     write-host ""  
     write-host "Test number $i has ended"
     write-host ""       
     write-host "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"  
     
} 
write-host "__________________________________________________"
write-host ""
write-host "GPC_4T Simulation TestBench Finished ! "
write-host ""
if ( $FailedTests.count -gt 0 ){
    write-host "$($FailedTests.count) Tests Failed Verification:"
    write-host ""
    for ( $j = 0; $j -lt $FailedTests.count; $j++ ) {
        write-host "$($FailedTests[$j])"
        write-host ""
    }
}
Else {
    write-host "All Tests Passed Verification !"
    write-host ""
}
write-host "__________________________________________________"
write-host ""

Pop-Location




