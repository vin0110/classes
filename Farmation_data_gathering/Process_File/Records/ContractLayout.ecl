IMPORT STD;

EXPORT ContractLayout := RECORD
 STRING1 Crop;
 INTEGER2  ContractMonth;
 INTEGER4  ContractYear;
 INTEGER4 DaysToExpire;
 STD.Date.Date_t Date;
 DECIMAL10 Open;
 DECIMAL10 High;
 DECIMAL10 Low;
 DECIMAL10 Close;
 INTEGER Volume;
 INTEGER OpenInt;
 DECIMAL10 FinalOpen;
 DECIMAL10 FinalClose;
END;