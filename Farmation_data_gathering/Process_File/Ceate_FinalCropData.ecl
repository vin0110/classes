IMPORT $,$.Dictionaries, STD;

namesRec := RECORD
 STRING fname;
END;

$.Records.ContractLayout transformToFinalFormat(
                                                namesRec filename,
                                                $.File_RawData pInput)
:= Transform
   String tempName := STD.STr.RemoveSuffix(filename.fname, '.txt');
   Integer contractMonth := Dictionaries.Month_code_DCT(STD.Str.ToUpperCase(tempName[length(tempName)]));
   temp := STD.STr.RemoveSuffix(tempName, tempName[length(tempName)]);
   Integer tempYear := (Integer)temp[length(temp)-1..length(temp)];
   Integer contractYear := IF(tempYear >= 50, tempYear+1900, tempYear+2000);
   contractDate := STD.Date.FromStringToDate('' + contractMonth + '/' + contractYear, '%m/%Y');

   SELF.DATE :=  STD.Date.FromStringToDate(pInput.Date, '%m/%d/%Y');
   SELF.ContractMonth := STD.Date.Month(contractDate);
   SELF.ContractYear := STD.Date.Year(contractDate);
   SELF := pInput;
   SELF := [];
END ;

String filename := '' : Stored('filename');
namesTable := DATASET([{filename}], namesRec);


fJoin(dataset(namesRec) filename) := join(filename, DATASET('~test::TBD::c00k.txt',$.Records.RawTypeTurtleRecord,CSV)[2..],
                                          TRUE,
                                          transformToFinalFormat(left, right)
                                       );
finalData := loop(namesTable, count(namesTable), fJoin(rows(left)));

