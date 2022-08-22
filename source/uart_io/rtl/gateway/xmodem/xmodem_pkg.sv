package xmodem_pkg;
   parameter integer W_BYTE=8;
   parameter integer N_PACKET_ELEMENTS=5;
   parameter integer W_PACKET_ELEMENTS=$clog2(N_PACKET_ELEMENTS+1);
   // units = bytes
   parameter integer PACKET_START=1;
   parameter integer PACKET_NUMBER=1;
   parameter integer PACKET_NUMBER_1s=1;
   parameter integer PACKET_DATA_BYTES=128;
   parameter integer PACKET_CHECKSUM=1;

   // TODO: assign the actual charachter 
   // values for the following enums 
   typedef enum logic [W_BYTE-1:0]
     {
      SOH, // Start of header
      EOT, // End of transmission
      ACK, // Acknowledge
      NAK, // Not acknowledge
      ETB, // End of transmission block
      CAN  // cancel
      } t_transfer_symbol; 	     

   typedef enum logic [W_PACKET_ELEMENTS-1:0]
     {
      IDLE = '0,
      WAITE_FOR_SYMBOL,
      PROCCESS_PACKET_NUMBER,
      PROCCESS_PACKET_NUMBER_1s,
      PROCCESS_DATA,
      VALIDATE_CHECKSUM
      } t_xmodem_fsm;
   
endpackage // xmodem_pkg
   
