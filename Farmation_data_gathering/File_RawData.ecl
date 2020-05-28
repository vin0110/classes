IMPORT $;
String filename := '' : Stored('filename');
// OUTPUT(filename);
// c00h.txt'
EXPORT File_RawData :=
DATASET('~test::TBD::'+filename,$.Records.RawTypeTurtleRecord,CSV);
// OUTPUT(File_RawData)