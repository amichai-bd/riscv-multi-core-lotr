#################################################################
######Compile & Simulate GPC_4T test bench using ModelSim #######
#################################################################

Open git bash shell at Modelsim folder
vlog.exe "+define+HPATH=Alive_Mul_Core" -f ../source/lotr/lotr_list.f

vsim.exe work.lotr_tb -c -do 'run -all'

or with gui:

vsim.exe -gui work.lotr_tb

