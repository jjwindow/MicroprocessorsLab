#include p18f87k22.inc

    global  LED_Setup

    
acs0	udata_acs

BRIGHTNESS	res 1
	
LEDs	code
    
LED_Setup
	clrf TRISE
	movlw b"00110010" ;value of 50/255
	movwf BRIGHTNESS
	call Output_GRB
	return

Output_GRB
	bcf	INTCON,GIE ;disable interrupts
	
	goto Output_GRB
	

	
Send_1
	; 0.8us HI, 0.45us LO 
	
	
Send_0
	; 0.4us HI, 0.85us LO 
	
end