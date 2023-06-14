DATA SEGMENT
    STR1 DB 100 DUP('$');  ; Reserve space for input string 1
    LEN1 DW 0           ; Storing the length of STR1
    STR2 DB 100 DUP('$');  ; Reserve space for input string 2
    LEN2 DW 0           ; Storing the length of STR2
    OUTPUT_FOUND_MSG DB 'Substring found.$'  ; Output message for substring found
    OUTPUT_NOT_FOUND_MSG DB 'Substring not found.$'  ; Output message for substring not found
DATA ENDS

CODE SEGMENT 
ASSUME CS:CODE, DS:DATA

START:   

    ; Get input for string 1
    MOV AH, 0AH
    LEA DX, STR1
    INT 21H
    
    ; Calculate the length of string 1
    MOV SI, OFFSET STR1 + 1
    MOV CL, [SI]
    MOV CH, 0
    MOV WORD PTR LEN1, CX
    
    ; Get input for string 2
    MOV AH, 0AH
    LEA DX, STR2
    INT 21H
    
    ; Calculate the length of string 2
    MOV SI, OFFSET STR2 + 1
    MOV CL, [SI]
    MOV CH, 0
    MOV WORD PTR LEN2, CX

    LEA SI, STR1          ; Store the memory address of STR1 in SI
    LEA DI, STR2          ; Store the memory address of STR2 in DI
    MOV DX, LEN1          ; Store the length of string in DX
    MOV CX, LEN2          ; Store the length of substring in CX
    CMP CX, DX            ; Comparing main & substring length
    JA EXIT               ; If substring size is bigger, there is no chance to find it in the main string
    JE SAMELENGTH         ; If main & sub string have the same length, we can compare them directly
    JB FIND               ; General case (substring length < mainstring length): apply the main process

SAMELENGTH:
    CLD
    REPE CMPSB
    JNE OUTPUT_NOT_FOUND  ; Substring not found
    JMP OUTPUT_FOUND

FIND:
    MOV AL, [SI]          ; Storing the ASCII value of the current character of the main string
    MOV AH, [DI]          ; Storing the ASCII value of the current character of the substring
    CMP AL, AH            ; Comparing both characters
    JE CHECK
    JNE NOTEQL

NOTEQL:
    INC SI                ; If the characters don't match, point to the next char of the main string
    DEC DX                ; DX keeps track of how many characters of the main string are left to process
    CMP DX, 0             ; Checking if there are any characters left in the main string for further comparison
    JE OUTPUT_NOT_FOUND   ; If no characters are left in the main string, the substring doesn't exist in it
    JMP FIND

CHECK:
    MOV CX, LEN2          ; CX is used internally for REPE CMPSB. Storing the length of the substring in CX limits the number of characters for comparison to the exact length of the substring.
    MOV SP, SI            ; Storing the index of the current character of the main string
    ADD SP, 1
    CLD
    REPE CMPSB
    JNE TEMPRED
    JMP OUTPUT_FOUND

TEMPRED:
    MOV SI, SP            ; Going to the next character of the main string
    DEC DX
    LEA DI, STR2          ; Reloading the substring index in DI
    JMP FIND              ; If a character matches but the following substring mismatches in the main string, start over the same process from the next character of the main string

OUTPUT_FOUND:
    MOV AH, 09H           ; Print substring found message
    LEA DX, OUTPUT_FOUND_MSG
    INT 21H
    JMP EXIT

OUTPUT_NOT_FOUND:
    MOV AH, 09H           ; Print substring not found message
    LEA DX, OUTPUT_NOT_FOUND_MSG
    INT 21H

EXIT:
    MOV AH, 4CH           ; Exit program
    INT 21H
CODE ENDS  
END START
END