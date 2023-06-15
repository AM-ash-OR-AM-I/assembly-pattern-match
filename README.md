## Summary of Pattern Matching Program
- ### DATA SEGMENT
  - ```assembly
    DATA SEGMENT
    STR1 DB 'MADAM';        Getting input for the string
    LEN1 DW ($-STR1);       Storing the length of STR1
    STR2 DB 'MADA';         Getting input for the search pattern
    LEN2 DW ($-STR2);       Storing the length of STR2
    DATA ENDS
    ```
  - `STR1` is a data variable declared as a byte array (DB) and initialized with the string "MADAM". It represents the first string that will be used in the program.
  - `LEN1` is a data variable declared as a word (DW). It stores the length of `STR1` using the $ operator. The $ operator represents the current address, and `$-STR1` gives the distance between the current address and the start of `STR1`, which corresponds to the length of the string.
  - `STR2` is another data variable declared as a byte array (DB) and initialized with the string "MADA". It represents the second string.
  - `LEN2` is a data variable declared as a word (DW). Similar to LEN1, it stores the length of STR2 using the $ operator.
  - 
- ### CODE SEGMENT
  - ```assembly
    CODE SEGMENT
    
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
        JNE RED
        JMP GREEN
    ```
  - <details>
    <summary>Here's how the REPE CMPSB instruction works:</summary>

    It compares the byte at [SI] with the byte at [DI] and sets the Zero Flag (ZF) if they are equal.

    If the ZF flag is set (i.e., the bytes are equal), it increments SI and DI to point to the next bytes in memory.

    It repeats steps 1 and 2 until the ZF flag is cleared (i.e., the bytes being compared are not equal) or the count in CX reaches zero.
    </details>