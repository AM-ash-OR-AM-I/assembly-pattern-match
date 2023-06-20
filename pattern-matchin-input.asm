.code:
    ; Display input msg for string     
    LEA DX, MSG1            ; Get offset address
    MOV AH, 09H             ; String display subroutine
    INT 21H                 ; DOS interrupt
    
    ; Get input for string  
    MOV AH, 0AH             ; String input subroutine
    LEA DX, STR1            ; Load address of string
    MOV STR1, 70            ; Set string size
    INT 21H                 ; DOS interrupt
    
    ; Calculate string length
    MOV SI, OFFSET STR1 + 1 ; Get String input length
    MOV CL, [SI]            ; Store length in CL rgeister
    MOV CH, 0
    MOV WORD PTR LEN1, CX   ; Store length to LEN1 variable
    
    ; Display input msg for pattern             
    LEA DX, MSG2            ; Get offset address
    MOV AH, 09H             ; String display subroutine
    INT 21H                 ; DOS interrupt
    
    ; Get input for pattern
    MOV AH, 0AH             ; String input subroutine
    LEA DX, STR2            ; Load address of string
    MOV STR2, 70            ; Set string size
    INT 21H                 ; DOS interrupt   
    
    ; Calculate pattern length
    MOV SI, OFFSET STR2 + 1 ; Get String input length
    MOV CL, [SI]
    MOV CH, 0
    MOV WORD PTR LEN2, CX

    ; First index is used to store array length (70 max here), 2nd is used to store string length
    ; Thus we calculate from STR1+2 to get memory address of 1st character in string
    LEA SI, STR1+2          ; Store the memory address of STR1 in SI
    LEA DI, STR2+2          ; Store the memory address of STR2 in DI
    MOV DX, LEN1            ; Store the length of the string in DX
    MOV CX, LEN2            ; Store the length of the substring in CX
    CMP CX, DX              ; comparing main & substring length
    JA EXIT                 ; (Jump Above), if substring (CX) size is bigger than main string (DX), there is no chance to be found in the main string
    JE SAMELENGTH           ; (Jump Equal/ Jump Zero (JZ)) if the main string & substring have the same length, we can compare them directly
    JB FIND                 ; general case (substring length < main string length): we can apply our main process

    SAMELENGTH:
        CLD                 ; Clear Direction Flag (DF) to increment SI and DI after each comparison
        REPE CMPSB          ; It compares the byte at [SI] with the byte at [DI] and sets the Zero Flag (ZF) if they are equal.
                            ; If the ZF flag is set (i.e., the bytes are equal), it increments SI and DI to point to the next bytes in memory.
                            ; It repeats steps 1 and 2 until the ZF flag is cleared (i.e., the bytes being compared are not equal) or the count in CX reaches zero.
        JNE NOT_FOUND       ; Jump if not equal
        JMP FOUND           ; else Jump (if equal)

    FIND:
        MOV AL, [SI]        ; storing the ASCII value of the current character of the main string
        MOV AH, [DI]        ; storing the ASCII value of the current character of the substring
        CMP AL, AH          ; comparing both characters
        JE CHECK
        JNE NOTEQL

    NOTEQL:
        INC SI              ; if both characters don't match, then we would point to the next char of the main string
        DEC DX              ; DX keeps track of how many characters of the main string are left to process
        JZ NOT_FOUND        ; if no characters are left in the main string, then obviously the substring doesn't exist in the main string
        JMP FIND

    CHECK:
        MOV CX, LEN2        ; CX is used internally for REPE CMPSB.
                            ; Storing the length of the substring in CX would limit the number of characters for comparison to the exact length of the substring.
                            ; For example, to compare between "madam" & "ada", we need to compare *ada* portion of the main string with the substring ada, no more, no less
        MOV BX, SI          ; storing the index of the current character of the main string in BX so if the following REPE CMPSB finds a mismatch,
                            ; then the process can be started over from the next character of the main string (SEE line 1 of TEMP_NOT_FOUND) by going to TEMP_NOT_FOUND > FIND
        INC BX              ; increment the index in BX
        CLD
        REPE CMPSB
        JNE TEMP_NOT_FOUND
        JMP FOUND

    TEMP_NOT_FOUND:         ; substring not found starting from the current character of the main string,
                            ; but it is possible to find a match if we start from the next character in the main string
        MOV SI, BX          ; going to the next character of the main string (after REPE CMPSB of CHECK segment)
        DEC DX
        LEA DI, STR2        ; reloading the substring index in DI (after REPE CMPSB of CHECK segment)
        JMP FIND            ; if a character matches but the following substring mismatches in the main string, then
                            ; we start over the same process from the next character of the main string by going to FIND segment

    FOUND:
        LEA DX, FOUND_MSG
        JMP DISPLAY

    NOT_FOUND:
        LEA DX, NOT_FOUND_MSG
        JMP DISPLAY
          
    DISPLAY:
        MOV AH, 9H           ; Control signal sent for display
        INT 21H              ; Interrupt signal to show output
        JMP EXIT
        
    EXIT:
        HLT
        ret
.data:
    MSG1 DB "Enter string to search: $"             ; Show the message on the screen
    STR1 DB 100 DUP('$')                            ; Create a string of 100 bytes
    LEN1 DW 0                                       ; Store the length of the string
    MSG2 DB 13, 10, "Enter pattern: $"              
    STR2 DB 100 DUP('$')                            
    LEN2 DW 0 
    FOUND_MSG DB 13, 10, "Found Pattern!$"               ; 13 is used to move the cursor to the beginning of the next line,
    NOT_FOUND_MSG DB 13, 10, "Can't find Pattern!$" ; 10 is used to move the cursor to the beginning of the next line         
