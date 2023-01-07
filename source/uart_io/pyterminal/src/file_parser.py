#!/usr/bin/python

import os.path

'''
file extention checking
'''
def CheckExt(choices, fname):
    ext = os.path.splitext(fname)[1][1:]
    if ext not in choices:
        print("-E- file doesn't end with one of {}".format(choices))
        return False
    else:
        return True


''' 
file parser into a list of tupels of type:
    {starting address, Word count, [list of all data words]} : mem section-1
    {starting address, Word count, [list of all data words]} : mem section-2
    {starting address, Word count, [list of all data words]} : mem section-3
    .
    .
    .
'''
def parse_sv_file(sv_file):
    if(CheckExt({'sv'}, sv_file)):
        file_data   = []
        section_data_packed = []
        sec_address = 0
        with open(sv_file, "r") as file:
            for line in file:
                l = line.rstrip()
                if(l[0]=='@'):
                    if len(section_data_packed) != 0:
                        file_data.append((sec_address, f"{len(section_data_packed)<<2:08X}", list(section_data_packed)))
                    section_data_packed.clear()
                    sec_address = l[1:]
                else:
                    address = int(sec_address, 16)
                    l = l.split(" ")
                    mem_line = [l[i:i+4] for i in range(0, len(l), 4)]
                    for data_l in mem_line:
                        data_l.reverse()
                        data_l = ''.join(data_l)
                        section_data_packed.append(data_l)
        file_data.append((sec_address, f"{len(section_data_packed)<<2:08X}", list(section_data_packed)))
        return file_data
    else: return None


def write_file():
    return

'''
if __name__ == "__main__":
    file_data=parse_sv_file("./example.sv")
    for section in file_data:
        print("\n-I- Section address: {} of Size: {}\n Data: {}".format(section[0], section[1], section[2]))
'''