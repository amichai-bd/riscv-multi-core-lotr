# RC Design - Ring Controller  
> TODO - add "Catch-fraze"  
## RC General Description  
> TODO - add General Description  

# DATA-PATH  
## Core Request   
RD/WR Request from Core. A Load/Store from a Cores thread is sent to the Fabric  
###  The Data Path of Request from Core to Fabric.  
*    Q500) C2F_Req500H -> C2F_NextBufferQnnnH  
*    Q501) C2F_BufferQnnnH-> C2F_ReqQ501H -> RingoutputQ501H  
*    Q502) RingoutputQ502H  

## Memory Response  
RD_RSP from Memory with Data.  
A Read request that originated from Ring input to the Local memory - Read Response back to Fabric the Data  
### The Data Path of a Read Response from Local Memory to Fabric.
*    Q500) F2C_Rsp500H -> F2C_NextBufferQnnnH  
*    Q501) F2C_BufferQnnnH-> F2C_RspQ501H -> RingoutputQ501H  
*    Q502) RingoutputQ502H   

## Ring Input
Ring Input has 3 Data Paths option:  
### 1. Pass through (no Alocation in Buffers)  
*    Q500) RingInputQ500H   
*    Q501) RingInputQ501H -> RingoutputQ501H   
*    Q502) RingoutputQ502H  
### 2. RD/WR Req to Local Memory (Alocting F2C Buffer entry)  
*    Q500) RingInputQ500H  
*    Q501) RingInputQ501H  -> F2C_NextBufferQnnnH  
*    Q502) F2C_BufferQnnnH -> F2C_ReqQ502H  
### 3. RD_RSP Response to a Core Request  (Alocting C2F Buffer entry)  
*    Q500) RingInputQ500H   
*    Q501) RingInputQ501H  -> C2F_NextBufferQnnnH   
*    Q502) C2F_BufferQnnnH -> C2F_RspQ502H  

![image](https://user-images.githubusercontent.com/81047407/116852511-1ad25680-abfd-11eb-822b-fa25fe11d6be.png)
