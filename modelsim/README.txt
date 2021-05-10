##########################################
# This is where we out the modelsim model
##########################################


# 1) Change directory to modesim
cd modelsim

# 2) Compile The Design
vlog.exe -f ..\source\gpc_4t\gpc_4t_list.f

# 3a) Simulate the Design without gui
vsim.exe work.gpc_4t_tb -c -do 'run -all'

# 3b) Simulate the Design with gui
vsim.exe -gui work.gpc_4t_tb
