DATA SEGMENT
STR1 DB 'MADAM'
LEN1 DW ($-STR1);       storing the length of STR1
STR2 DB 'MADA'
LEN2 DW ($-STR2);       stroing the length of STR2
DATA ENDS

CODE SEGMENT

LEA SI, STR1
LEA DI, STR2
MOV DX, LEN1
MOV CX, LEN2
CMP CX, DX;             comparing main & substring length
JA EXIT;                if substring size is bigger than there is no chance to be found it in main string
JE SAMELENGTH;          if main & sub string both have same length the we can compare them directly
JB FIND;                general case (substring length < mainstring length): we can apply our main process                 

SAMELENGTH:
        CLD
        REPE CMPSB
        JNE RED
        JMP GREEN

FIND:        
        MOV AL, [SI];   storing the ascii value of current character of mainstring 
        MOV AH, [DI];   storing the ascii value of current character of substring
        CMP AL,AH;      comparing both character
        JE CHECK;       
        JNE NOTEQL

NOTEQL:
        INC SI;         if both character don't match then we would point to the next char of main string
        DEC DX;         DX keeps track of how many character of mainstring is left to process
        CMP DX, 0000H;  checking if there are any character left in the main string for further comparison 
        JE RED;         if no character is left in main string then obviously the substring doesn't exists in main string
        JMP FIND

CHECK:
        MOV CX, LEN2;   CX is used internally for REPE CMPSB. So storing length of the substring in CX would limit the number of characters for comparison to exact length of substring.
        ;               For example to compare between "madam" & "ada" we need to compare *ada* portion of main string with substring ada, no more, no less     
        MOV SP, SI;     storing the index of current character of main string so if the following REPE CMPSB find mismatch then the process can be started over from the next character of main string (SEE line 1 of TEMPRED) by going to TEMPRED > FIND
        ADD SP, 0001H
        CLD
        REPE CMPSB
        JNE TEMPRED
        JMP GREEN

TEMPRED:;               substring not found starting from the current character of main string, but it is possible to find match if we start from next character in main string
        MOV SI,SP;      going to the next character of main string (after REPE CMPSB of CHECK segment)
        DEC DX
        LEA DI, STR2;   reloading substring index in DI (after REPE CMPSB of CHECK segment)
        JMP FIND;       if a character matches but the following substring mismatches in main string then we start over the same process from the next character of main string by going to FIND segment         

GREEN:  
        MOV BX, 0001H;  substring found
        JMP EXIT


RED:    
        MOV BX, 0000H;  substring not found
        JMP EXIT

EXIT:         
    CODE ENDS
    END
    RET