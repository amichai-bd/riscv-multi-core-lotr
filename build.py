#! /usr/bin/env python
import os
import shutil
import subprocess
import glob
import argparse
import sys
from termcolor import colored

examples = '''
Examples:
python build.py -dut 'gpc_4t' -debug -all -full_run                      -> running full test (app, hw, sim) for all the tests and keeping the outputs 
python build.py -dut 'gpc_4t'        -all -full_run                      -> running full test (app, hw, sim) for all the tests and removing the outputs 
python build.py -dut 'gpc_4t' -debug -tests 'Bubble Binary_Search' -full_run  -> run full test (app, hw, sim) for alive & plus_test only 
python build.py -dut 'gpc_4t' -debug -tests 'Bubble' -app                 -> compiling the sw for 'alive' test only 
python build.py -dut 'gpc_4t' -debug -tests 'Bubble' -hw                  -> compiling the hw for 'alive' test only 
python build.py -dut 'gpc_4t' -debug -tests 'Bubble' -sim -gui            -> running simulation with gui for 'alive' test only 
python build.py -dut 'gpc_4t' -debug -tests 'Bubble' -app -hw -sim -fpga  -> running alive test + FPGA compilation & synthesis
'''
parser = argparse.ArgumentParser(description='Build script for any project', formatter_class=argparse.RawDescriptionHelpFormatter, epilog=examples)
parser.add_argument('-all',         action='store_true', default=False, help='running all the tests')
parser.add_argument('-tests',       default='',             help='list of the tests for run the script on')
parser.add_argument('-debug',       action='store_true',    help='run simulation with debug flag')
parser.add_argument('-gui',         action='store_true',    help='run simulation with gui')
parser.add_argument('-app',         action='store_true',    help='compile the RISCV SW into SV executables')
parser.add_argument('-hw',          action='store_true',    help='compile the RISCV HW into simulation')
parser.add_argument('-sim',         action='store_true',    help='start simulation')
parser.add_argument('-full_run',    action='store_true',    help='compile SW, HW of the test and simulate it')
parser.add_argument('-dut',   default='gpc_4t',     help='insert your project name (as mentioned in the dirs name')
parser.add_argument('-pp',          action='store_true',    help='run post-process on the tests')
parser.add_argument('-fpga',        action='store_true',    help='run compile & synthesis for the fpga')
parser.add_argument('-regress',     default='',             help='insert a level of regression to run on')
args = parser.parse_args()

MODEL_ROOT = subprocess.check_output('git rev-parse --show-toplevel', shell=True).decode().split('\n')[0]
VERIF     = './verif/'+args.dut+'/'
TB        = './verif/'+args.dut+'/tb/'
SOURCE    = './source/'+args.dut+'/'
TARGET    = './target/'+args.dut+'/'
MODELSIM  = './target/'+args.dut+'/modelsim/'
APP       = './app/'
TESTS     = './verif/'+args.dut+'/tests/'
FPGA_ROOT = './FPGA/'+args.dut+'/'

