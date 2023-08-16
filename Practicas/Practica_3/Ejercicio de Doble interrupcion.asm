CONT EQU 10H
COMP EQU 11H
EOI EQU 20H
IMR EQU 21H
INT0 EQU 24H
INT1 EQU 25H
PA EQU 30H
IDF10 EQU 13
IDTIMER EQU 19

ORG 1000H
 MENSAJE DB "HOLA"
 FIN DB ?
 TOCO_F10 DB 0
 
ORG 3000H
IMPRIMIR: MOV BX, OFFSET MENSAJE
 MOV AL, OFFSET FIN - OFFSET MENSAJE
 INT 7
 
 ;RESETEO EL CONTADOR

 MOV AL, 0
 OUT CONT, AL
 
 MOV AL, 20H
 OUT EOI, AL ;EOI = 20H
 IRET
 
DETENER: MOV TOCO_F10, 1
 MOV AL, 20H
 OUT EOI, AL ;EOI = 20H
 IRET

ORG 2000H
; PONER EL VECT DE INT LA DIR DE LA SUBRUTINA DEL F10
MOV BX, 52 ;52 = 13 * 4
MOV AX, DETENER
MOV [BX], AX

MOV BX, 76 ;76 = 19 * 4
MOV AX, IMPRIMIR
MOV [BX], AX

CLI
MOV AL, 11111100B
OUT IMR, AL

;MANDAR LOS IDS
MOV AL, IDF10
OUT INT0, AL

;MANDAR LOS IDS
MOV AL, IDTIMER
OUT INT1, AL

;CONFIGURAMOS EL TIMER
MOV AL, 1
OUT COMP, AL

MOV AL, 0
OUT CONT, AL

STI

LOOP: CMP TOCO_F10, 1

JNZ LOOP
INT 0
END