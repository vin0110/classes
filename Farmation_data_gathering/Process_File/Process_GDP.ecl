IMPORT $.Records;

tempDS := DATASET('~test::TBD::GDP.csv', Records.GDP_Record, CSV);
OUTPUT(tempDS,,'~test::TBD::GDP',overwrite);
