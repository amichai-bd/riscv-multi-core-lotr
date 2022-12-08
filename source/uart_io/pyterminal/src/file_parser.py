

def parse_sv_file():
    with open("./example.sv", "r") as file:
        address = 0
        for line in file:
            l = line.rstrip()
            if(l[0]=='@'):
                print("Found memory section starting at address 0x{}". format(l[1:]))
                address = int(l[1:], 16)
            else:
                l = l.split(" ")
                mem_line = [l[i:i+4] for i in range(0, len(l), 4)]
                for data_l in mem_line:
                    data_l.reverse()
                    data_l = ''.join(data_l)
                    print("Address: {} Data 0x{}".format(str(hex(address)), data_l))
                    address = address+4


if __name__ == "__main__":
    parse_sv_file()