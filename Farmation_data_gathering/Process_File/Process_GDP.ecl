IMPORT $.Records;

abc := DATASET('~test::TBD::GDP.csv', Records.GDP_Record, CSV);
OUTPUT(abc,,'~test::TBD::GDP',overwrite);
