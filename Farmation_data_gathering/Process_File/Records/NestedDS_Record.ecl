IMPORT $;

EXPORT NestedDS_Record := RECORD
 DATASET($.midlevelDS) individualRec;
 DATASET($.RawTypeTurtleRecord) file;
END;