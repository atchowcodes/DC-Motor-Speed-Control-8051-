ORG     0000H  
 MOV     SP, #70H  
 MOV     PSW, #00H   
;-------------------------------------------------------------  
 RS EQU P1.1  
 EN EQU P1.2  
LED EQU P1.6 ; Define BUZZER pin as P1.5
BUZ EQU P1.5
;-------------------------------------------------------------  
INITIALIZATION:  
 MOV  P0, #00H  
 MOV  P1, #00H  
 MOV  P2, #00H  
 MOV  P3, #0FEH   
 CLR  P1.6
 CLR  P1.5
;-------------------------------------------------------------  
DATABASE:  
 MOV     40H, #'1' ;PASSWORD  
 MOV     41H, #'2'  
 MOV     42H, #'3'  
 MOV     43H, #'A'  
 MOV     44H, #'B'  
 MOV     45H, #'C'  
;--------------------------------------------------------------  
LCD_INIT:  
 MOV  R2, #38H ;INITIALIZING LCD, 2 LINES, 5X7 MATRIX  
 ACALL  COMMAND  ;CALLING COMMAND SUBROUTINE  
 MOV  R2, #0EH ;DISPLAY ON, CURSOR ON  
 ACALL  COMMAND  
 MOV  R2, #01H ;CLEARING SCREEN  
 ACALL  COMMAND  
 MOV  A,#06H   ;INCREMENT CURSOR POSITION  
 ACALL  COMMAND  
 MOV  R2, #80H ;CURSOR AT START OF 1ST LINE  
 ACALL  COMMAND  
 MOV  A,#3CH     
 ACALL  COMMAND  
   
 MOV  DPTR,#START1    ;Display Starting message  
 ACALL LCD_PRINT  ;Subroutine for displaying in LCD  
 MOV  DPTR,#START2  
 ACALL LCD_PRINT  
   
;Password Part--------------------------------------------------  
;---------------------------------------------------------------  
PASSWORD:  
 MOV R0, #30H  
 MOV  R1, #40H  
 MOV R2, #0H  
   
 MOV  R3, #6  ;password 6 digits  
 MOV  R2, #01H ;clear the screen  
 ACALL  COMMAND  
 MOV DPTR, #PASS_MSG ;Prompt for entering password  
 LCALL LCD_PRINT  
  
 
 
 
 
;KEYPAD INPUT---------------------------------------------------  
;SCANNING COLUMNS-----------------------------------------------  
  
L1:   
 JNB  P3.0, C1 ;Scanning each column for keypress   
 JNB  P3.1, C2  
 JNB  P3.2, C3  
 JNB  P3.3, C4  
 SJMP  L1   
;---------------------------------------------------------------  
   
;---------------------------------------------------------------   
;SCANNING FOR INPUT IN COLUMN 1---------------------------------------------  
C1:  
 JNB  P3.4, JUMP_TO_1  ;Number 1 is pressed   
 JNB  P3.5, JUMP_TO_2  ;Number 2 is pressed  
 JNB  P3.6, JUMP_TO_3   
 JNB  P3.7, JUMP_TO_A   
 SETB  P3.0   ;for checking the next column  
 CLR  P3.1   ;JNB 3.0, C1 is not satisfied   
 SJMP  L1   ;So, execute next line--check C2  
;SCANNING FOR INPUT IN COLUMN 2---------------------------------------------  
C2:  
 JNB  P3.4, JUMP_TO_4  ;These are ordered same as the   
 JNB  P3.5, JUMP_TO_5  ;physical keypad columns  
 JNB  P3.6, JUMP_TO_6   
 JNB  P3.7, JUMP_TO_B  
 SETB  P3.1  
 CLR  P3.2  
 SJMP  L1  
;SCANNING FOR INPUT IN COLUMN 3---------------------------------------------  
C3:  
 JNB  P3.4, JUMP_TO_7  
 JNB  P3.5, JUMP_TO_8   
 JNB  P3.6, JUMP_TO_9   
 JNB  P3.7, JUMP_TO_C   
 SETB  P3.2  
 CLR  P3.3  
 SJMP  L1  
 
 
