module MatrixKeypad (
  input            clk,
  input            reset,       
  input      [3:0] col,
  output reg [3:0] row,
  output reg [7:0] testled,
  output reg [6:0] sevenseg = 7'b1111111
  
);

	reg [7:0] keyCode;
	reg [19:0] count;
	reg clk_out;
	
//	keyCode <= 8'b0;




always @(posedge clk) begin
   count <= count + 1;
   if(count == 1000000)
   begin
      count<=0;
      clk_out <= !clk_out;
   end
end







  always @(posedge clk_out) begin
    if (reset) begin
      /* Reset all register variables.
       * Not strictly necessary for synthesis,
       * but the simulator will require it.
       */
      row <= 4'b1000;
      
      
    end else begin
      /* If any column is active in the current row,
       * output the row and column pattern as a keyCode,
       * and assert keyValid. Pause the scanning as long
       * as the key is held down.
       */
		 
      if (col != 4'b0000) begin
        keyCode <= {row, col};
		  testled <= keyCode;		  
		  
		  
      end else begin
        
        /* Scan the matrix, one row per clock period
         */
        case (row)
          4'b1000: row <= 4'b0100;
          4'b0100: row <= 4'b0010;
          4'b0010: row <= 4'b0001;
          4'b0001: row <= 4'b1000;
          default: row <= 4'b1000;
        endcase
      end
		
//		if (keyCode < 8'b00011000) begin
//			sevenseg <= 7'b0010010;
//		end 
//		else begin
//			sevenseg <= 7'b0010010;
//		end
		
		
		
		
//		case (keyCode)
//			8'b00010001: sevenseg = 7'b1001111; //1
//			8'b00010010: sevenseg = 7'b0010010;
//			8'b00010100: sevenseg = 7'b0000110;
//			8'b00011000: sevenseg = 7'b0001000;
//			
//			8'b00100001: sevenseg = 7'b1001100;
//			8'b00100010: sevenseg = 7'b0100100;
//			8'b00100100: sevenseg = 7'b0100000;
//			8'b00101000: sevenseg = 7'b1100000;
//			
//			8'b01000001: sevenseg = 7'b0001111;
//			8'b01000010: sevenseg = 7'b0000000;
//			8'b01000100: sevenseg = 7'b0000100;
//			8'b01001000: sevenseg = 7'b0110001;
//			
//			8'b10000001: sevenseg = 7'b0000001;
//			8'b10000010: sevenseg = 7'b0000001;
//			8'b10000100: sevenseg = 7'b0000001;
//			8'b10001000: sevenseg = 7'b1000010;
//			
//			default: sevenseg = 7'b1110011;
//		endcase
    end
  end

endmodule 



