#!/usr/bin/python
 
'''
https://pyserial.readthedocs.io/en/latest/pyserial_api.html#module-serial
'''

''' Exteranl libraries '''
import argparse
import os.path
import string
import serial
import serial.tools.list_ports as list_ports

''' Own library '''
import file_parser


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
        print('-E- Failed to connect to port: "{}"'.format(port_name))
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
    ack = port.read(1)
    ack = str(ack, 'utf-8')  
    if(ack==''): 
        print("-E- Write response timeout occured, no acknowledge recieved")
    else: 
        print("-I- Write Acknowledge recieved ack: 0x{}".format(ack))
    return


def serial_port_read(port, addr):
    print("-I- Reading from address: 0x{}".format(addr))
    port.reset_input_buffer()
    port.write(b'R')
    port.write(bytearray.fromhex(addr))
    ack = port.read(1)
    ack = str(ack, 'utf-8')  
    if(ack==''): 
        print("-E- Read response timeout occured, no acknowledge recieved")
        return None
    print("-I- Read Acknowledge recieved ack: 0x{}".format(ack))
    data = port.read(4)
    data = str(data, 'utf-8')  
    if(data==''): 
        print("-E- Data timeout occured")
        return None
    else: 
        print("-I- Data: 0x{} read from address: 0x{}".format(data, addr))
        return data


def serial_port_write_burst(port, addr, size, data_list):
    print('-I- Writing data in Busrt mode to address: 0x{} with size 0x{}'.format(addr, size))
    port.write(b'J')
    port.write(bytearray.fromhex(addr))
    port.write(bytearray.fromhex(size))
    for byte in data_list:
        port.write(bytearray.fromhex(byte))
    ack = port.read(1)
    ack = str(ack, 'utf-8')  
    if(ack==''):
        print("-E- Write response timeout occured, no acknowledge recieved")
    else:
        print("-I- Write Acknowledge recieved ack: 0x{}".format(ack))
    return


def serial_port_read_burst(port, addr, size, file_name):
    print('-I- reading data from address: 0x{} with size 0x{} to file "{}" to'.format(addr, size, file_name))
    port.write(b'M')
    port.write(bytearray.fromhex(addr))
    port.write(bytearray.fromhex(size))
    # TODO: HALT interface. wait for transfer to complete...
    # TODO: return transfer status
    # TODO: implement Timeout mechanisim
    return None


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
            print("-E- Invalid address")
            return None
        if(length<8): 
            padded_addr=''
            for i in range(8-length):
                padded_addr = padded_addr + '0'
            padded_addr = padded_addr + address[2:]
            return padded_addr
        elif(length>8):
            print("-E- Invalid address")
            return None
        else: return address[2:]
    else:
        print("-E- Invalid address")
        return None


def get_transfer_data():
    data = input("-I- Enter transfer data 32bit Hex         : ")
    if(data[:2]=="0x"):
        length = len(data[2:])
        if all(c in string.hexdigits for c in data[2:])==False:
            print("-E- Invalid data")
            return None
        if(length<8): 
            padded_data=''
            for i in range(8-length):
                padded_data = padded_data + '0'
            padded_data = padded_data + data[2:]
            return padded_data
        elif(length>8):
            print("-E- Invalid data")
            return None
        else: return data[2:]
    else:
        print("-E- Invalid data")
        return None


def get_transfer_size():
    size = input("-I- Enter transfer size 32bit Hex         : ")
    if(size[:2]=="0x"):
        length = len(size[2:])
        if all(c in string.hexdigits for c in size[2:])==False:
            print("-E- Invalid size")
            return None
        if(length<8): 
            padded_data=''
            for i in range(8-length):
                padded_data = padded_data + '0'
            padded_data = padded_data + size[2:]
            return padded_data
        elif(length>8):
            print("-E- Invalid size")
            return None
        else: return size[2:]
    else:
        print("-E- Invalid size")
        return None


def get_transfer_file():
    file_name = input("-I- Enter transfer file                   : ")
    exists = os.path.isfile(file_name)
    if not exists:
        print('-E- Invalid path: "{}"'.format(file_name))
        return None
    return file_name


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


def handle_write_transfer_in_burst_mode(port): 
    file_name = get_transfer_file()
    if(file_name==None): return None
    file_data = file_parser.parse_sv_file(file_name)
    for section in file_data:
        serial_port_write_burst(port, section[0], section[1], section[2])
    return


def handle_read_transfer_in_burst_mode(port):
    addr = get_transfer_address()
    if(addr==None): return None
    size = get_transfer_size()
    if(size==None): return None
    file_name = get_transfer_file()
    if(file_name==None): return None
    serial_port_read_burst(port, addr, size, file_name)
    return


def main():
    args = parse_args()
    print("\n-I- Listing available COM ports:")
    ports = list_ports.comports()
    port_list=[]

    for port, desc, hwid in sorted(ports):
        port_list.append(port)
        print("\t{}: {}".format(port, desc))
    
    if port_list==[]: 
        print("-E- no COM PORTS detected\n\n")
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
    
    end_terminal=False
    while(end_terminal==False):
        type = get_transaction_type()
        if(type == "Q")    : end_terminal=True
        elif(type == "W")  : handle_write_transfer(port)
        elif(type == "R")  : handle_read_transfer(port)
        elif(type == "WB") : handle_write_transfer_in_burst_mode(port)
        elif(type == "RB") : handle_read_transfer_in_burst_mode(port)
        else: print("-E- Illigal operation")
    
    print("-I- Closing port: {}\n\n".format(port_name))
    port.close()
    return

if __name__ == "__main__":
    main()