module fp_adder(clkfast,S1,sum,state_led,over,under, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, GPIO_1, toArduino);             
  reg [15:0]inp; /////////////////////////////////////////// input
  input clkfast;
  input [1:0] S1;
  output [15:0]sum;
  output reg [1:0] state_led =0;
  output reg over,under;
  output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	output [15:0] LEDR;
	output reg [1:0] toArduino;
	inout [7:0] GPIO_1;

  reg f_over,f_under,fover;
  reg a;
  reg x,x_1,x_2,x_3,x_4,x_5,x_6,x_7;
  reg screen_clear;
  reg s,s_1,s_2;
  
  reg [15:0] display_word;
  
 wire new_key;					// turned on when new key is read; automatically turned off
 wire [3:0] new_key_char;		// index of new key
  

  
  reg [1:0] count = 0; //////////////////// state transitioning.
  reg [4:0]exp1,exp2,exp,exp_3,exp_4,exp_5,exp3,exp4,exp_6,exp5,exp_7,exp6,exp7,exp_2,exp_8,exp8;
  reg [12:0]frac1,frac2,frac_1,frac_2;
  reg [4:0]exp_diff;
  
  reg sig1,sig2,sig1_1,sig2_1,sig2_2,sig1_2;
  reg [15:0]sum1,sum_1;
  
  reg [14:0]number1,number2;
  
  reg [14:0]fsum,fsum_1;  
  reg [14:0]add,add_1,add2;

  reg [14:0]num1,num2;
  
  reg[12:0]store,store_1,store_2,store2,store3,store_3;
  
  reg sign,sign_1,sign_2,sign_3,sign_4,sign_5,sign_6,sign_7;
  reg[4:0] n,n_1;
  
  wire [3:0] binary_char;
  
  reg z,z_1;
  reg start_input = 0;
 
 reg pushout,pushout_1,pushout_2,pushout_3,pushout_4,pushout_5,pushout_6,pushout_7;
 reg pushout_8,pushout_9,pushout_10,pushout_11;
   
  assign sum=pushout_10?(x_7?{sign_7,exp_8,store3[11:2]}:{sign_7,exp_8,store3[12:3]}):16'd0; //////////// display on 7 segment. display on 7 segment. 

//initial count<=0;


