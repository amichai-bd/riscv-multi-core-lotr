/*

*/

int write_buffer[8] = {0};
int read_buffer[4] = {0};
int address=0;
int data=0;
bool write=false;
bool read =false;
int byte_count=0;

  
void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(9600);             // Begin the Serial at 9600 Baud
}

void loop() {
  int byte=0;

  if (Serial.available()>0) {
    byte = Serial.read();
    //Serial.println(byte);

    if(write){
      write_buffer[byte_count] = byte;
      byte_count++;
      digitalWrite(LED_BUILTIN, LOW);
      if(byte_count == 7){
        write=false;
        byte_count=0;
        digitalWrite(LED_BUILTIN, LOW);
        for(int i=0; i<4; i++){
          address = address | ((write_buffer[i] & 0xff)<<((3-i)*8)); 
        }
        for(int i=4; i<8; i++){
          data = data | ((write_buffer[i] & 0xff)<<((7-i)*8)); 
        }
        Serial.print("-I- Recieved write request to Address: 0x");
        Serial.print(address, HEX);
        Serial.print(", Data: 0x");
        Serial.print(data, HEX);
        Serial.println("");
      }
    }
    else if(read){
      read_buffer[byte_count++] = byte;
      if(byte_count == 3){
        read=false;
        byte_count=0;
        digitalWrite(LED_BUILTIN, LOW);
        for(int i=0; i<8; i++){
          Serial.print(((i%2) ? 0xF : 0x0), HEX);
        }
        Serial.println("");
      }
    }

    if(byte==87){
      write=true;// 'W'
      digitalWrite(LED_BUILTIN, HIGH);
    }
    else if(byte==82){
      read=true;// 'R'
      digitalWrite(LED_BUILTIN, HIGH);
    }
  }
}    
 