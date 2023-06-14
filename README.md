## Summary of DATA SEGMENT from chatgpt
- STR1 is a data variable declared as a byte array (DB) and initialized with the string "MADAM". It represents the first string that will be used in the program.
- LEN1 is a data variable declared as a word (DW). It stores the length of STR1 using the $ operator. The $ operator represents the current address, and $-STR1 gives the distance between the current address and the start of STR1, which corresponds to the length of the string.
- STR2 is another data variable declared as a byte array (DB) and initialized with the string "MADA". It represents the second string.
- LEN2 is a data variable declared as a word (DW). Similar to LEN1, it stores the length of STR2 using the $ operator.