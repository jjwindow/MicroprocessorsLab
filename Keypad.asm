#include p18f87k22.inc
    
    global  Keypad_Setup, Read_Row, Read_Column, Read_Keypad

    org 0x100
acs0    udata_acs	    ; named variables in access ram
delay_count res 1   ; reserve one byte for counter in the delay routine
row res 1 ;reserve one byte for row reading
col res 1 ;reserve one byte for column reading
result res 1 ;reserve one byte for the resulting 1byt string
 
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
    
    call Decode_Result ;Decode Result (17 valid inputs)
    
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
    ; decode the resulting 8 bit string to see if its a valid input
    
	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return


    end