;SCANNING FOR INPUT IN COLUMN 4---------------------------------------------  
C4:  
 JNB  P3.4, JUMP_TO_F   
 JNB  P3.5, JUMP_TO_0   
 JNB  P3.6, JUMP_TO_E   
 JNB  P3.7, JUMP_TO_D   
 SETB  P3.3  
 CLR  P3.0  
 LJMP  L1  
   
;---------------------------------------------------------------  
JUMP_TO_0:  LJMP  NUM_0 ;JNB gives a short jump  
JUMP_TO_1:  LJMP  NUM_1 ;the numbers will be out of range  
JUMP_TO_2:  LJMP  NUM_2 ;so, this part is used to redirect  
JUMP_TO_3:  LJMP  NUM_3 ;using LJMP  
JUMP_TO_4:  LJMP  NUM_4  
JUMP_TO_5:  LJMP  NUM_5  
JUMP_TO_6:  LJMP  NUM_6  
JUMP_TO_7:  LJMP  NUM_7  
JUMP_TO_8:  LJMP  NUM_8  
JUMP_TO_9:  LJMP  NUM_9  
JUMP_TO_A:  LJMP  NUM_A  
JUMP_TO_B:  LJMP  NUM_B  
JUMP_TO_C:  LJMP  NUM_C  
JUMP_TO_D:  LJMP  NUM_D  
JUMP_TO_E:  LJMP  NUM_E  
JUMP_TO_F:  LJMP  NUM_F  
  
;---------------------------------------------------------------  
NUM_0:    ;Number 0 is pressed  
 JNB  P3.5,NUM_0 ;Wait for key release   
 ACALL  ASTERISK ;PRINT '*'     
 MOV @R0,#'0' ;Store '0' in RAM location 30H  
 INC R0  ;R0 = 31H, for storing the next input  
 DEC R3  ;1 digit has been entered  
 CJNE    R3, #0, L2 ;If R3 is not 0, take another input  
 LJMP  OUT  
  
NUM_1:    ;number 1 is pressed  
 JNB  P3.4,NUM_1     
 ACALL  ASTERISK  
 MOV     @R0, #'1' ;Store the input in RAM    
 INC     R0  ;go to next RAM location  
 DEC  R3  ;for counting the number of i/p  
 CJNE    R3, #0, L2 ;max number of input reached?NO-take more   
 LJMP  OUT  ;Yes-jump to label 'OUT'  
  
NUM_2:     
 JNB  P3.5,NUM_2  
 ACALL  ASTERISK  
 MOV     @R0, #'2'  
 INC     R0  
 DEC R3  
 CJNE    R3, #0, L2 ;L2 is used to redirect to L1  
 LJMP  OUT  
  
NUM_3:    
 JNB  P3.6,NUM_3  
 ACALL  ASTERISK  
 MOV     @R0, #'3'  
 INC     R0  
 DEC R3  
 CJNE    R3, #0, L2 ;L1 is out of range, so L2 is used to 
;redirect  
 LJMP  OUT  
  
NUM_4:    
 JNB  P3.4,NUM_4  
 ACALL  ASTERISK  
 MOV     @R0, #'4'  
 INC     R0  
 DEC R3  
 CJNE    R3, #0, L2   
 LJMP  OUT  
  
NUM_5:    
 JNB  P3.5,NUM_5  
 ACALL  ASTERISK  
 MOV     @R0, #'5'  
 INC     R0   
 DEC  R3  
 CJNE    R3, #0, L2  
 LJMP  OUT  
  
NUM_6:    
 JNB  P3.6,NUM_6  
 ACALL  ASTERISK  
 MOV     @R0,#'6'  
 INC     R0  
 DEC R3  
 CJNE    R3, #0, L2  
 LJMP  OUT  
  
NUM_7:    
 JNB  P3.4,NUM_7  
 ACALL  ASTERISK   
 MOV     @R0, #'7'  
 INC     R0  
 DEC  R3  
 CJNE    R3, #0, L2  
 LJMP  OUT       
   
