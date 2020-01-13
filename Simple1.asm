	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw	0x0
	movwf	TRISC, ACCESS	    ; Port C all outputs
	movlw	0xFF		    ; Initialise PORTD switches as inputs
	movwf	TRISD, ACCESS	    ; Port D Setup
	bsf	PADCFG1,RDPU, ACCESS
	movlw 	0x0		    ; clear W
	bra 	test
	
loop	movlw	high(0xFFFF)		    ; delay by 16 instructions
	movwf	0x20
	movlw	low(0xFFFF)
	movwf	0x21
	;call	delay		    ; Run delay
	call	longdelay
	movff 	0x06, PORTC
	incf 	0x06, W, ACCESS
	
test	movwf	0x06, ACCESS	    ; Test for end of loop condition
	
	movf	PORTD, W
	cpfsgt 	0x06, ACCESS	    ; Compare count value to input
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start

delay	decfsz	0x20		    ; delay decrement
	bra delay
	return
longdelay
	movlw	0x0
dloop	decf	0x21,f
	subwfb	0x20,f
	bc dloop
	return

	
	end
