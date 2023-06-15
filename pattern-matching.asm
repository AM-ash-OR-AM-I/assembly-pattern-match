DATA SEGMENT
STR1 DB 'MADAM'         ; Getting input for the string
LEN1 DW ($-STR1)        ; Storing the length of STR1
STR2 DB 'ADA'           ; Getting input for the search pattern
LEN2 DW ($-STR2)        ; Storing the length of STR2
                        ; The $ operator represents the current address
                        ; $-STR1 gives the distance between the current address and the start of STR1, 
                        ; which corresponds to the length of the string.
DATA ENDS

CODE SEGMENT

LEA SI, STR1            ; Store the memory address of STR1 in SI
LEA DI, STR2            ; Store the memory address of STR2 in DI
MOV DX, LEN1            ; Store the length of string in DX
MOV CX, LEN2            ; Store the length of substring in CX
CMP CX, DX              ; comparing main & substring length
JA EXIT                 ; (Jump Above), if substring (CX) size is bigger than main string (DX) there is no chance to be found it in main string
JE SAMELENGTH           ; (Jump Equal/ Jump Zero (JZ)) if main & sub string both have same length the we can compare them directly
JB FIND                 ; general case (substring length < mainstring length): we can apply our main process                 

SAMELENGTH:
        CLD             ; Clear Direction Flag (DF) to increment SI and DI after each comparison 
        REPE CMPSB      ; It compares the byte at [SI] with the byte at [DI] and sets the Zero Flag (ZF) if they are equal. 
                        ; If the ZF flag is set (i.e., the bytes are equal), it increments SI and DI to point to the next bytes in memory. It repeats steps 1 and 2 until the ZF flag is cleared (i.e., the bytes being compared are not equal) or the count in CX reaches zero.
        JNE RED         ; Jump if not equal
        JMP GREEN       ; else Jump (if equal)

FIND:        
        MOV AL, [SI]    ; storing the ascii value of current character of mainstring 
        MOV AH, [DI]    ; storing the ascii value of current character of substring
        CMP AL,AH       ; comparing both character
        JE CHECK
        JNE NOTEQL

NOTEQL:
        INC SI          ; if both character don't match then we would point to the next char of main string
        DEC DX          ; DX keeps track of how many character of mainstring is left to process
        JZ RED          ; if no character is left in main string then obviously the substring doesn't exists in main string
        JMP FIND

CHECK:
        MOV CX, LEN2    ; CX is used internally for REPE CMPSB. 
                        ; So storing length of the substring in CX would limit the number of characters for comparison to exact length of substring.
                        ; For example to compare between "madam" & "ada" we need to compare *ada* portion of main string with substring ada, no more, no less     
        MOV SP, SI      ; storing the index of current character of main string so if the following REPE CMPSB find mismatch,
                        ; then the process can be started over from the next character of main string (SEE line 1 of TEMPRED) by going to TEMPRED > FIND
        ADD SP, 0001H
        CLD
        REPE CMPSB
        JNE TEMPRED
        JMP GREEN

TEMPRED:                ; substring not found starting from the current character of main string,
                        ; but it is possible to find match if we start from next character in main string
        MOV SI,SP       ; going to the next character of main string (after REPE CMPSB of CHECK segment)
        DEC DX
        LEA DI, STR2    ; reloading substring index in DI (after REPE CMPSB of CHECK segment)
        JMP FIND        ; if a character matches but the following substring mismatches in main string then 
                        ; we start over the same process from the next character of main string by going to FIND segment         

GREEN:  
        MOV BX, 0001H   ; substring found
        JMP EXIT


RED:    
        MOV BX, 0000H   ; substring not found
        JMP EXIT

EXIT:         
    CODE ENDS
    END
    RET