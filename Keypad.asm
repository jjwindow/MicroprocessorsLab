#include p18f87k22.inc

    global  ;

acs0    udata_acs	    ; named variables in access ram
; res 1	    ; reserve 1 byte for variable UART_counter

Keypad   code
    
Keypad_Setup
    bsf PADCFG1,REPU,banked
    clrf LATE ;WRITE 0S TO LATE (do this once)
    Set TRISE to 0x0F ;configure pins 0-3 as INPUTS & 4-7 as OUTPUTS
