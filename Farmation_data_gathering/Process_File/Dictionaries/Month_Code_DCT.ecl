Month_Codes := DATASET([{'H', 3}, 
    {'K', 5}, 
    {'F', 1}, 
    {'Q', 8}, 
    {'X', 11}, 
    {'U', 9}, 
    {'N', 7}, 
    {'Z', 12}], {STRING code, Integer month});

Month_Code := DICTIONARY(Month_Codes,{Code => month});
EXPORT  Month_Code_DCT(STRING code) := Month_Code[code].month;

// OUTPUT(MapColor2Code('Red')); //2
// OUTPUT(MapCode2Color(4)); /