# Summary of Pattern Matching Program
- ## Introduction
  The program we are working on aims to implement a string search algorithm in 8086 assembly language. Its purpose is to search for a specific pattern within a larger input string and provide feedback on whether the pattern is found or not.

  The program will prompt the user to enter an input string and a pattern string. We will then compare the pattern with the input string using a character-by-character matching approach. If the pattern is found within the input string, the program will display a message indicating that the pattern has been found. If the pattern is not found, the program will display a message indicating that the pattern could not be found in the input string.

  This program can be useful in various applications, such as text processing, data analysis, and information retrieval. It provides a basic foundation for performing string searches and can be expanded upon to suit specific needs.

  By implementing this program, we will be able to search for specific patterns within strings and obtain feedback on their presence or absence. This can be valuable for tasks that involve searching and analyzing textual data.
- ## Explanantion  
  - ### Get User Input
    - ```assembly
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
      ```
    - #### Variables initialisation
      ```assembly
      .data:
      MSG1 DB "Enter string to search: $"             ; Show the message on the screen
      STR1 DB 100 DUP('$')                            ; Create a string of 100 bytes
      LEN1 DW 0                                       ; Store the length of the string
      MSG2 DB 13, 10, "Enter pattern: $"              
      STR2 DB 100 DUP('$')                            
      LEN2 DW 0 
      FOUND_MSG DB 13, 10, "Found Pattern!$"               ; 13 is used to move the cursor to the beginning of the next line,
      NOT_FOUND_MSG DB 13, 10, "Can't find Pattern!$" ; 10 is used to move the cursor to the beginning of the next line 
      ```

  - ### CODE
    - ```assembly
      LEA SI, STR1;           Store the memory address of STR1 in SI
      LEA DI, STR2;           Store the memory address of STR2 in DI
      MOV DX, LEN1;           Store the length of string in DX
      MOV CX, LEN2;           Store the length of substring in CX
      CMP CX, DX;             comparing main & substring length
      JA EXIT;                if substring size is bigger than there is no chance to be found it in main string
      JE SAMELENGTH;          if main & sub string both have same length the we can compare them directly
      JB FIND;                general case (substring length < mainstring length): we can apply our main process  
      ```
    - #### Why is LEA used instead of MOV?
      <details>
        <summary>LEA loads the memory offset address instead of actual value we don't want value of STR1, STR2. Rather we want their Address location.</summary>
      In the given code snippet, the LEA instruction is used to load the effective address of a memory operand into a register. Let's examine the lines: 

      ```assembly
      LEA SI, STR1
      LEA DI, STR2
      ```
      Here, LEA SI, STR1 loads the effective address of the STR1 variable into the SI register, and LEA DI, STR2 loads the effective address of the STR2 variable into the DI register.

      The LEA (Load Effective Address) instruction is commonly used to calculate and load the offset of a memory operand into a register without actually dereferencing or accessing the memory location. It allows us to perform arithmetic operations on the address of a variable and store the resulting address in a register.

      In this case, LEA is used instead of MOV because we want to load the addresses of the strings STR1 and STR2, not their values. Using MOV with the immediate mode (MOV SI, OFFSET STR1) would result in loading the actual value of STR1 into the SI register rather than its address.

      By loading the addresses of the strings into the SI and DI registers, they can be used as source (SI) and destination (DI) indices for string operations like string comparison, concatenation, or any other string manipulation tasks.
      </details>
  - ### SAME LENGTH
    - ```assembly
      SAMELENGTH:
          CLD
          REPE CMPSB
          JNE NOT_FOUND
          JMP FOUND
      ```
    - <details>
      <summary>Here's how the REPE CMPSB instruction works:</summary>

      It compares the byte at [SI] with the byte at [DI] and sets the Zero Flag (ZF) if they are equal.

      If the ZF flag is set (i.e., the bytes are equal), it increments SI and DI to point to the next bytes in memory.

      It repeats steps 1 and 2 until the ZF flag is cleared (i.e., the bytes being compared are not equal) or the count in CX reaches zero.
      </details>
      
- ## Conclusion
  In conclusion, our project has involved the development of an assembly program for pattern matching. This program allows us to search for specific patterns within input strings and determine their presence or absence.

  Throughout the project, we have gained valuable insights into string manipulation and algorithm design in the context of assembly language. By implementing this pattern matching program, we have learned important concepts such as prompting the user for input, calculating string lengths, comparing characters, and handling different scenarios based on the comparison results.

  While the program does not utilize the famous Knuth-Morris-Pratt (KMP) algorithm, it serves as a practical exercise in low-level programming and assembly language. It has provided us with a deeper understanding of memory management, register usage, and control flow manipulation.

  Completing this project has not only allowed us to achieve our goal of implementing a pattern matching program, but it has also expanded our knowledge and competence in assembly programming. The program can be further developed and enhanced to suit specific requirements and applications that involve string manipulation and analysis.

  Overall, this project has been a valuable learning experience, reinforcing our understanding of assembly language programming and its applications in pattern matching.

- ## References

- https://github.com/AhmadNaserTurnkeySolutions/emu8086
- https://www.youtube.com/watch?v=BjI9Ypz09RA
- https://codereview.stackexchange.com/questions/60389/checking-substring-in-8086-asm
- https://stackoverflow.com/questions/45367779/how-to-print-the-length-of-a-string-in-assembly
- https://github.com/AM-ash-OR-AM-I/assembly-pattern-match (We created this repository for our Project files and other code work.)