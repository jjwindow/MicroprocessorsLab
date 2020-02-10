#include p18f87k22.inc

    global  LED_Setup, Output_GRB

acs0	udata_acs

BRIGHTNESS	res 1
bitcount	res 1
bytecount	res 1
pixelcount	res 1
longdelaycount	res 1
_byte	res 1
	
	
LEDs	code
    
LED_Setup
	clrf TRISE
	bcf PORTE, 0  ; READY PIN E0 FOR OUTPUT
	movlw b'11111111' ;value of 50/255
	movwf BRIGHTNESS
	return

Output_GRB
	bcf	INTCON,GIE ;disable interrupts
	call	loop	   ; move to loop 
	call	delay_50   ; refresh flag
	bsf	INTCON,GIE ; (*) re-enable interrupts
	return
loop	movlw	.9	    ; reset byte counter
	movwf	bytecount
	movlw	.7	    ; reset bit counter
	movwf	bitcount
	movff	BRIGHTNESS, _byte    ; +1 // load working byte
	call	send_byte   ; +2 // send byte
	decfsz	bytecount   ; decrement byte counter
	return		    ; if zero bytes left, return above (*)
	goto loop	    ; otherwise, send next byte
	

	
Send_1
	; 0.8us HI, 0.45us LO 
	; 20 instructions TOTAL (after bsf)
	bsf	PORTE, 0
	call	delay_.8    ; 12 instruction delay		    
	bcf	PORTE, 0    ; 12 instructions -> 13 instructions, lo pulse sent
	NOP
	NOP
	NOP
	NOP
	
Send_0
	; 0.4us HI, 0.85us LO 
	; 20 instructions TOTAL (after bsf)
	bsf	PORTE, 0
	call	delay_.4		    
	bcf	PORTE, 0    ; 6 instruction delay -> 7 instruction delay, lo pulse sent
	call	delay_.85	    ; End hi
	
	
	
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
	
delay_50
	movlw	.38
	movwf	longdelaycount	
iter	decfsz	longdelaycount
	goto	iter
	return
send_byte	
	btfsc	_byte, 7 ; check MSB of working byte
	goto	no_skip		; if 1 - send 1
	call	Send_0		; if 0 - send 0
	goto	skip
no_skip	call	Send_1
skip	rlncf	_byte	; then rotate the working byte (load next bit)
	decfsz	bitcount	; decrement bit counter
	goto	send_byte	; if bit counter is not zero then loop
	return			; if bit counter is zero then return (send next byte)
	

 end