;---------------------------------------------------------------  
L2: LJMP L1   ;redirecting to L1,   
    ;placed here for maximum coverage  
;---------------------------------------------------------------  
  
NUM_8:    
 JNB  P3.5,NUM_8    
 ACALL  ASTERISK  
 MOV     @R0, #'8'  
 INC     R0  
 DEC  R3  
 CJNE    R3, #0, L2  
 LJMP  OUT  
  
NUM_9:    
 JNB  P3.6,NUM_9    
 ACALL  ASTERISK  
 MOV     @R0, #'9'  
 INC     R0  
 DEC R3  
 CJNE    R3, #0, L2  
 LJMP  OUT  
  
NUM_F:   
 JNB  P3.4,NUM_F ;'*' in physical keypad  
 ACALL  ASTERISK  
 MOV     @R0, #'F'  
 INC     R0  
 DEC R3  
 CJNE    R3, #0, L2  
 LJMP  OUT  
  
  
NUM_E:   
 JNB  P3.6,NUM_E ;'#' in physical keypad  
 ACALL  ASTERISK  
 MOV     @R0, #'E'  
 INC     R0   
 DEC R3  
 CJNE    R3, #0, L2  
 LJMP  OUT  
   
NUM_D:    
 JNB  P3.7,NUM_D  
 ACALL  ASTERISK  
 MOV     @R0, #'D'  
 INC     R0   
 DEC  R3  
 CJNE    R3, #0, L2  
 LJMP  OUT  
   
NUM_C:   
 JNB  P3.7,NUM_C  
 ACALL  ASTERISK  
 MOV     @R0, #'C'  
 INC     R0  
 DEC  R3  
 CJNE    R3, #0, L2  
 LJMP  OUT  
  
NUM_B:   
 JNB  P3.7,NUM_B  
 ACALL  ASTERISK  
 MOV     @R0, #'B'  
 INC     R0  
 DEC R3  
 CJNE    R3, #0, L3 ;redirecting the jump to L1  
 LJMP  OUT  
  
NUM_A:   
 JNB  P3.7,NUM_A  
 ACALL  ASTERISK  
 MOV     @R0, #'A'  
 INC     R0  
 DEC R3  
 CJNE    R3, #0, L3    
 LJMP  OUT  
  
L3: LJMP    L1  ;L2 is also beyond short jump reach  
    ;So, redirecting using L3  
      
;---------------------------------------------------------------  
ASTERISK:   ;Displays an '*' on the LCD panel  
 MOV     R2, #'*'  
 ACALL   DISPLAY  ;Display subroutine  
 RET  
  
;LCD display subroutine-----------------------------------------  
  
LCD_PRINT:  
LOOP:   
 CLR A  
 MOVC A, @A+DPTR  
 MOV  R2, A  
 JZ EXIT  ;stop writing when null char is detected  
 ACALL  DISPLAY  ;main display part  
 ACALL  DELAY  ;giving a short delay for LCD  
 INC DPTR  
 LJMP LOOP  
EXIT:  
 MOV  R2, #0C0H ;go to the 2nd line of LCD  
 ACALL  COMMAND  
 RET  
     
;---------------------------------------------------------------  
DISPLAY:  
 MOV  P2, R2  ;subroutine for displaying in LCD  
 SETB  RS  ;RW is grounded in Hardware  
 SETB  EN  
 ACALL  DELAY  
 CLR  EN  
 RET  
;---------------------------------------------------------------  
COMMAND:  
 MOV  P2, R2  ;giving instructions to LCD  
 CLR  RS  
 SETB  EN  
 ACALL  DELAY  
 CLR  EN  
 RET  
;---------------------------------------------------------------  
  
DELAY:  
 MOV  52H, #90 ;50 ms delay (approx)  
D1: MOV  51H, #255   
 DJNZ  51H, $  
 DJNZ  52H, D1  
 RET  
;---------------------------------------------------------------  
;Checking if the i/p part is done-------------------------------  
  
