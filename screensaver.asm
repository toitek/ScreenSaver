CODE SEGMENT
        ASSUME CS:CODE,DS:CODE,ES:CODE
        ORG 100H
START : JMP BEGIN
        TIMER_IP DW ?
        TIMER_CS DW ?
        KB_IP DW ?  
        KB_CS DW ?
        FLAG DB 0
        CNT DB 180
        BUFFER DW 2000 DUP(0)
TIMER:
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        PUSH DI
        PUSH DS
        PUSH ES

        MOV AX,CS
        MOV DS,AX
        MOV ES,AX

        CMP FLAG,00H
        JNE TIMER_END
        DEC CNT
        JNE TIMER_END

        CLD
        MOV AX,0B800H
        MOV DS,AX
        MOV SI,0000H
        MOV DI,OFFSET BUFFER
        MOV CX,2000
        REP MOVSW

        MOV AX,0B800H
        MOV ES,AX
        MOV DI,0000H
        MOV AL,48
        MOV AH,89
        MOV CX,2000
        REP STOSW

        MOV CS:FLAG,01H
TIMER_END:
        POP ES
        POP DS
        POP DI
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX
JMP DWORD PTR CS:TIMER_IP

KB:
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH SI
        PUSH DI
        PUSH DS
        PUSH ES

        MOV AX,CS
        MOV DS,AX
        MOV ES,AX

        MOV CNT,180
        CMP FLAG,01
        JNE KB_END

        CLD
        MOV AX,0B800H
        MOV ES,AX
        MOV SI,OFFSET BUFFER
        MOV DI,0000H
        MOV CX,2000
        REP MOVSW

        MOV FLAG,00H
KB_END :
        POP ES
        POP DS
        POP DI
        POP SI
        POP DX
        POP CX
        POP BX
        POP AX
JMP DWORD PTR CS:KB_IP

BEGIN:
        MOV AX,CS
        MOV DS,AX
        MOV ES,AX

        MOV AH,35H
        MOV AL,08H
        INT 21H

        MOV TIMER_IP,BX
        MOV TIMER_CS,ES

        MOV AH,35H
        MOV AL,09H
        INT 21H

        MOV KB_IP,BX
        MOV KB_CS,ES

        MOV AH,25H
        MOV AL,08H
        MOV DX,OFFSET TIMER
        INT 21H

        MOV AH,25H
        MOV AL,09H
        MOV DX,OFFSET KB
        INT 21H

        MOV AH,31H
        MOV DX,OFFSET BEGIN
        MOV CL,04H
        SHR DX,CL
        INC DX
        INT 21H

CODE ENDS
END START
