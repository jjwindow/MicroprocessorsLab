	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100
	
SPI_MasterInit ; Set Clock edge to positive
	bsf SSP2STAT, CKE
	; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
	movlw (1<<SSPEN)|(1<<CKP)|(0x02)
	movwf SSP2CON1
	; SDO2 output; SCK2 output
	bcf TRISD, SDO2
	bcf TRISD, SCK2
	return
SPI_MasterTransmit ; Start transmission of data (held in W)
	movwf SSP2BUF
Wait_Transmit ; Wait for transmission to complete
	btfss PIR2, SSP2IF
	bra Wait_Transmit
	bcf PIR2, SSP2IF ; clear interrupt flag
	return
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

;start
;	setf	TRISE ; Tri-state PortE
;	banksel PADCFG1 ; PADCFG1 is not in Access Bank!!
;	bsf	PADCFG1, REPU, BANKED ; PortE pull-ups on
;	movlb	0x00 ; set BSR back to Bank 0
;	clrf	TRISD ; clear TRISD
;	setf	PORTD	; initialise control bus
;	movlw	0x2
;	movwf	0x30 ; set FR0x30 to 2
;	movlw 	0x0
;	goto	write_RAM2
;
;write_RAM1	
;	clrf	TRISE	
;	movlw	0x5	; Test byte
;	movwf	LATE
;	bcf	PORTD, 1 ; turn CP for RAM1 to low
;	movlw	0x6 ; 6 instruction cycle delay, >100ns
;	call	delay
;	bsf	PORTD, 1    ; turn CP for RAM1 to high
;	setf	TRISE	; reset to all 1s as default
;	goto	read_RAM1
;
;write_RAM2	
;	clrf	TRISE
;	movlw	0x6
;	movwf	LATE
;	bcf	PORTD, 3                 
;	movlw	0x6 ; same delay as above
;	call	delay
;	bsf	PORTD, 3
;	setf	TRISE
;	goto	read_RAM2
;	
;read_RAM1	
;	bcf	PORTD, 0
;	movlw	0x3 
;	movwf	PORTD, 0
;	
;read_RAM2	
;	bcf	PORTD, 2
;	movlw	0x00
;	call	delay
;	bsf	PORTD, 2
;
;delay	movwf	0x30
;dloop	decfsz	0x30		    ; delay decrement
;	bra dloop
;	return
;	
;delaydelay  
;	movwf	0x31
;ddloop	movlw	0x00
;	call	delay
;	decfsz	0x20
;	bra	ddloop
;	return
;	
;	end