OUT: SJMP AUTH  ;go to verification part  
  
;---------------------------------------------------------------   
AUTH:    
    ACALL   DELAY  
 MOV     R5, #6  ;6 digit password  
 MOV     R0, #30H ;RAM location of the entered info  
 MOV     R1, #40H ;RAM location of the saved info  
 
 
   
NEXT:   
     MOV     A, @R0    
 MOV     B, @R1  
 CJNE    A,B, NOPE ;not same?--wrong password.  
 INC     R0  ;same---carry on  
 INC     R1  
 DJNZ    R5, NEXT ;compare all 9 digits  
;---------------------------------------------------------------  
   
DECISION:           ;password matches  
 MOV  R2, #01H   
 ACALL  COMMAND  
 MOV DPTR, #ACPT_MSG  ;display MOTOR ACTIVE  
 ACALL LCD_PRINT  
 LJMP MOTOR_ROTATION  ;Start Motor part    
   
NOPE:            ;does not match  
 MOV  R2, #01H  
 ACALL  COMMAND  
 MOV DPTR, #DENY_MSG  ;Display 'Wrong Password'  
 ACALL LCD_PRINT  
 MOV DPTR, #TRY_AGN ;Display 'Try Again'  
 ACALL LCD_PRINT  
 LJMP  PASSWORD ;Enter password again  
   
   
;MOTOR PART------------------------------------------------------   
;---------------------------------------------------------------   
MOTOR_ROTATION:  
 SETB  P1.3  ;Input to motor driver  
 CLR P1.4  ;Clockwise direction  
  
;---------------------------------------------------------------  
STARTUP_MOTOR:    
 MOV  R2, #01H  
 ACALL  COMMAND  
 MOV DPTR, #INT_MSG ;print 'ENTER RPM LEVEL'  
 LCALL LCD_PRINT  
 MOV DPTR, #PROMPT1 ;show different controls  
 LCALL LCD_PRINT  
 LCALL DELAY  
 MOV DPTR, #PROMPT2  
 LCALL LCD_PRINT  
   
;keyboard RPM Input Scanning------------------------------------   
;---------------------------------------------------------------  
;SCANNING ALL COLUMN  ------------------------------------------  
ML:  
 JNB  P3.0, CC1 ;logic same as the password part  
 JNB  P3.1, CC2  
 JNB  P3.2, CC3  
 JNB  P3.3, CC4  
 SJMP  ML  
;---------------------------------------------------------------  
;SCANNING COLUMN1 ----------------------------------------------  
CC1:  
 JNB  P3.4, JMP_TO_1   
 JNB  P3.5, JMP_TO_2   
 JNB  P3.6, JMP_TO_3   
 JNB  P3.7, JMP_TO_A   
 SETB  P3.0  
 CLR  P3.1  
 SJMP  ML  
;SCANNING COLUMN2 ---------------------------------------------  
CC2:  
 JNB  P3.4, JMP_TO_4  
 JNB  P3.5, JMP_TO_5   
 JNB  P3.6, JMP_TO_6   
 JNB  P3.7, JMP_TO_B  
 SETB  P3.1  
 CLR  P3.2  
 SJMP  ML  
;SCANNING COLUMN3 ---------------------------------------------  
CC3:  
 JNB  P3.4, JMP_TO_7  
 JNB  P3.5, JMP_TO_8   
 JNB  P3.6, JMP_TO_9   
 JNB  P3.7, JMP_TO_C   
 SETB  P3.2  
 CLR  P3.3  
 SJMP  ML  
;SCANNING COLUMN4 ---------------------------------------------  
CC4:  
 JNB  P3.4, JMP_TO_F   
 JNB  P3.5, JMP_TO_0   
 JNB  P3.6, JMP_TO_E   
 JNB  P3.7, JMP_TO_D   
 SETB  P3.3  
 CLR  P3.0  
 LJMP  ML  
  
