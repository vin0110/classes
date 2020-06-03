IMPORT $,$.Dictionaries, STD;


$.Records.ContractLayout transformToFinalFormat(
                                                $.Records.RawTypeTurtleRecord pInput,
                                                $.Records.midlevelDS individualRec)
:= Transform, SKIP(STD.Str.CompareIgnoreCase( pInput.Date, 'date') = 0)
   String tempName := STD.STr.RemoveSuffix(individualRec.filename, '.txt');
   Integer contractMonth := Dictionaries.Month_code_DCT(STD.Str.ToUpperCase(tempName[length(tempName)]));
   temp := STD.STr.RemoveSuffix(tempName, tempName[length(tempName)]);
   Integer tempYear := (Integer)temp[length(temp)-1..length(temp)];
   Integer contractYear := IF(tempYear >= 50, tempYear+1900, tempYear+2000);
   contractDate := STD.Date.FromStringToDate('' + contractMonth + '/' + contractYear, '%m/%Y');
   tempCrop := STD.STr.RemoveSuffix(temp, temp[length(temp)-1..length(temp)]);
   lastEntry := individualRec.lastentry;
   dateFormat := IF(STD.Date.FromStringToDate(lastEntry.Date, '%m/%d/%Y') = 0, '%y%m%d', '%m/%d/%Y');

   lastEntryDate := STD.Date.FromStringToDate(lastEntry.Date, dateFormat);
   SELF.DATE :=  STD.Date.FromStringToDate(pInput.Date, dateFormat);
   SELF.FinalOpen := lastEntry.Open;
   SELF.FinalClose := lastEntry.Close;
   SELF.DaysToExpire := STD.Date.DaysBetween( SELF.Date, lastEntryDate);
   SELF.ContractMonth := STD.Date.Month(contractDate);
   SELF.ContractYear := STD.Date.Year(contractDate);
   SELF := pInput;
   SELF.Crop := tempCrop[length(tempCrop)]
END ;

String superfilename := '' : Stored('superfilename');
SubFiles := NOTHOR(STD.File.SuperFileContents('~'+superfilename));

$.Records.midlevelDS mdt($.Records.midlevelDS L) := TRANSFORM
 SELF.filename := L.filename;
 Self.lastentry := L.lastentry;
END;

NestedDS := PROJECT(SubFiles,
               TRANSFORM($.Records.NestedDS_Record,
                           ds := DATASET('~'+ LEFT.name,$.Records.RawTypeTurtleRecord,CSV);
                           SELF.file := ds;//[2..];
                           $.Records.midlevelDS mds := PROJECT(DATASET([{LEFT.name,ds[COUNT(ds)]}],$.Records.midlevelDS),mdt(LEFT));
                           SELF.individualRec := mds
                           ));

finalContent := NORMALIZE(NestedDS,LEFT.file,transformToFinalFormat(RIGHT,LEFT.individualRec[1]));

Output(finalContent,,'~'+superfilename + '_formatted',OVERWRITE);

