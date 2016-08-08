; 8/3/2016 11:06:29 AM

#cpu = 89S8252	; @12MHz
#use LCALL

ajmp Initialisierung

Timer 0:	; Timer 0 Interrupt
	ajmp Timer 0 Interrupt

Initialisierung:
mov SP, # 7Fh	; Stackbeginn


; Initialisierung
orl TMOD, # 02h	; Timer 0 im 8-Bit Autoreload-Modus. 
; Die Überlauffrequenz des Timer 0 beträgt 10000 Hz, die Periodendauer 0.1 ms.
mov TH0, # 9Ch	; Reloadwert
setb TR0	; Timer 0 läuft.

; Interrupts
setb ET0	; Timer 0 Interrupt freigeben
setb PT0	; Priorität für Timer 0 Interrupt
setb EA	; globale Interruptfreigabe



;Speicher initalisieren
mov 30h, #00h ;Stunden
mov 31h, #00h ;Minuten
mov 32h, #00h; Sekunden
mov 33h, #00h;  10ms Schritte
mov 34h, #00h; 0.1ms Schritte








end
; * * * Hauptprogramm Ende * * *

Timer 0 Interrupt:
	; Befehle . .
mov r0, 34h
cjne r0, #63h, inc0.10ms

mov r0, 33h
cjne r0, #63h, inc10ms

mov r0, 32h
cjne r0, #3Bh, inc1s


mov r0, 31h
cjne r0, #3Bh, inc1min

mov r0, 30h
cjne r0, #17h, inc1h


mov 34h, #00h
mov 33h, #00h
mov 32h, #00h
mov 31h, #00h
mov 30h, #00h

jmp t0ISREnd


inc0.10ms:
inc 34h
jmp t0ISREnd


inc10ms:
mov 34h, #00h
inc 33h
jmp t0ISREnd


inc1s:
mov 34h, #00h
mov 33h, #00h
inc 32h
jmp t0ISREnd

inc1min:
mov 34h, #00h
mov 33h, #00h
mov 32h, #00h
inc 31h
jmp t0ISREnd


inc1h:
mov 34h, #00h
mov 33h, #00h
mov 32h, #00h
mov 31h, #00h
inc 30h
jmp t0ISREnd


t0ISREnd:

reti




