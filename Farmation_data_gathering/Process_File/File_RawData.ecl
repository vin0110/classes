IMPORT $;
String filename := '' : Stored('filename');
// File_RawData1 :=
// DATASET('~test::TBD::'+filename,$.Records.RawTypeTurtleRecord,CSV);
// OUTPUT(File_RawData1);
EXPORT File_RawData := DATASET('~test::TBD::'+filename,$.Records.RawTypeTurtleRecord,CSV);;