IMPORT $,$.Dictionaries, STD;

 pInput := $.File_RawData[2..];
 String filename := '' : Stored('filename');
 String tempName := STD.STr.RemoveSuffix(filename, '.txt');
 Integer contractMonth := Dictionaries.Month_code_DCT(STD.Str.ToUpperCase(tempName[length(tempName)]));
//  Output(contractMonth);
 temp := STD.STr.RemoveSuffix(tempName, tempName[length(tempName)]);
 Integer tempYear := (Integer)temp[length(temp)-1..length(temp)];
 contractYear := IF(tempYear >= 50, tempYear+1900, tempYear+2000);
 lastEntry := pInput[COUNT(pInput)];
 contractDate := STD.Date.FromStringToDate('' + contractMonth + '/' + contractYear, '%m/%Y');
//  Output(contractDate);

 lastEntryDate := STD.Date.FromStringToDate(lastEntry.Date, '%m/%d/%Y');
 $.Records.ContractLayout transformToFinalFormat($.File_RawData pInput, 
                                                                $.File_RawData lastEntry, 
                                                                STD.Date.Date_t contractDate, 
                                                                STD.Date.Date_t lastEntryDate)
 := TRANSFORM
    SELF.DATE :=  STD.Date.FromStringToDate(pInput.Date, '%m/%d/%Y');
    SELF.DaysToExpire := STD.Date.DaysBetween( SELF.Date, lastEntryDate);
    SELF.FinalOpen := lastEntry.Open;
    SELF.FinalClose := lastEntry.Close;
    SELF.ContractMonth := STD.Date.Month(contractDate);
    SELF.ContractYear := STD.Date.Year(contractDate);
    SELF := pInput;
    // SELF.Open := pInput.Open;
    // SELF.High := pInput.High;
    // SELF.Low := pInput.Low;
    // SELF.Close := pInput.Close;
    // SELF.Volume := pInput.Volume;
    // SELF.OpenInt := pInput.OpenInt;
 END ;
// OrigDataset := $.Records.File_RawData;
transformedDataset := PROJECT(pInput,transformToFinalFormat(LEFT, lastEntry, contractDate, lastEntryDate));
// OUTPUT(transformedDataset);
OUTPUT(transformedDataset,,'~test::TBD::' + tempName,OVERWRITE);