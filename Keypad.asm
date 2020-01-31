#include p18f87k22.inc
    
    global  Keypad_Setup, Read_Row, Read_Column, Read_Keypad
    extern LCD_Write_Message, LCD_clear

    org 0x100
acs0    udata_acs	    ; named variables in access ram
delay_count res 1   ; reserve one byte for counter in the delay routine
row res 1 ;reserve one byte for row reading
col res 1 ;reserve one byte for column reading
result res 1 ;reserve one byte for the resulting 1byte string
key_pressed res 1 ; reserve one byte for the character presssed
 
Keypad   code
    
Keypad_Setup
    banksel PADCFG1 ;PADCFG1 is not in Access Bank!!
    bsf	    PADCFG1,REPU, BANKED
    clrf    LATE ;WRITE 0S TO LATE (do this once)
    clrf    TRISH ;SET PORT H to OUTPUT
    
    movlw 0x00
    movwf delay_count ;set max delay
    return
    
Read_Keypad 
    call    Read_Row 
    call    Read_Column
    movlw   0x0 ;clear WREG
    addwf   row, 0 ;add row, store in W
    addwf   col, 0 ;add col, store in W
    movwf   result ;store result
    movff   result, LATH ;Display Result in PortH
   
    call    Decode_Result ;Decode Result (17 valid inputs)
    movff   key_pressed, W
    movwf   PORTJ
    movlw   0x00
    CPFSEQ  key_pressed
    goto    Overwrite_LCD_message
    return
Overwrite_LCD_message
    call LCD_clear
    movlw   0x01
    lfsr    FSR2, key_pressed
    call    LCD_Write_Message
    return
    
Read_Row
    ; configure pins 0-3 as inputs & 4-7 as Outputs
    movlw 0xF0
    movwf TRISE
    call delay
    
    movff PORTE, row
    return
    
Read_Column
    ; configure pins 0-3 as outputs & 4-7 as Inputs
    movlw 0x0F
    movwf TRISE
    call delay
    
    movff PORTE, col
    return
    
    
Decode_Result
    ; decode the resulting 8 bit string to see if it's a valid input
    test_NULL 
	movlw   0xFF ;code for NO INPUT
	CPFSEQ  result
	goto    test_0
	movlw   0x00
	movwf   key_pressed
	return
    test_0   
	movlw	0x7D ;code for 0
	CPFSEQ  result
	goto    test_1
	movlw   '0'
	movwf   key_pressed
	return
    test_1  
	movlw   0xEE ;code for 1
	CPFSEQ  result
	goto    test_2
	movlw   '1'
	movwf   key_pressed
	return  
    test_2   
	movlw   0xED ;code for 2
	CPFSEQ  result
	goto    test_3
	movlw   '2'
	movwf   key_pressed
	return
    test_3  
	movlw   0xEB ;code for 3
	CPFSEQ  result
	goto    test_4
	movlw   '3'
	movwf   key_pressed
	return
    test_4
	movlw   0xDE ;code for 4
	CPFSEQ  result
	goto    test_5
	movlw   '4'
	movwf   key_pressed
	return
    test_5
	movlw   0xDD ;code for 5
	CPFSEQ  result
	goto    test_6
	movlw   '5'
	movwf   key_pressed
	return
    test_6  
	movlw   0xDB ;code for 6
	CPFSEQ  result
	goto    test_7
	movlw   '6'
	movwf   key_pressed
	return
    test_7  
	movlw   0xBE ;code for 7
	CPFSEQ  result
	goto    test_8
	movlw   '7'
	movwf   key_pressed
	return
    test_8  
	movlw   0xBD ;code for 8
	CPFSEQ  result
	goto    test_9
	movlw   '8'
	movwf   key_pressed
	return
    test_9 
	movlw   0xBB ;code for 9
	CPFSEQ  result
	goto    test_A
	movlw   '9'
	movwf   key_pressed
	return
    test_A 
	movlw   0x7E ;code for A
	CPFSEQ  result
	goto    test_B
	movlw   'A'
	movwf   key_pressed
	return
    test_B
	movlw   0x7B ;code for B
	CPFSEQ  result
	goto    test_C
	movlw   'B'
	movwf   key_pressed
	return
    test_C 
	movlw   0x77 ;code for C
	CPFSEQ  result
	goto    test_D
	movlw   'C'
	movwf   key_pressed
	return
    test_D
	movlw   0xB7 ;code for D
	CPFSEQ  result
	goto    test_E
	movlw   'D'
	movwf   key_pressed
	return
    test_E
	movlw   0xD7 ;code for E
	CPFSEQ  result
	goto    test_F
	movlw   'E'
	movwf   key_pressed
	return
    test_F 
	movlw   0xE7 ;code for F
	CPFSEQ  result
	goto    ReturnError
	movlw   'F'
	movwf   key_pressed
	return
    ReturnError
	movlw   0xFF
	movwf   key_pressed
	return
     
	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return


    end