;---------------------------------------------------------------  
JMP_TO_0:  LJMP  M_0 ;MOTOR OFF  
JMP_TO_1:  LJMP  M_1 ;LEVEL 1  
JMP_TO_2:  LJMP  M_2 ;LEVEL 2  
JMP_TO_3:  LJMP  M_3 ;LEVEL 3  
JMP_TO_4:  LJMP  ML ;NOT NEEDED  
JMP_TO_5:  LJMP  ML ;continue scanning  
JMP_TO_6:  LJMP  ML  
JMP_TO_7:  LJMP  ML  
JMP_TO_8:  LJMP  ML  
JMP_TO_9:  LJMP  ML  
  
JMP_TO_A:  LJMP  M_A ;LEVEL 4  
JMP_TO_B:  LJMP  M_B
JMP_TO_C:  LJMP  ML  
JMP_TO_D:  LJMP  ML  
JMP_TO_E:  LJMP  M_E ;CLOCKWISE  
JMP_TO_F:  LJMP  M_F ;ANTI-CLOCKWISE  
  
;---------------------------------------------------------------  

M_0:    
 JNB  P3.5,M_0 ;wait for key release  
 MOV  R2, #01H    
 ACALL  COMMAND  ;clear LCD screen  
 MOV DPTR, #OFF_MSG
 ACALL  LCD_PRINT 
 LJMP  MOTOR_0  ;MOTOR OFF STATE  
  
 
 
M_1:    
 JNB  P3.4,M_1      
 MOV  R2, #01H  
 ACALL  COMMAND  
 MOV DPTR, #LVL1  
 ACALL  LCD_PRINT 
MOV  R2, #01H  
 ACALL  COMMAND  
 MOV DPTR, #RPM1 
 ACALL  LCD_PRINT 
 LJMP MOTOR_1  ;RPM LEVEL 1  
   
  
M_2:     
 JNB  P3.5,M_2  
 MOV  R2, #01H  
 ACALL  COMMAND  
 MOV DPTR, #LVL2  
 ACALL  LCD_PRINT
MOV  R2, #01H  
 ACALL  COMMAND  
 MOV DPTR, #RPM2  
 ACALL  LCD_PRINT  
 LJMP MOTOR_2  ;RPM LEVEL 2 
 
   
  
M_3:    
 JNB  P3.6,M_3  
 MOV  R2, #01H  
 ACALL  COMMAND  
 MOV DPTR, #LVL3  
 ACALL  LCD_PRINT
MOV  R2, #01H  
 ACALL  COMMAND  
 MOV DPTR, #RPM3  
 ACALL  LCD_PRINT   
 LJMP MOTOR_3  ;RPM LEVEL 3  
  
M_A:      
 JNB  P3.7,M_A  
 MOV  R2, #01H  
 ACALL  COMMAND  
 MOV DPTR, #LVL4  
 ACALL  LCD_PRINT  
 LJMP MOTOR_4  ;RPM LEVEL 4  
   
    
;---------------------------------------------------------------  
M_F:   
 JNB  P3.4,M_F  
 MOV  R2, #01H  
 ACALL  COMMAND  
 MOV DPTR, #ANTICLK ;Display 'Anticlockwise'  
 ACALL  LCD_PRINT  
 SETB P1.4  ;anticlockwise rotation  
 CLR P1.3  
 LJMP  ML  ;scan for new input  
  
M_E:   
 JNB  P3.6,M_E  
 MOV  R2, #01H  
 ACALL  COMMAND  
 MOV DPTR, #CLKWISE  
 ACALL  LCD_PRINT  
 SETB P1.3  ;clockwise rotation (In1=1,In2=0)  
 CLR P1.4  
 LJMP  ML  
 
 
M_B:
JNB P3.7, M_B
MOV R2, #01H
ACALL COMMAND
MOV DPTR, #RESTART ;display 'Motor off'  
ACALL  LCD_PRINT  
LJMP MOTOR_ROTATION
   
   
 
   
  
;---------------------------------------------------------------   
;Delay subroutine for PWM  
;---------------------------------------------------------------  
DELAYM:  
    MOV     R5, #1  
