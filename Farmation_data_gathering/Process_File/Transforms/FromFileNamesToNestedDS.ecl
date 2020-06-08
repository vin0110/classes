IMPORT $, $.^.Records;
EXPORT Records.NestedDS_Record FromFileNamesToNestedDS(String filename) := TRANSFORM
    ds := DATASET('~'+ filename,Records.RawTypeTurtleRecord,CSV);
    SELF.file := ds;//[2..];
    Records.midlevelDS mds := PROJECT(DATASET([{filename,ds[COUNT(ds)]}],Records.midlevelDS),$.mdt(LEFT));
    SELF.individualRec := mds
END;
