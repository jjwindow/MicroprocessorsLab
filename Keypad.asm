#include p18f87k22.inc
    
    global  Keypad_Setup, Read_Row, Read_Column

    org 0x100
acs0    udata_acs	    ; named variables in access ram
delay_count res 1   ; reserve one byte for counter in the delay routine

Keypad   code
    
Keypad_Setup
    banksel PADCFG1 ;PADCFG1 is not in Access Bank!!
    bsf	    PADCFG1,REPU, BANKED
    clrf    LATE ;WRITE 0S TO LATE (do this once)
    
    movlw 0x00
    movwf delay_count
    return
    
    
Read_Row
    ; configure pins 0-3 as inputs & 4-7 as Outputs
    movlw 0x0F
    movwf TRISE
    call delay
    return
    
Read_Column
    ; configure pins 0-3 as outputs & 4-7 as Inputs
    movlw 0xF0
    movwf TRISE
    call delay
    return
    
	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return


end