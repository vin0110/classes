IMPORT STD;

EXPORT ContractLayout := RECORD
 INTEGER2  ContractMonth;
 INTEGER4  ContractYear;
 INTEGER4 DaysToExpire;
 STD.Date.Date_t Date;
 DECIMAL Open;
 DECIMAL High;
 DECIMAL Low;
 DECIMAL Close;
 INTEGER Volume;
 INTEGER OpenInt;
 DECIMAL FinalOpen;
 DECIMAL FinalClose;
END;