#####################################################################################################
#                                           class Test
#####################################################################################################
class Test:
    hw_compilation = False
    I_MEM_OFFSET = str(0x00000000)
    I_MEM_LENGTH = str(0x00002000)
    D_MEM_OFFSET = str(0x00002000)
    D_MEM_LENGTH = str(0x00002000)
    def __init__(self, name, project):
        self.name = name.split('.')[0]
        self.file_name = name
        self.assembly = True if self.file_name[-1] == 's' else False
        self.project = project 
        self.target , self.gcc_dir = self._create_test_dir()
        self.path = TESTS+self.file_name
        self.fail_flag = False
    def _create_test_dir(self):
        if not os.path.exists(TARGET):
            os.mkdir(TARGET)
        if not os.path.exists(TARGET+'tests'):
            os.mkdir(TARGET+'tests')
        if not os.path.exists(TARGET+'tests/'+self.name):
            os.mkdir(TARGET+'tests/'+self.name)
        if not os.path.exists(TARGET+'tests/'+self.name+'/gcc_files'):
            os.mkdir(TARGET+'tests/'+self.name+'/gcc_files')
        if not os.path.exists(MODELSIM):
            os.mkdir(MODELSIM)
        if not os.path.exists(MODELSIM+'work'):
            os.mkdir(MODELSIM+'work')
        return TARGET+'tests/'+self.name+'/', TARGET+'tests/'+self.name+'/gcc_files'
    def _compile_sw(self):
        print_message('[INFO] Starting to compile SW ...')
        if self.path:
            cs_path =  self.name+'_rv32i.c.s' if not self.assembly else '../../../../../'+self.path
            elf_path = self.name+'_rv32i.elf'
            txt_path = self.name+'_rv32i_elf.txt'
            os.chdir(self.gcc_dir)
            try:
                if not self.assembly:
                    first_cmd  = 'riscv-none-embed-gcc.exe -S -ffreestanding -march=rv32i  -I ../../../../../app/defines ../../../../../'+self.path+' -o '+cs_path
                    print_message(f'[COMMAND] '+first_cmd)
                    subprocess.check_output(first_cmd, shell=True)
                else:
                    pass
            except:
                print_message(f'[ERROR] failed to gcc the test - {self.name}')
                self.fail_flag = True
            else:
                try:
                    second_cmd = 'riscv-none-embed-gcc.exe  -O3 -march=rv32i -I ../../../../../app/defines -T ../../../../../app/link.common.ld -nostartfiles -D__riscv__ ../../../../../app/crt0.S '+cs_path+' -o '+elf_path
                    # TODO add verbosity option to print the command
                    print_message(f'[COMMAND] '+second_cmd)
                    subprocess.check_output(second_cmd, shell=True)
                except:
                    print_message(f'[ERROR] failed to insert linker & crt0.S to the test - {self.name}')
                    self.fail_flag = True
                else:
                    try:
                        third_cmd  = 'riscv-none-embed-objdump.exe -gd {} > {}'.format(elf_path, txt_path)
                        print_message(f'[COMMAND] '+third_cmd)
                        subprocess.check_output(third_cmd, shell=True)
                    except:
                        print_message(f'[ERROR] failed to create "elf.txt" to the test - {self.name}')
                        self.fail_flag = True
                    else:
                        try:
                            forth_cmd = 'riscv-none-embed-objcopy.exe --srec-len 0 --output-target=verilog ' + elf_path + ' inst_mem.sv'
                            print_message(f'[COMMAND] '+forth_cmd)
                            subprocess.check_output(forth_cmd, shell=True)
                        except:
                            print_message(f'[ERROR] failed to create "inst_mem.sv" to the test - {self.name}')
                            self.fail_flag = True
                        else:
                            memories = open('inst_mem.sv', 'r').read()
                            if "@00400000" in memories:
                                split_memories = memories.split("@00400000")
                                with open('inst_mem.sv', 'w') as imem:
                                    imem.write(split_memories[0])
                                with open('data_mem.sv', 'w') as dmem:
                                    dmem.write("@00400000" + split_memories[1])
                            else:
                                print_message(f'[INFO] "@00400000" not found in "inst_mem.sv" for the test - {self.name}')                            
            if not self.fail_flag:
                print_message('[INFO] SW compilation finished with no errors\n')
        else:
            print_message('[ERROR] Can\'t find the c files of '+self.name)
            self.fail_flag = True
        os.chdir(MODEL_ROOT)
    def _compile_hw(self):
        os.chdir(MODELSIM)
        print_message('[INFO] Starting to compile HW ...')
        if not Test.hw_compilation:
            comp_sim_cmd = 'vlog.exe -lint -f ../../../'+TB+'/'+self.project+'_list.f'
            try:
                #results = subprocess.check_output(comp_sim_cmd, shell=True, stderr=subprocess.STDOUT).decode()
                print_message(f'[COMMAND] '+comp_sim_cmd)
                results = subprocess.run(comp_sim_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
            except:
                print_message('[ERROR] Failed to compile simulation of '+self.name)
                self.fail_flag = True
            else:
                Test.hw_compilation = True
                if len(results.stdout.split('Error')) > 2:
                    self.fail_flag = True
                    print(results.stdout)
                else:
                    #print(results.stdout)
                    with open("hw_compile.log", "w") as file:
                        file.write(results.stdout)
                    print_message(' compile results >>>>> target/'+self.project+'/modelsim/hw_compile.log')
                    print_message('[INFO] hw compilation finished with - '+','.join(results.stdout.split('\n')[-2:-1]))
        else:
            print_message(f'[INFO] HW compilation is already done\n')
        os.chdir(MODEL_ROOT)
    def _start_simulation(self):
        os.chdir(MODELSIM)
        print_message('[INFO] Now running simulation ...')
        sim_cmd = 'vsim.exe work.'+self.project+'_tb -c -do "run -all" +STRING='+self.name
        try:
            print_message(f'[COMMAND] '+sim_cmd)
            results = subprocess.run(sim_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
        except:
            print_message('[ERROR] Failed to simulate '+self.name)
            self.fail_flag = True
        else:
            if len(results.stdout.split('Error')) > 2:
                self.fail_flag = True
                print(results.stdout)
            else:
                # print(results.stdout) - TODO write the results to a file instead of to display. print the path to the file
                print_message(' compile results >>>>> target/'+self.project+'/tests/'+self.name+'/'+self.name+'_transcript')
                print_message('[INFO] hw simulation finished with - '+','.join(results.stdout.split('\n')[-2:-1]))
        if os.path.exists('transcript'):  # copy transcript file to the test directory
            shutil.copy('transcript', '../tests/'+self.name+'/'+self.name+'_transcript')
            grep_eot = 'grep EOT ../tests/'+self.name+'/'+self.name+'_transcript'
            print_message(f'[COMMAND] '+grep_eot)
            grep_eot_res = subprocess.run(grep_eot, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
            print_message(f'[INFO] found:'+grep_eot_res.stdout)
        os.chdir(MODEL_ROOT)
    def _gui(self):
        os.chdir(MODELSIM)
        gui_cmd = 'vsim.exe -gui work.'+self.project+'_tb +STRING='+self.name+' &'
        try:
            print_message(f'[COMMAND] '+gui_cmd+'')
            subprocess.call(gui_cmd, shell=True)
        except:
            print_message('[ERROR] Failed to run gui of '+self.name)
            self.fail_flag = True
        os.chdir(MODEL_ROOT)
    def _no_debug(self):
        delete_cmd = 'rm -rf '+TARGET+'tests/'+self.name
        try:
            print_message(f'[COMMAND] '+delete_cmd)
            subprocess.check_output(delete_cmd, shell=True)
        except:
            print_message('[ERROR] failed to remove /target/'+self.project+'/tests/'+self.name+' directory')
    def _post_process(self):
        # Go to the verification directory
        os.chdir(VERIF)
        # Construct the post process command
        pp_cmd = 'python '+self.project+'_pp.py ' +self.name
        # Run the post process command
        try:
            print_message(f'[COMMAND] '+pp_cmd)
            return_val = subprocess.run(pp_cmd)
        except:
            print_message('[ERROR] Failed to run post process ')
            self.fail_flag = True
        # Go back to the model directory
        os.chdir(MODEL_ROOT)
        # Return the return code of the post process command
        return return_val.returncode

    def _start_fpga(self):
        os.chdir(FPGA_ROOT)
        fpga_cmd = 'quartus_map --read_settings_files=on --write_settings_files=off de10_lite_'+self.project+' -c de10_lite_'+self.project+' &'
        #quartus_map --read_settings_files=on --write_settings_files=off de10_lite_big_core -c de10_lite_big_core
        try:
            print_message(f'[COMMAND] FPGA : -'+fpga_cmd+'')
            subprocess.call(fpga_cmd, shell=True)
        except:
            print_message('[ERROR] Failed to run FPGA compilation & synth of '+self.name)
            self.fail_flag = True
        os.chdir(MODEL_ROOT)       
        print_message('/////////////////////////////////////////////////////////////////////////////////')
        find_war_err_cmd = 'grep -ri --color "Info.*error.*warning" ./FPGA/'+args.dut+'/output_files/*'
        print_message(f'[COMMAND] '+find_war_err_cmd)
        subprocess.call(find_war_err_cmd, shell=True)
        print_message(f'[INFO] FPGA results: - FPGA/'+args.dut+'/output_files/')
        print_message('/////////////////////////////////////////////////////////////////////////////////')

        
def print_message(msg):
    msg_type = msg.split()[0]
    try:
        color = {
            '[ERROR]'   : 'red',
            '[WARNING]' : 'yellow',
            '[INFO]'    : 'green',
            '[COMMAND]' : 'cyan',
        }[msg_type]
    except:
        color = 'blue'
    print(colored(msg,color,attrs=['bold']))        

#####################################################################################################
#                                           main
#####################################################################################################       
def main():
    os.chdir(MODEL_ROOT)
    test = 'grep -ri --color "abd_setting_the_color" README.md'
    subprocess.call(test, shell=True)
    if not os.path.exists('target/'+args.dut+'/tests/'):
        os.makedirs('target/'+args.dut+'/tests/')
    # log_file = "target/gpc_4t/build_log.txt"
    
    tests = []
    if args.all:
        test_list = os.listdir(TESTS)
        for test in test_list:
            if 'level' in test: continue
            tests.append(Test(test, args.dut))
    elif args.regress:
        level_list = open(TESTS+args.regress, 'r').read().split('\n')
        for test in level_list:
            if os.path.exists(TESTS+test):
                tests.append(Test(test, args.dut))
            else:
                print_message('[ERROR] can\'t find the test - '+test)
    else:
        for test in args.tests.split():
            test = glob.glob(TESTS+test+'*')[0]
            test = test.replace('\\', '/').split('/')[-1]
            tests.append(Test(test, args.dut))

     # Redirect stdout and stderr to log file
    # sys.stdout = open(log_file, "w", buffering=1)
    # sys.stderr = open(log_file, "w", buffering=1)   
    run_status = "PASSED"
    for test in tests:
        print_message('******************************************************************************')
        print_message('                               Test - '+test.name)
        print_message('******************************************************************************')
        if (args.app or args.full_run) and not test.fail_flag:
            test._compile_sw()
        if (args.hw or args.full_run) and not test.fail_flag:
            test._compile_hw()
        if (args.sim or args.full_run) and not test.fail_flag:
            test._start_simulation()
        if (args.fpga) and not test.fail_flag:
            test._start_fpga()
        if (args.gui):
            test._gui()
        if (args.pp) and not test.fail_flag:
            if (test._post_process()):# if return value is 0, then the post process is done successfully
                test.fail_flag = True
        if not args.debug:
            test._no_debug()
        print_message(f'************************** End {test.name} **********************************')
        print()
        if(test.fail_flag):
            run_status = "FAILED"
    # sys.stdout.flush()
    # sys.stderr.flush()

    if(run_status == "FAILED"):
        print_message('The failed tests are:')
    for test in tests:
        if(test.fail_flag==True):
            print_message(f'[ERROR] test failed - {test.name}  - target/'+args.dut+'/tests/'+test.name+'/')
        if(test.fail_flag==False):
            print_message(f'[INFO] test Passed- {test.name}  - target/'+args.dut+'/tests/'+test.name+'/')
    print_message('=================================================================================')
    print_message(f'[INFO] Run final status: {run_status}')
    print_message('=================================================================================')
    print_message('=================================================================================')
    if(run_status == "FAILED"):
        return 1
    else:
        return 0

if __name__ == "__main__" :
    sys.exit(main())