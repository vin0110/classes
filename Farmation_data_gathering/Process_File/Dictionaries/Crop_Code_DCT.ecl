Crop_Codes := DATASET([{'c', 'corn'}, 
    {'s', 'soybeans'}, 
    {'w', 'wheat'}], {STRING code, String crop});

Crop_Code := DICTIONARY(Crop_Codes,{Code => crop});
EXPORT  Crop_Code_DCT(STRING code) := Crop_Code[code].crop;

// OUTPUT(MapColor2Code('Red')); //2
// OUTPUT(MapCode2Color(4)); /