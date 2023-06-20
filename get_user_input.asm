.code:
    ; Display input msg for string1     
    LEA DX, MSG1    ; Get offset address
    MOV AH, 09H     ; String display subroutine
    INT 21H         ; DOS interrupt
    
    ; Get input for string1    
    MOV AH, 0AH      ; String input subroutine
    LEA DX, STR1    ; Load address of string
    MOV STR1, 7     ; Set string size
    INT 21H         ; DOS interrupt
    
    ; Calculate input length
    MOV SI, OFFSET STR1 + 1
    MOV CL, [SI]
    MOV CH, 0
    MOV WORD PTR LEN1, CX
    
    ; Display input msg for string2             
    LEA DX, MSG2    ; Get offset address
    MOV AH, 09H     ; String display subroutine
    INT 21H         ; DOS interrupt
    
    ; Get input for string2
    MOV AH, 0AH      ; String input subroutine
    LEA DX, STR2    ; Load address of string
    MOV STR2, 7     ; Set string size
    INT 21H         ; DOS interrupt   
    
    ; Calculate input length
    MOV SI, OFFSET STR2 + 1
    MOV CL, [SI]
    MOV CH, 0
    MOV WORD PTR LEN2, CX
    
    ; Display output message1
    LEA DX, OUT_MSG1
    MOV AH, 09H
    INT 21H
    
    ; Display string output1
    LEA DX, STR1+2  ; First location is used to store count of arr, 2nd is used to store actual word count
    MOV AH, 09H
    INT 21H
    
    LEA DX, OUT_MSG2
    MOV AH, 09H
    INT 21H
    
    LEA DX, STR2+2  ; First location is used to store count of arr, 2nd is used to store actual word count
    MOV AH, 09H
    INT 21H
    
    MOV AX, 4C00H   ; End condition
    INT 21H  
    
.data: 
    MSG1 DB "ENTER STRING1: $" 
    MSG2 DB 13, 10, "ENTER STRING2: $"
    OUT_MSG1 DB 13, 10, "String1 output is $" ; Here 13 moves to beg of line, 10 moves to new line.
    OUT_MSG2 DB 13, 10, "String2 output is $" ; Here 13 moves to beg of line, 10 moves to new line.
    STR1 DB 10 DUP('$')
    LEN1 DW 0 
    STR2 DB 10 DUP('$')
    LEN2 DW 0 