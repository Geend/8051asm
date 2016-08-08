; 7/8/2016 2:29:35 PM

#cpu = 89S8252	; @12 MHz

#use LCALL

; Initialisierung
mov SP, # 7Fh	; Stackbeginn

;Test add

mov r0, #00h	;a high
push 0h
mov r0, #02h 	;a low
push 0h

mov r0, #00h	;b high
push 0h
mov r0, #01h	;b low 
push 0h

lcall add16




;Test sub
mov r0, #FFh	;a high
push 0h
mov r0, #03h 	;a low
push 0h

mov r0, #AAh	;b high
push 0h
mov r0, #01h	;b low 
push 0h

lcall sub16




;Test mul
mov r0, #FFh	;a high
push 0h
mov r0, #03h 	;a low
push 0h

mov r0, #AAh	;b high
push 0h
mov r0, #01h	;b low 
push 0h

lcall mul16

end


prepare:
;psw in a sichern
mov a, psw

;Zu Register Bank 3 wechseln
setb RS1
setb RS0

;Rücksprungaddresse für ret aus prepare sichern
pop 1Eh; r6
pop 1Fh ; r7

;Eigentliche Rücksprungaddresse sichern
pop 1Ch; r4
pop 1Dh;  r5


;Werte vom Stack in Register Bank 3 laden
pop 1Bh ;b low --> r3
pop 1Ah   ;b high --> r2

pop 19h ;a low --> r1
pop 18h ;a high --> r0


;Eigentliche Rücksprungaddresse zurück auf den Stack
push 1Ch
push 1Dh


;PSW aus a holen auf den Stack sichern
mov 1Ch,  a
push 1Ch


;Rücksprungaddre für ret aus prepare wieder auf den Stack
push 1Fh
push 1Eh

ret


restore:
;Rücksprungaddresse für ret aus prepare sichern
pop 1Eh; r6
pop 1Fh ; r7

;PSW vom Stack holen und in a zwischenlagern
pop 1Dh
mov a, 1Dh


;Eigentliche rücksprungaddresse vom stack holen
pop 1Dh
pop 1Ch



;Ergebniss auf den Stack legen
push 1Bh ;x low (r3)
push 1Ah; x high (r2)

push 19h ;x low (r1)
push 18h; x high (r0)

;Eigentliche rücksprungaddresse auf den stack
push 1Dh
push 1Ch

;psw wiederherstellen
mov psw, a

;Rücksprungaddresse aus ret wiederherstellen
push 1Fh
push 1Eh

ret






;add16:	x=a+b
add16:


lcall prepare

;Addition durchführen
mov a, r1
add a, r3
mov r1, a

mov a, r0
addc a, r2
mov r0, a

lcall restore
ret


;sub16:	x = a-b
sub16:
lcall prepare
;Subtraktion durchführen
clr c

mov a, r1
subb a, r3
mov r1, a

mov a, r0
subb a, r2
mov r0, a

lcall restore
ret




;mul16:	x=a*b
mul16:

;Zu Register Bank 3 wechseln
setb RS1
setb RS0

;Rücksprungaddresse sichern
pop 1Eh; r6
pop 1Fh ; r7

;Werte vom Stack in Register Bank 3 laden
pop 1Bh ;b low --> r3
pop 1Ah   ;b high --> r2

pop 19h ;a low --> r1
pop 18h ;a high --> r0

;Multiplikaktion durchführen


;mul xlow, ylow
mov a, r0 
mov b, r2

mul ab

mov r4, a ;r4 now contains the final result of the entire multiplication

mov r5, b ;r5 contains the overflow of the first multiplication which need to be added after the second addition

;mul xhigh, ylow
mov a, r1

mov b, r2

mul ab

add a, r5
mov r5, a 

mov r6, b
mov a, r6 
addc a, #00h ; do we need to do this?

mov r6,a


;mul xlow, yhigh

mov a, r0

mov b, r3

mul ab
add a, r5

mov r5, a; r5 now contains the final ...

mov r7, b
mov a, r7
addc a, #00h
mov r7, a

mov a, r6
addc a, r7
mov r6, a

;mul xhigh, yhigh

mov a, r1

mov b, r3

mul ab
add a, r6
mov r6, a


mov r7,b
mov a, r7
addc a, #00h
mov r7,a

 

















end
; * * * Hauptprogramm Ende * * *
