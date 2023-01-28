#################################################################
######Compile & Simulate GPC_4T test bench using ModelSim #######
#################################################################

To run tb_sim.ps1 script:
1. 	open PowerShell in \apps\scripts\tb_sim
2. 	type : ".\tb_sim.ps1 All" to run all tests in Verif\Tests\
	or 
	type : ".\tb_sim.ps1 TestName1 TestName3 TestName7 etc.." to run designated tests 
	(replace TestNameX with the name of the test, for example .\tb_sim.ps1 Bubble Factorial)
2. 	for running with gui:
    type : ".\tb_sim.ps1 TestNameX -G" to run with gui.


****if you are getting error when running scripts, you need to config your powerShell to run scrips:
1.	Open Windows PowerShell with Run as Administrator
2.	type : "Set-ExecutionPolicy RemoteSigned"
3.	type : Y
4.	run script and enjoy :)

