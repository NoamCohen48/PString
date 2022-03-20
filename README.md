# PString
Implementation in Assembly of Pstring data structure (Pascal String) and multiple functions. 

# C code representation
```
typedef struct {
	char len;
	char str[255];
} Pstring;


char pstrlen(Pstring* pstr);
- returns the len of the pstring

Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar);
- replacing every instance of oldChar with newChar in a given pstring

Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j);
- copy all characters from src to dst pstring from index i to j (include)

Pstring* swapCase(Pstring* pstr);
- replace all lower case with uppercase and vice versa

int pstrijcmp(Pstring* pstr1, Pstring* psrt2, char i, char j);
- compare pstrings from index i to j and 1 if pstr1 larger, -1 if psrt2 grater and 0 if equal (alphabetical order)
```
