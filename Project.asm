#include p18f87k22.inc
  
    extern LED_Setup,Output_GRB
	
rst	code	0x0000	; reset vector
	goto	start
	
main	code
start	call	LED_Setup		; Sit in infinite loop
	call	Output_GRB
	goto	$
	end


