//C2F_Req(opcode ,   address    ,   data  , Thread    );
delay(1);
C2F_Req(WR ,   32'h0300_1111    ,   32'h1111_1111  , 2'b01);
C2F_Req(WR ,   32'h0300_2222    ,   32'h2222_2222  , 2'b11);
delay(5);
C2F_Req(RD ,   32'h0300_1111    ,   32'hxxxx_xxxx  , 2'b00);
delay(20);
//RingRspIn(requestor     , opcode ,   address     ,   data       );
RingRspIn(10'b0000001000 , RD_RSP , 32'h0300_1111,   32'h3333_3333 );
