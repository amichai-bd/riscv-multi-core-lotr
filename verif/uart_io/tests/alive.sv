      test_undone= 1'b1;
      $display("%s", {50{"*"}});
      $display("*** UART playground testbench");    
      $display("%s", {50{"*"}});
      delay(10); init();
      delay(10); reset();
      delay(10); enable_clk();
      delay(10); reset();
      C2F_response('0, RD_RSP, '0, '0, '0);

      fork
         // PROCCESS-1
         begin
            forever begin
               @(posedge interrupt);
               print("UART interrupt caught $$$$");
            end 
         end

         // PROCCESS-2
         begin
            for(int i=0; i<N_WRITE_TRANSFERS; i++) begin
               Write_transfer_buffer[i][ADDR] = $random();
               Write_transfer_buffer[i][DATA] = $random();
            end
            for(int i=0; i<N_WRITE_TRANSFERS; i++) begin
               //Terminal_Write(Write_transfer_buffer[i][ADDR], Write_transfer_buffer[i][DATA]);
               Terminal_Write(32'h03002018,32'hffffffff);
               uart_bit_wait(10);
               Terminal_Read(32'h03002018);
            end
            test_undone = 1'b0;
         end
      join_any
      uart_bit_wait(10);
      $display("%s", {50{"*"}});
      $display("EOT - alive | reached end of test");
      $display("%s", {50{"*"}});
      $finish(1);