clock_dividertest cd (clkfast, clk);
referenceKeypad k1(LEDR, GPIO_1, clk, new_key, new_key_char);
//display d1(new_key, new_key_char, screen_clear, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
char_to_binary cb1(new_key, new_key_char, binary_char);
display_vector dv1(display_word,	new_key, screen_clear,
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5
);

  
  always@(posedge clk)
    begin
      if(S1 == 2'b00)
       begin
        // $display("reset at time %d",$time); ///////////// arduino 
		  screen_clear<=0;
         count<=2'b00;
         over<=0;
         f_under<=0;
         fsum<=0;
         num1<=0;
         num2<=0;
         sig1<=0;
         sig2<=0;
         a<=0;
         n<=0;
         pushout<=1;
         pushout_1<=0;pushout_2<=0;pushout_3<=0;pushout_4<=0;pushout_5<=0;pushout_6<=0;pushout_7<=0;pushout_8<=0;
         pushout_9<=0;pushout_10<=0;pushout_11<=0;
         sum1<=0;
         add2<=0;
			toArduino<=2'b00;
			
			inp <= 15'b0;
			//x<=0;
         
         count<=count+1; 
			state_led<=2'b00;
       end
      else if(S1 == 2'b01)
       begin
         //$display("input1 is %h at time %d",inp,$time); ///////////// arduino display
         screen_clear<=1;
			
			if(start_input==0) begin
				inp <= 15'b0;
			end
			if (new_key) begin
				start_input<=1;
				inp <= {inp[11:0], binary_char[3:0]};
			end
			
			display_word <= inp;
			sig1<= inp[15];
         exp1<= inp[14:10];
         frac1[11:0]<= {inp[9:0],2'b00};
         count<=count+1; 
        
         
         if(inp==16'd0)
           frac1[12]<=0;
         else 
           frac1[12]<=1;
         
         pushout_1<=pushout;
			state_led<=2'b01;
			toArduino<=2'b01;
       end
      
      else if(S1 == 2'b11)
       begin
         //$display("input2 is %h at time %d",inp,$time); ///////////// arduino display
         screen_clear<=1;
			if(start_input==1) begin
				inp <= 15'b0;
			end
			
			
			if (new_key) begin
				start_input<=0;
				inp <= {inp[11:0], binary_char[3:0]};
			end
			display_word <= inp;
			
			sig2<= inp[15];
         exp2<= inp[14:10];
         frac2[11:0]<={inp[9:0],2'b00};
         count<=count+1; 
         
         
         if(inp==16'd0)
           frac2[12]<=0;
         else 
           frac2[12]<=1;
         
         pushout_2<=pushout_1;
			state_led<=2'b10;
			toArduino<=2'b10;
       end   
        
      else if(S1 == 2'b10)
         begin    
            // $display("FPA sum at time %d",$time);/////////////////////// arduino display.
             display_word <= sum;
				 screen_clear<=1;
				 count<=count+1;
             a<=1;
            pushout_3<=pushout_2;
				state_led<=2'b11;
				toArduino<=2'b11;
         end

		
      else
        //$display("press switch for next state");
    over<=0;
         
      num1<=number1;
      num2<=number2;
      pushout_4<=pushout_3;
      exp_2<=exp;
		x_1<=x;
      sign_1<=sign;
 
 //#1 $display("num1 is %b num2 is %b, exp_2 is %b",num1,num2,exp_2);
      
      fsum<=fsum_1;
      exp_3<=exp_2;
      pushout_5<=pushout_4;
		x_2<=x_1;
      sign_2<=sign_1;
   // #1 $display("fsum is %b and exp_3 is %b",fsum,exp_3);
      
      
      add<=add_1;
      //sign<=sign_1;
      pushout_6<=pushout_5;
      exp_4<=exp_3;
		x_3<=x_2;
      sign_3<=sign_2;
// #1 $display("add is is %b and sign is %b exp_4 is %b",add,sign_1,exp_4); 
     
      
      fover<=f_over;
      exp_5<=exp_4;
      //sign_2<=sign_1; 
      add2<=add; 
      pushout_7<=pushout_6;
      x_4<=x_3;
      sign_4<=sign_3;
  // #1 $display("fover is is %b and sign is %b exp_5 is %b",fover,sign_2,exp_5);
  // #1 $display("add2 is is %b",add2); 
       
      store<=store_1;
      exp_6<=exp6;
      sign_5<=sign_4;
      pushout_8<=pushout_7;
      x_5<=x_4;
    // #1 $display("store is is %b and sign is %b exp_4 is %b",store,sign_3,exp_6); 
      
      
      store2<=store_2;
      n<=n_1;
      z<=z_1;
      exp_7<=exp7;
      sign_6<=sign_5;
      pushout_9<=pushout_8;
		x_6<=x_5;
    // #1 $display("store2 is is %b and sign_4 is %b exp_7 is %b",store2,sign_4,exp_7);   
      
  
      
      store3<=store_3;
      exp_8<=exp8;
      sign_7<=sign_6;
      pushout_10<=pushout_9;
      x_7<=x_6;
    // #1 $display("store3 is is %b and sign_5 is %b exp_8 is %b",store3,sign_5,exp_8);
      #1 $display("sum is %h at time %d",sum,$time);
   // #1 $display("store3 is is %b and sign_5 is %b exp_8 is %b",store3,sign_5,exp_8);

		

           
end


 always@(*)
        begin
          if(a)
           if(exp1==exp2) begin
             $display("equal exponents");
                 exp=exp1; 
                 frac_1=frac1;
                  frac_2=frac2;
              if(frac_1>frac_2)
                sign=sig1;
              else
                sign=sig2;
            end
           
             else if(exp1<exp2)
                   begin
               
                  frac_1=frac1>>(exp2-exp1);
                  exp=exp2;
                  frac_2=frac2;
						sign=sig2; 
                 end
           
             else 
                 begin
                  
                  frac_2=frac2>>(exp1-exp2);
                  exp=exp1;
                  frac_1=frac1;
                  sign=sig1;  
                 end   
           
            
          number1 = (sig1==0)?{2'b00,frac_1}:(~{2'b00,frac_1}+1); 
          number2 = (sig2==0)?{2'b00,frac_2}:(~{2'b00,frac_2}+1);
          
          if(sig1==0&&sig2==0)
              x=0;
            else if(sig1&&sig2)
              x=0;
            else
              x=1;  
        
         
          fsum_1=num1+num2;
          
          
          add_1=(fsum[14]==0)?fsum:~fsum +1;
//          sign_1=fsum[14];
          
 
         f_over=add[14]^add[13];
          ///////////// exp_4=exp_3
          
         if(fover==1'b0)
           begin
            store_1=add2[12:0];
            exp6=exp_5;
           end
         else 
           begin
            store_1=add2[13:1];
            exp6=exp_5+1;
           end
         
        if(store==13'b0)
          begin
           exp7=5'd0;
           store_2=store[11:2];    
            z_1=0;
          end
        else 
         begin
           if(exp_6==5'd0) 
            begin
             under=1; 
             store_2={store[11:2],3'b000};
             exp7=exp_6;
              z_1=0;
              n_1=0;
            end
           else if(store[12]==1'b1)
            begin
             // $display("yes");
             store_2={store[11:2],3'b000}; 
             exp7=exp_6; 
              z_1=0;
              n_1=0;
            end
          else
           begin
 
            exp7=exp_6;
            store_2=store;  
             
             
           n_1=(!store[12:6])?(((!store[5:1])?5'd12:((!store[5:2])?5'd11:((!store[5:3])?5'd10:((!store[5:4])?5'd9:((!store[5])?5'd8:5'd7)))))): (!store[12:9])?((!store[8:7])?5'd6:((!store[8])?5'd5:5'd4)):((!store[12:10])?5'd3:((!store[12:11])?5'd2:((!store[12])?5'd1:5'd0)));
               
             
             z_1=1'd1; 
               
        end
         end    
          if(z)
            begin
              store_3=store2<<n;
              exp8=exp_7-n;
            end
          else begin
            store_3=store2;
            exp8=exp7; end
        end
  

   
endmodule 




















module referenceKeypad(
	LEDR,
	GPIO_1,
	clk,
	new_key,
	new_key_char
);

// Keypad Reading

input clk;
output [15:0] LEDR;
inout [7:0] GPIO_1;
reg reset = 1;
wire myclock;

// Custom clock @ 1 kHz
//clock_dividertest cd (reset, CLOCK_50, myclock);

reg [3:0] GOUT = 4'bzzzz;	// GPIO outputs
reg [15:0] OUT;				// LED outputs
reg [7:0] index;				// index of read row
reg [1:0] status;				// 0 = preparing to read a row, 1 = reading row, 2 = end of read
output reg new_key;					// turned on when new key is read; automatically turned off
output reg [3:0] new_key_char;		// index of new key

assign GPIO_1 = { GOUT, 4'bzzzz };  // GPIO_1 used bidirectional
assign LEDR[15:0] = OUT;				// only some LEDs are used to show pushed buttons

// Reset
always@(posedge clk) begin
	if (reset)
		reset = 1'b0;
end

/* Custom clocks at 1 kHz.
 * This "loop" scans keypad horizontally, each line in every
 * cycle. Each line scan is divided into 3 patrs:
 *  1) Set current line output to 0 (groud).
 *  2) Read inputs.
 *  3) Set current line output to 1 (VCC).
 */
always@(posedge clk) begin
	if (status == 0) begin
		// set current line output to 0 (ground)
		GOUT[index] <= 0;
		status <= 1;		
	end else if (status == 1) begin
	
		// detect key press		
		if ((!GPIO_1[0]) && (OUT[4*index] != !GPIO_1[0])) begin
			new_key_char <= 4*index;
			new_key <= 1;
		end
		if ((!GPIO_1[1]) && (OUT[4*index+1] != !GPIO_1[1])) begin
			new_key_char <= 4*index+1;
			new_key <= 1;
		end
		if ((!GPIO_1[2]) && (OUT[4*index+2] != !GPIO_1[2])) begin
			new_key_char <= 4*index+2;
			new_key <= 1;
		end
		if ((!GPIO_1[3]) && (OUT[4*index+3] != !GPIO_1[3])) begin
			new_key_char <= 4*index+3;
			new_key <= 1;
		end
		
		// change state of LEDs
		OUT[4*index] <= !GPIO_1[0];
		OUT[4*index+1] <= !GPIO_1[1];
		OUT[4*index+2] <= !GPIO_1[2];
		OUT[4*index+3] <= !GPIO_1[3];
		status <= 2;
	end else begin
		// no output to GPIO
		GOUT <= 4'bzzzz;
		
		if (index < 3)
			// keypad not yet scanned -> scan new line
			index <= index + 1;
		else
			// whole keypad scanned -> new scan
			index <= 0;
			
		status <= 0;
		new_key <= 0;	// reset key press flag
	end;
end

endmodule






module char_to_binary(input new_key, input [3:0] new_key_char, output reg [3:0] binary_char);
always@(posedge new_key) begin
	case (new_key_char) 
		 0 : binary_char <= 4'b0001; // 1
		 1 : binary_char <= 4'b0010; // 2
		 2 : binary_char <= 4'b0011; // 3
		 3 : binary_char <= 4'b1010; // A
		 4 : binary_char <= 4'b0100; // 4
		 5 : binary_char <= 4'b0101; // 5
		 6 : binary_char <= 4'b0110; // 6
		 7 : binary_char <= 4'b1011; // b
		 8 : binary_char <= 4'b0111; // 7
		 9 : binary_char <= 4'b1000; // 8
		10 : binary_char <= 4'b1001; // 9
		11 : binary_char <= 4'b1100; // C
		13 : binary_char <= 4'b0000; // 0
		15 : binary_char <= 4'b1101; // d
	endcase
end
endmodule






module display(
	new_key,
	new_key_char,
	screen_clear,
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5
);

// ----------------------------------------------------------------------------
// Segment Display
input new_key,screen_clear;					// turned on when new key is read; automatically turned off
input [3:0] new_key_char;		// index of new key

output [6:0] HEX0;
output [6:0] HEX1;
output [6:0] HEX2;
output [6:0] HEX3;
output [6:0] HEX4;
output [6:0] HEX5;


reg [6:0] hex0 = 127;
reg [6:0] hex1 = 127;
reg [6:0] hex2 = 127;
reg [6:0] hex3 = 127;
reg [6:0] hex4 = 127;
reg [6:0] hex5 = 127;


assign HEX0 = hex0;
assign HEX1 = hex1;
assign HEX2 = hex2;
assign HEX3 = hex3;
assign HEX4 = hex4;
assign HEX5 = hex5;


/* Insert new char at the end of display
 * and push all the other characters left.
 * This block is run when "new_key" flag is set (<=> new key was just pressed).
 */

always@(posedge new_key) begin

if (screen_clear==1) begin
	// Push characters left.

//	hex5 <= hex4;
//	hex4 <= hex3;
	hex3 <= hex2;
	hex2 <= hex1;
	hex1 <= hex0;

	// Show a new character.
	case (new_key_char) 
		 0 : hex0 <= ~7'b0000110; // 1
		 1 : hex0 <= ~7'b1011011; // 2
		 2 : hex0 <= ~7'b1001111; // 3
		 3 : hex0 <= ~7'b1110111; // A
		 4 : hex0 <= ~7'b1100110; // 4
		 5 : hex0 <= ~7'b1101101; // 5
		 6 : hex0 <= ~7'b1111101; // 6
		 7 : hex0 <= ~7'b1111100; // b
		 8 : hex0 <= ~7'b0000111; // 7
		 9 : hex0 <= ~7'b1111111; // 8
		10 : hex0 <= ~7'b1101111; // 9
		11 : hex0 <= ~7'b0111001; // C
		13 : hex0 <= ~7'b0111111; // 0
		15 : hex0 <= ~7'b1011110; // d
	endcase
end

else if (screen_clear == 0) begin 
hex0 <= 127;
hex1 <= 127;
hex2 <= 127;
hex3 <= 127;
hex4 <= 127;
hex5 <= 127;
end



end

endmodule










module display_vector(
	display_word,
	new_key,
	screen_clear,
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5
);

// ----------------------------------------------------------------------------
// Segment Display
input screen_clear,new_key;					// turned on when new key is read; automatically turned off
input [15:0] display_word;		// index of new key

output [6:0] HEX0;
output [6:0] HEX1;
output [6:0] HEX2;
output [6:0] HEX3;
output [6:0] HEX4;
output [6:0] HEX5;


reg [6:0] hex0 = 127;
reg [6:0] hex1 = 127;
reg [6:0] hex2 = 127;
reg [6:0] hex3 = 127;
reg [6:0] hex4 = 127;
reg [6:0] hex5 = 127;


assign HEX0 = hex0;
assign HEX1 = hex1;
assign HEX2 = hex2;
assign HEX3 = hex3;
assign HEX4 = hex4;
assign HEX5 = hex5;


/* Insert new char at the end of display
 * and push all the other characters left.
 * This block is run when "new_key" flag is set (<=> new key was just pressed).
 */

always@(*) begin

if (screen_clear==1) begin
	// Push characters left.


//	hex3 <= hex2;
//	hex2 <= hex1;
//	hex1 <= hex0;

	// Show a new character.
	case (display_word[3:0]) 
		 4'b0001 : hex0 <= ~7'b0000110; // 1
		 4'b0010 : hex0 <= ~7'b1011011; // 2
		 4'b0011 : hex0 <= ~7'b1001111; // 3
		 4'b1010 : hex0 <= ~7'b1110111; // A
		 4'b0100 : hex0 <= ~7'b1100110; // 4
		 4'b0101 : hex0 <= ~7'b1101101; // 5
		 4'b0110 : hex0 <= ~7'b1111101; // 6
		 4'b1011 : hex0 <= ~7'b1111100; // b
		 4'b0111 : hex0 <= ~7'b0000111; // 7
		 4'b1000 : hex0 <= ~7'b1111111; // 8
		 4'b1001 : hex0 <= ~7'b1101111; // 9
		 4'b1100 : hex0 <= ~7'b0111001; // C
		 4'b0000 : hex0 <= ~7'b0111111; // 0
		 4'b1101 : hex0 <= ~7'b1011110; // d
	endcase
	
	case (display_word[7:4]) 
		 4'b0001 : hex1 <= ~7'b0000110; // 1
		 4'b0010 : hex1 <= ~7'b1011011; // 2
		 4'b0011 : hex1 <= ~7'b1001111; // 3
		 4'b1010 : hex1 <= ~7'b1110111; // A
		 4'b0100 : hex1 <= ~7'b1100110; // 4
		 4'b0101 : hex1 <= ~7'b1101101; // 5
		 4'b0110 : hex1 <= ~7'b1111101; // 6
		 4'b1011 : hex1 <= ~7'b1111100; // b
		 4'b0111 : hex1 <= ~7'b0000111; // 7
		 4'b1000 : hex1 <= ~7'b1111111; // 8
		 4'b1001 : hex1 <= ~7'b1101111; // 9
		 4'b1100 : hex1 <= ~7'b0111001; // C
		 4'b0000 : hex1 <= ~7'b0111111; // 0
		 4'b1101 : hex1 <= ~7'b1011110; // d
	endcase
	
	case (display_word[11:8]) 
		 4'b0001 : hex2 <= ~7'b0000110; // 1
		 4'b0010 : hex2 <= ~7'b1011011; // 2
		 4'b0011 : hex2 <= ~7'b1001111; // 3
		 4'b1010 : hex2 <= ~7'b1110111; // A
		 4'b0100 : hex2 <= ~7'b1100110; // 4
		 4'b0101 : hex2 <= ~7'b1101101; // 5
		 4'b0110 : hex2 <= ~7'b1111101; // 6
		 4'b1011 : hex2 <= ~7'b1111100; // b
		 4'b0111 : hex2 <= ~7'b0000111; // 7
		 4'b1000 : hex2 <= ~7'b1111111; // 8
		 4'b1001 : hex2 <= ~7'b1101111; // 9
		 4'b1100 : hex2 <= ~7'b0111001; // C
		 4'b0000 : hex2 <= ~7'b0111111; // 0
		 4'b1101 : hex2 <= ~7'b1011110; // d
	endcase
	
	
	case (display_word[15:12]) 
		 4'b0001 : hex3 <= ~7'b0000110; // 1
		 4'b0010 : hex3 <= ~7'b1011011; // 2
		 4'b0011 : hex3 <= ~7'b1001111; // 3
		 4'b1010 : hex3 <= ~7'b1110111; // A
		 4'b0100 : hex3 <= ~7'b1100110; // 4
		 4'b0101 : hex3 <= ~7'b1101101; // 5
		 4'b0110 : hex3 <= ~7'b1111101; // 6
		 4'b1011 : hex3 <= ~7'b1111100; // b
		 4'b0111 : hex3 <= ~7'b0000111; // 7
		 4'b1000 : hex3 <= ~7'b1111111; // 8
		 4'b1001 : hex3 <= ~7'b1101111; // 9
		 4'b1100 : hex3 <= ~7'b0111001; // C
		 4'b0000 : hex3 <= ~7'b0111111; // 0
		 4'b1101 : hex3 <= ~7'b1011110; // d
	endcase
end

else if (screen_clear == 0) begin 
hex0 <= 127;
hex1 <= 127;
hex2 <= 127;
hex3 <= 127;
hex4 <= 127;
hex5 <= 127;
end



end

endmodule









module clock_dividertest (clock_in, clock_out);
	parameter input_hz = 50000;
	parameter output_hz = 1;
	parameter in_out_ratio = input_hz / output_hz; // can process upmost 2^20 = 1048576 ratio

	input clock_in;
	output clock_out;
	reg clock_out;
	reg [19:0] internal_count;

	always @(posedge clock_in) begin
		if (internal_count == (in_out_ratio - 1)) begin
			internal_count <= 20'b0;
			clock_out <= 1'b1; // time to shoot a rising edge
		end
		else if (internal_count == (in_out_ratio/2 - 1)) begin
			clock_out <= 1'b0; 	// holding time passed
			internal_count <= internal_count + 1;
		end
		else begin
			internal_count <= internal_count + 1;
		end
	end
endmodule