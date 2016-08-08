; 14.07.2016 12:11:26

#cpu = 89S8252	; @12 MHz

#use LCALL
Start:
ajmp Initialisierung

Timer 0:	; Timer 0 Interrupt
	ajmp Timer 0 Interrupt

Timer 1:	; Timer 1 Interrupt
	ajmp Timer 1 Interrupt

Initialisierung:
mov SP, # 7Fh	; Stackbeginn
orl TMOD, # 02h	; Timer 0 im 8-Bit Autoreload-Modus. 
; Die Überlauffrequenz des Timer 0 beträgt 3906.25 Hz, die Periodendauer 0.256 ms.
setb TR0	; Timer 0 läuft.
orl TMOD, # 10h	; Timer 1 als 16-Bit Timer. 
; Die Überlauffrequenz des Timer 1 beträgt 15.25879 Hz, die Periodendauer 65.536 ms.
setb TR1	; Timer 1 läuft.

; Interrupts
setb ET0	; Timer 0 Interrupt freigeben
setb ET1	; Timer 1 Interrupt freigeben
setb EA	; globale Interruptfreigabe



mov 30h, #01h

mov 31h, #01h



end
; * * * Hauptprogramm Ende * * *

Timer 0 Interrupt:
mov a, 30h
clr c
rlc a
mov 30h, a
jnc EndeT0
mov 30h, #01h
EndeT0:
reti

Timer 1 Interrupt:
mov dptr, #Start


cont:
mov a, 31h,
movx @dptr, a
inc dptr

mov a, dph
cjne a, #27h, cont

mov a, dpl
cjne a, #0Fh, cont


mov a, 31h
add a, #01h
mov 31h, a
jnc EndeT1

mov 31h, #01h

EndeT1:
reti
