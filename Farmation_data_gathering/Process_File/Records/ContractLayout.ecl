IMPORT STD;

EXPORT ContractLayout := RECORD
 STRING1 Crop;
 INTEGER2  ContractMonth;
 INTEGER4  ContractYear;
 INTEGER4 DaysToExpire;
 STD.Date.Date_t Date;
 DECIMAL7_3 Open;
 DECIMAL7_3 High;
 DECIMAL7_3 Low;
 DECIMAL7_3 Close;
 INTEGER Volume;
 INTEGER OpenInt;
 DECIMAL7_3 FinalOpen;
 DECIMAL7_3 FinalClose;
END;