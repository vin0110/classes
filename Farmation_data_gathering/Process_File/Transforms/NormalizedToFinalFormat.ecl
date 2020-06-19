IMPORT $, $.^.Records, $.^.Dictionaries, STD;

EXPORT Records.ContractLayout NormalizedToFinalFormat(
                                                Records.RawTypeTurtleRecord pInput,
                                                Records.filename_lastEntry_Record individualRec)
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
