#!/usr/bin/python
 
'''
https://pyserial.readthedocs.io/en/latest/pyserial_api.html#module-serial
'''
import argparse
import string
import serial
import serial.tools.list_ports as list_ports


'''
parse user arguments
'''
def parse_args():
    parser = argparse.ArgumentParser(description='Python terminal for UART transactions')
    parser.add_argument('-mode', dest='mode', required=False, choices={'interactive', 'file'}\
                        , default='interactive', help='select working mode, file or interactive')

    args=parser.parse_args()
    return args



def open_serial_port(port_name):
    print('-I- Attempting to connect to port: "{}"'.format(port_name))
    port = serial.Serial('{}'.format(port_name))
    if(port == None): 
        print('-I- Failed to connect to port: "{}"'.format(port_name))
        exit(1)
    else:
        print('-I- Conection to port: "{}" succeeded'.format(port_name))
        return port

def config_serial_port(port):
    port.baudrate = 9600  # set Baud rate to 9600 from available list [9600, 19200, 38400, 57600, 115200]
    port.bytesize = 8     # Number of data bits = 8
    port.parity   ='N'    # No parity
    port.stopbits = 1     # Number of Stop bits = 1
    port.timeout  = 5     # Read timeput is 5 seconds
    return

def serial_port_write(port, addr, data):
    print("-I- Writing data: 0x{} to address: 0x{}".format(data, addr))
    port.write(b'W')
    port.write(bytearray.fromhex(addr))
    port.write(bytearray.fromhex(data))
    # TODO: HALT interface. wait for transfer to complete...
    # TODO: return transfer status
    # TODO: implement Timeout mechanisim
    return

def serial_port_read(port, addr):
    print("-I- Reading from address: 0x{}".format(addr))
    port.reset_input_buffer()
    port.write(b'R')
    port.write(bytearray.fromhex(addr))
    data = port.read(8) #TODO: fix to 4 on real hardware
    data = str(data, 'utf-8')  
    if(data==''): 
        print("-I- Read timeout occured")
        return None
    else: 
        print("-I- Data: 0x{} read from address: 0x{}".format(data, addr))
        return data

def get_transaction_type():
    transfer = input("\n\n-I- Enter transfer Type {W, R, WB, RB, Q} : ")
    try:
        ["W", "R", "WB", "RB", "Q"].index(transfer)
        return transfer
    except:      
        return None

def get_transfer_address():
    address = input("-I- Enter transfer address 32bit Hex      : ")
    if(address[:2]=="0x"):
        length = len(address[2:])
        if all(c in string.hexdigits for c in address[2:])==False:
            print("-I- Invalid address")
            return None
        if(length<8): 
            padded_addr=''
            for i in range(8-length):
                padded_addr = padded_addr + '0'
            padded_addr = padded_addr + address[2:]
            return padded_addr
        elif(length>8):
            print("-I- Invalid address")
            return None
        else: return address[2:]
    else:
        print("-I- Invalid address")
        return None

def get_transfer_data():
    data = input("-I- Enter transfer data 32bit Hex         : ")
    if(data[:2]=="0x"):
        length = len(data[2:])
        if all(c in string.hexdigits for c in data[2:])==False:
            print("-I- Invalid data")
            return None
        if(length<8): 
            padded_data=''
            for i in range(8-length):
                padded_data = padded_data + '0'
            padded_data = padded_data + data[2:]
            return padded_data
        elif(length>8):
            print("-I- Invalid data")
            return None
        else: return data[2:]
    else:
        print("-I- Invalid data")
        return None

def handle_write_transfer(port): 
    addr = get_transfer_address()
    if(addr==None): return None
    data = get_transfer_data()
    if(data==None): return None
    serial_port_write(port, addr, data)
    return

def handle_read_transfer(port):
    addr = get_transfer_address()
    if(addr==None): return None
    data = serial_port_read(port, addr)
    if(data==None): return None
    return

def handle_write_transfer_in_burst_mode(port): return
def handle_read_transfer_in_burst_mode(port): return

def main():
    args = parse_args()
    print("\n-I- Listing available COM ports:")
    ports = list_ports.comports()
    port_list=[]

    for port, desc, hwid in sorted(ports):
        port_list.append(port)
        print("\t{}: {}".format(port, desc))
    
    if port_list==[]: 
        print("-I- no COM PORTS detected\n\n")
        exit(1)

    port_name = input("\n\n-I- Enter port to connect: ")
    try:
        port_list.index(port_name)
    except:
        print('-I- Port "{}" not in port list\n\n'.format(port_name))
        exit(1)

    del port_list
    port = open_serial_port(port_name)
    config_serial_port(port)
    #TODO: check transaction type first

    end_terminal=False
    while(end_terminal==False):
        type = get_transaction_type()
        if(type == "Q")    : end_terminal=True
        elif(type == "W")  : handle_write_transfer(port)
        elif(type == "R")  : handle_read_transfer(port)
        elif(type == "WB") : handle_write_transfer_in_burst_mode(port)
        elif(type == "RB") : handle_read_transfer_in_burst_mode(port)
        else: print("-I- Illigal operation")
    
    print("-I- Closing port: {}\n\n".format(port_name))
    port.close()
    return

if __name__ == "__main__":
    main()