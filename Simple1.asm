	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	setf	TRISE ; Tri-state PortE
	banksel PADCFG1 ; PADCFG1 is not in Access Bank!!
	bsf	PADCFG1, REPU, BANKED ; PortE pull-ups on
	movlb	0x00 ; set BSR back to Bank 0
	clrf	TRISD ; clear TRISD
	movlw	0x2
	movwf	0x30 ; set FR0x30 to 2
	movlw 	0x0
	goto	write_RAM2

write_RAM1	
	clrf	TRISE
	movlw	0x5
	movwf	LATE
	movlw	0x1
	movwf	PORTD
	call	delay
	movlw	0x3
	movwf	PORTD
	setf	TRISE
	goto	read_RAM1

write_RAM2	
	clrf	TRISE
	movlw	0x6
	movwf	LATE
	bcf	PORTD, 0x2
	movlw	0x6
	movwf	0x30
	call	delay
	bsf	PORTD, 0x2
	setf	TRISE
	goto	read_RAM2
	
read_RAM1	
	movlw	0x2 
	movwf	PORTD
	movlw	0x3 
	movwf	PORTD
	
read_RAM2	
	bcf	PORTD, 0x2
	movlw	0x00
	call	delaydelay
	bsf	PORTD, 0x3

delay	movwf	0x30
dloop	decfsz	0x30		    ; delay decrement
	bra dloop
	return
	
delaydelay  
	movwf	0x31
ddloop	movlw	0x00
	call	delay
	decfsz	0x20
	bra	ddloop
	return
	
	end