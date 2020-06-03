IMPORT $,$.Dictionaries, STD;

EXPORT $.Records.ContractLayout transformation($.Records.RawTypeTurtleRecord pInput,
                                                STD.Date.Date_t lastEntryDate,
                                                STD.Date.Date_t contractDate, 
                                                $.File_RawData lastEntry) 
:= TRANSFORM
   SELF.DATE :=  STD.Date.FromStringToDate(pInput.Date, '%m/%d/%Y');
   SELF.FinalOpen := lastEntry.Open;
   SELF.FinalClose := lastEntry.Close;
   SELF.DaysToExpire := STD.Date.DaysBetween( SELF.Date, lastEntryDate);
   SELF.ContractMonth := STD.Date.Month(contractDate);
   SELF.ContractYear := STD.Date.Year(contractDate);
   SELF := pInput;
//    SELF.Open := pInput.Open;
//    SELF.High := pInput.High;
//    SELF.Low := pInput.Low;
//    SELF.Close := pInput.Close;
//    SELF.Volume := pInput.Volume;
//    SELF.OpenInt := pInput.OpenInt;
END;
