; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db 13,10, "press any key...$"
    A DW ?
    X DW ?
    Y DW ?
    Y1 DW ?
    Y2 DW ? 
   
    VVOD_A DB 13,10,"VVEDITE A=$"  ,13,10
    VVOD_X DB 13,10,"VVEDITE X=$"  ,13,10,
    VIVOD_Y DB 13,10, "Y=$",13,10,'$'
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here 
 XOR AX, AX
    MOV DX, OFFSET VVOD_A
    MOV AH, 9
    INT 21H
    
SLED2:
    MOV AH, 1
    INT 21H
    CMP AL, "-"
    JNZ SLED1
    MOV BX, 1
    JMP PRIOBRAZ
    
SLED1:
    SUB AL, 30H
    TEST BX, BX
    JZ SLED3
    NEG AL
    
PRIOBRAZ:
    NEG AL
SLED3:
    MOV AH, 0
    MOV A, AX
    XOR AX, AX
    XOR BX, BX
    MOV DX, OFFSET VVOD_X
    MOV AH, 9
    INT 21H

SLED4:
    MOV AH, 1
    INT 21H
    CMP AL, "-"
    JNZ SLED5
    MOV BX, 1
    JMP PRIOBRAZ1
    
SLED5:
    SUB AL, 30H
    TEST BX, BX
    JZ SLED6
    NEG AL
    
PRIOBRAZ1:
    NEG AL
SLED6:    
    MOV AH, 0
    MOV X, AX
    
    MOV AX, X
    CMP AX, 3
    JGE Y1_GREATER_BRANCH
    MOV AX, 7
    ADD AX, X
    MOV Y1, AX
    JMP Y1_CALCULATED
    
    Y1_GREATER_BRANCH:
        MOV AX, A
        CMP AX, 0
        JGE Y1_POSITIVE_A
        NEG AX
    Y1_POSITIVE_A:
        ADD AX, X
        MOV Y1, AX

    Y1_CALCULATED:
        MOV AX, X
        CMP AX, 5
        JG Y2_GREATER_BRANCH
        MOV AX, A
        ADD AX, X
        MOV Y2, AX
        JMP Y2_CALCULATED
        
    Y2_GREATER_BRANCH:
        MOV Y2, 1
        
    Y2_CALCULATED:
        MOV AX, Y1
        MOV DX, 0
        MOV BX, Y2
        DIV BX
        
        MOV Y, DX
        
        MOV DX, OFFSET VIVOD_Y
        MOV AH, 9
        INT 21H
        MOV AX, Y
        MOV DL, AL
        ADD DL, 30H
        MOV AH, 2
        INT 21H
        MOV DX, OFFSET pkey
        MOV AH, 9
        INT 21H
        MOV AH, 1
        INT 21H
    ENDS
    
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.