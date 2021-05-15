#include <LiquidCrystal.h>

// initialize the library by associating any needed LCD interface pin
// with the arduino pin number it is connected to
const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
const int f1=6,f2=7;
  int fpga1=0;
  int fpga2=0;
  int once=1;

LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

void setup() {
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  pinMode(f1, INPUT);  
  pinMode(f2, INPUT);  

  
  // Print a message to the LCD.
  
}

void loop() {
  // set the cursor to column 0, line 1
  // (note: line 1 is the second row, since counting begins with 0):
  fpga1 = digitalRead(f1);
  fpga2 = digitalRead(f2);
  
  if (fpga1==0 and fpga2==0){
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("EE 271 FP Adder");
      lcd.setCursor(0, 1);
      lcd.print("Reset");
      delay(1000);
    }
    

    if (fpga1==1 and fpga2==0){
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("EE 271 FP Adder");
      lcd.setCursor(0, 1);
      lcd.print("Input 1");
      delay(1000);
    }

    if (fpga1==0 and fpga2==1){
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("EE 271 FP Adder");
      lcd.setCursor(0, 1);
      lcd.print("Input 2");
      delay(1000);
    }

    if (fpga1==1 and fpga2==1){
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("EE 271 FP Adder");
      lcd.setCursor(0, 1);
      lcd.print("FP Calc");
      delay(1000);
    }
  
  // print the number of seconds since reset:
  
}
