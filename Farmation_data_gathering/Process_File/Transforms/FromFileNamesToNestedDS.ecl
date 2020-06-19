IMPORT $, $.^.Records;
EXPORT Records.NestedDS_Record FromFileNamesToNestedDS(String filename) := TRANSFORM
    ds := DATASET('~'+ filename,Records.RawTypeTurtleRecord,CSV);
    SELF.file := ds;//[2..];
    Records.filename_lastEntry_Record mds := PROJECT(DATASET([{filename,ds[COUNT(ds)]}],Records.filename_lastEntry_Record),
                                        TRANSFORM(Records.filename_lastEntry_Record,
                                        SELF := LEFT));
    SELF.individualRec := mds
END;
