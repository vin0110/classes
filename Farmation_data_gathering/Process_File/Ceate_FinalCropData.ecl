IMPORT $,$.Dictionaries, STD;


$.Records.ContractLayout transformToFinalFormat(
                                                $.Records.RawTypeTurtleRecord pInput,
                                                $.Records.midlevelDS individualRec)
:= Transform
   String tempName := STD.STr.RemoveSuffix(individualRec.filename, '.txt');
   Integer contractMonth := Dictionaries.Month_code_DCT(STD.Str.ToUpperCase(tempName[length(tempName)]));
   temp := STD.STr.RemoveSuffix(tempName, tempName[length(tempName)]);
   Integer tempYear := (Integer)temp[length(temp)-1..length(temp)];
   Integer contractYear := IF(tempYear >= 50, tempYear+1900, tempYear+2000);
   contractDate := STD.Date.FromStringToDate('' + contractMonth + '/' + contractYear, '%m/%Y');
   lastEntry := individualRec.lastentry;
   lastEntryDate := STD.Date.FromStringToDate(lastEntry.Date, '%m/%d/%Y');

   SELF.DATE :=  STD.Date.FromStringToDate(pInput.Date, '%m/%d/%Y');
   SELF.FinalOpen := lastEntry.Open;
   SELF.FinalClose := lastEntry.Close;
   SELF.DaysToExpire := STD.Date.DaysBetween( SELF.Date, lastEntryDate);
   SELF.ContractMonth := STD.Date.Month(contractDate);
   SELF.ContractYear := STD.Date.Year(contractDate);
   SELF := pInput;
END ;

SubFiles := STD.File.SuperFileContents('~test::TBD::sfcorn');

$.Records.midlevelDS mdt($.Records.midlevelDS L) := TRANSFORM
 SELF.filename := L.filename;
 Self.lastentry := L.lastentry;
END;

NestedDS := PROJECT(SubFiles,
               TRANSFORM($.Records.NestedDS_Record,
                           ds := DATASET('~'+ LEFT.name,$.Records.RawTypeTurtleRecord,CSV);
                           SELF.file := ds[2..];
                           $.Records.midlevelDS mds := PROJECT(DATASET([{LEFT.name,ds[COUNT(ds)]}],$.Records.midlevelDS),mdt(LEFT));
                           SELF.individualRec := mds
                           // SELF.individualRec.lastentry := ds[1]
                           ));

finalContent := NORMALIZE(NestedDS,LEFT.file,transformToFinalFormat(RIGHT,LEFT.individualRec[1]));

Output(finalContent,,'~test::TBD::' + 'nestedsfcontents',OVERWRITE);



// namesRec := RECORD
//  STRING fname;
// END;


// String filename := '' : Stored('filename');
// namesTable := DATASET([{filename}], namesRec);


// fJoin(dataset(namesRec) filename) := join(filename, DATASET('~test::TBD::c00k.txt',$.Records.RawTypeTurtleRecord,CSV)[2..],
//                                           TRUE,
//                                           transformToFinalFormat(left, right)
//                                        );
// // finalData := loop(namesTable, count(namesTable), fJoin(rows(left)));