Hl: MOV     R4, #100  
H2: MOV     R3, #255   
H3: DJNZ    R3, H3   
    DJNZ    R4, H2   
    DJNZ    R5, Hl   
    RET   
;---------------------------------------------------------------  
  
LC: MOV     P3, #0FEH ;INITIAL CONDITION  
 LJMP    ML  ;SCAN KEYPAD AGAIN  
;---------------------------------------------------------------   
MOTOR_0:  
  
 CLR     P1.0  ;MOTOR OFF  
 CLR  P1.5  
 JNB     P3.4,LL  ;JNB IS SHORT JUMP,    
 JNB     P3.5,LL  ;SO LL IS USED AS AN INTERMEDIATE STAGE  
 JNB     P3.6,LL  
 SETB    P3.0  
 CLR     P3.3  ;CHECK ROW 4 (* 0 # D)  
   
 JNB     P3.4,LC  ;'*' PRESSED  
 JNB     P3.5,LC  ;'0' PRESSED  
 JNB     P3.6,LC  ;'#' PRESSED  
 SETB    P3.3  
 CLR     P3.0  ;AGAIN CHECK ROW 1(1 2 3 A)  
 JB     P3.7,LL
 SJMP    MOTOR_0     
   
;---------------------------------------------------------------    
LL: LJMP ML   ;JUMP TO L1  
;---------------------------------------------------------------  
   
MOTOR_1:
CLR LED          ;25% DUTY CYCLE  
CLR  P1.5 
 SETB    P1.0  
 ACALL   DELAYM  
 CLR     P1.0  
 ACALL   DELAYM  
 ACALL   DELAYM  
 ACALL   DELAYM  
  
 JNB     P3.4,LL      ;CHECK FOR NEW INPUT  
 JNB     P3.5,LL      ;KEY 1,2,3,A FOR LEVEL 1-4  
 JNB     P3.6,LL  
 JNB     P3.7,LL   
 SETB    P3.0  
 CLR     P3.3  
    
 JNB     P3.4,ACL1 ;'*' FOR ANTI-CLOCKWISE  
 JNB     P3.5,LC      ;GO OUT WHEN '0' IS PRESSED  
 JNB     P3.6,CL1 ;# FOR CLOCKWISE  
 SETB    P3.3  
 CLR     P3.0  
    
 SJMP  MOTOR_1  
;---------------------------------------------------------------   
CL1:ACALL   CL_MAIN      ;FOR CLOCKWISE ROTATION  
    SJMP    MOTOR_1      ;CONTINUE SAME RPM LEVEL  
ACL1:ACALL  ACL_MAIN  
     SJMP    MOTOR_1  
;---------------------------------------------------------------   
MOTOR_2: 
CLR LED         ;50% DUTY CYCLE  
CLR  P1.5 
 SETB    P1.0  
 ACALL   DELAYM  
 ACALL   DELAYM  
 CLR     P1.0  
 ACALL   DELAYM  
 ACALL   DELAYM  
 JNB     P3.4,LL  
 JNB     P3.5,LL  
 JNB     P3.6,LL  
 JNB     P3.7,LL   
 SETB    P3.0  
 CLR     P3.3  
 JNB     P3.4,ACL2 ;'*' pressed  
 JNB     P3.5,LC1  
 JNB     P3.6,CL2  
 SETB    P3.3  
 CLR     P3.0  
    
 SJMP    MOTOR_2  
;---------------------------------------------------------------  
CL2: ACALL   CL_MAIN   
 SJMP    MOTOR_2  
ACL2: ACALL   ACL_MAIN ;rotation anticlockwise  
 SJMP    MOTOR_2      ;continue with the same RPM   
    
;---------------------------------------------------------------  
LC1: LJMP    ML  ;used as a redirect  
;---------------------------------------------------------------  
  
;CLOCKWISE ROTATION---------------------------------------------  
CL_MAIN:  
     MOV  R2, #01H    
 ACALL  COMMAND  
 MOV DPTR, #CLKWISE  
 ACALL  LCD_PRINT  
 SETB P1.3  
 CLR P1.4  
 RET  
   
;ANTI-CLOCKWISE ROTATION----------------------------------------   
ACL_MAIN:  
     MOV  R2, #01H  
 ACALL  COMMAND  
 MOV DPTR, #ANTICLK  
 ACALL  LCD_PRINT  
 SETB P1.4  
 ACALL DELAY  
 CLR P1.3  
 RET  
 
;---------------------------------------------------------------    
 
 
 
MOTOR_3:       ;75% DUTY CYCLE   
CLR LED
CLR  P1.5
 SETB    P1.0  
 ACALL   DELAYM  
 ACALL   DELAYM  
 ACALL   DELAYM  
 CLR     P1.0  
 ACALL   DELAYM  
   
 JNB     P3.4,LL1  
 JNB     P3.5,LL1  
 JNB     P3.6,LL1  
 JNB     P3.7,LL1   
 SETB    P3.0  
 CLR     P3.3  
   
 JNB     P3.4,ACL3  
 JNB     P3.5,LC1  
 JNB     P3.6,CL3  
 SETB    P3.3  
 CLR     P3.0  
    
 SJMP    MOTOR_3  
;---------------------------------------------------------------   
CL3:ACALL   CL_MAIN  
    SJMP    MOTOR_3  
ACL3:ACALL  ACL_MAIN  
     SJMP    MOTOR_3  
;--------------------------------------------------------------- 
   
MOTOR_4:   ;KEY 'A'  
SETB LED
CLR BUZ
ACALL DELAY
SETB BUZ
CLR     P1.0  ;100% DUTY CYCLE
SETB P1.3
CLR P1.4
SETB LED ;ON BUZZER WHEN MOTOR EACH 3000RPM   
 ACALL   DELAYM  
 ACALL   DELAYM  
 ACALL   DELAYM  
 ACALL   DELAYM  
 JNB     P3.4,LL1  
 JNB     P3.5,LL1  
 JNB     P3.6,LL1  
 JNB     P3.7,LL1   
 SETB    P3.0  
 CLR     P3.3  
   
 JNB     P3.4,ACL4  
 JNB     P3.5,GO 
 JNB     P3.6,CL4  
 SETB    P3.3  
 CLR     P3.0  
   
 CLR     P1.0  

 SJMP  MOTOR_4
;---------------------------------------------------------------  
CL4:ACALL   CL_MAIN  
    SJMP    MOTOR_4  
ACL4:ACALL  ACL_MAIN  
    SJMP    MOTOR_4   
   
;---------------------------------------------------------------  
LL1:LJMP    ML  
;---------------------------------------------------------------  
 GO : LJMP LC1  
;Display messages----------------------------------------------------  
  
INT_MSG: DB 'ENTER RPM LEVEL',0 ;INITIAL MESSAGE  
OFF_MSG: DB 'MOTOR OFF',0  
LVL1:    DB 'LOW SPEED',0
RPM1 : DB '500 RPM',0  
LVL2:  DB 'MED SPEED ',0 
RPM2 : DB '1000 RPM',0   
LVL3:  DB 'HIGH SPEED ',0 
RPM3 : DB '1500 RPM',0   
LVL4:  DB 'OVERLOADED!!',0  
CLKWISE: DB 'ANTI-CLOCKWISE',0  
ANTICLK: DB 'CLOCKWISE',0   
     
;---------------------------------------------------------------  
START1:   DB 'SPEED-CONTROLLED',0  
START2:   DB 'DC MOTOR',0  
PASS_MSG: DB 'ENTER PASSWORD',0   
ACPT_MSG: DB 'MOTOR ACTIVE',0  
DENY_MSG: DB 'WRONG PASSWORD',0  
TRY_AGN:  DB 'TRY AGAIN',0   
PROMPT1:  DB 'SPEED AT 1-A',0  
PROMPT2:  DB 'STOP-DIR-RES',0  
RESTART:  DB 'MOTOR RESTARTING',0
    
END 