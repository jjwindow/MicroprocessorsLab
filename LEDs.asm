#include p18f87k22.inc

    global  LED_Setup

    
acs0	udata_acs

BRIGHTNESS	res 1
bitcount	res 1
	
LEDs	code
    
LED_Setup
	clrf TRISE
	movlw b"00110010" ;value of 50/255
	movwf BRIGHTNESS
	call Output_GRB
	return

Output_GRB
	bcf	INTCON,GIE ;disable interrupts
	movlw	.150
	movwf	bitcount
loop	; bit testing, 1 or 0
	goto loop
	

	
Send_1
	; 0.8us HI, 0.45us LO 
	; 20 instructions TOTAL (after bsf)
	bsf	PORTE, 0
	call	delay_.8    ; 12 instruction delay		    
	bcf	PORTE, 0    ; 12 instructions -> 13 instructions, lo pulse sent
	call	delay_.4    ; 13 - 19
	NOP
	bsf PORTE, 0	    ; End hi	
	
Send_0
	; 0.4us HI, 0.85us LO 
	; 20 instructions TOTAL (after bsf)
	bsf	PORTE, 0
	call	delay_.4		    
	bcf	PORTE, 0    ; 6 instruction delay -> 7 instruction delay, lo pulse sent
	call	delay_.85
	bsf PORTE, 0	    ; End hi
	
	
	
delay_.4
	NOP		; 6 instruction delay
	NOP		; req'd delay/time per instruction = 400ns/62.5ns 
	NOP		; = 6.4 (+/- 2) instructions.
	NOP
	return
	
delay_.45
	
delay_.8
	call	delay_.4    ; instructions 2-7
	NOP
	NOP
	NOP
	NOP
	return
	
	
	
delay_.85
	call	delay_.4    ; instructions 9 - 14
	call	delay_.4    ; instructions 14 - 20 
	return
end
	
btfsz	bit ;first bit 0 
goto	RED
rotate left
btfsz