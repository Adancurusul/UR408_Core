#include<stdio.h>

static char const *program_ptr, *ptr, *nextptr, *startptr;//用于词法分析的指针

static char *binstart ,*binnow ;

typedef enum 
{
    ERR,
    END,
    ID,
    NUM,STR,
    R0,R1,R2,R3,R4,R5,R6,R7,
    //STATU,CPC,EPC,IE,TVEC0,TVEC1,TVEC2,TVEC3,
    OPERATOR,
    KW_SEC,KW_GLB,KW_EQU,KW_TIMES,KW_DB,KW_DD,KW_DW,
    COMMA,
    SEMICOLON,
    PLUS,
    MINUS,
    AND,
    OR,
    ASTRISK,
    SLASH,
    PERCENT,
    LEFTBRACKET,
    RIGHTBRACKET,


}TAG;
typedef enum OPERATOR
{
    KADD,KSUB,KAND,KOR,KXOR,KSR,KSL,KSRA,KSLT,KSLTU,KEQ,KNEQ,
    KBRA0,
    KJL,KAPC,KJMP,KWCR,KRCR,KRET,KFENCE,
    KLI,KLB,KSB,
};

typedef struct keyword_token
{
    char *keyword;
    int tag;
} KEYS_OPERATOR;

const KEYS_OPERATOR KEYWORDS_OPERATOR[] = {
    {"add",KADD},
    {"sub",KSUB},
    {"and",KAND},
    {"or",KOR},
    {"xor",KXOR},
    {"sr",KSR},
    {"sl",KSL},
    {"sra",KSRA},
    {"slt",KSLT},
    {"sltu",KSLTU},
    {"eq",KEQ},
    {"neq",KNEQ},
    {"bra0",KBRA0},
    {"jl",KJL},
    {"apc",KAPC},
    {"jmp",KJMP},
    {"wcr",KWCR},
    {"rcr",KRCR},
    {"ret",KRET},
    {"fence",KFENCE},
    {"li",KLI},
    {"lb",KLB},
    {"sb",KSB},
};


int main(){
    int line = 10;
    unsigned char binarray[line*2]; 
    binarray[0]=12;
    binnow = binarray;
    binnow++;
    * binnow = 255;
    
    printf("%d",* binnow);
}