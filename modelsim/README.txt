##########################################
# This is where we out the modelsim model
##########################################


# 1) Change directory to modesim
cd modelsim

# 2) Compile The Design
vlog.exe -f ..\source\gpc_4t\gpc_4t_list.f
vlog.exe +define+HPATH=<test_name> -f ../source/gpc_4t/gpc_4t_list.f

# 3a) Simulate the Design without gui
vsim.exe work.gpc_4t_tb -c -do 'run -all'

# 3b) Simulate the Design with gui
vsim.exe -gui work.gpc_4t_tb

# 4) quick lotr alive test
vlog.exe +define+HPATH=Alive_Mul_Core -f ../source/lotr/lotr_list.f
vlog.exe +define+HPATH=abd_MultiCore -f ../source/lotr/lotr_list.f
vsim.exe work.lotr_tb -c -do 'run -all'
vsim.exe -gui work.lotr_tb &

