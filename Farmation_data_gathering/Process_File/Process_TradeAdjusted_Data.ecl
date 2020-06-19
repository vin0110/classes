IMPORT $.Records, STD;

tempRec := RECORD
 STRING date;
 DECIMAL10_4 AFEGS;
 DECIMAL10_4 BGS;
 DECIMAL10_4 EMEGS;
END;
tempDS := DATASET('~test::TBD::trade_adjusted.csv', tempRec, CSV);

tempFinal := PROJECT(tempDS[2..], 
                    TRANSFORM(Records.TradeAdjusted_Record, 
                                SELF.date := STD.date.FromStringToDate(LEFT.date, '%Y-%m-%d');
                                SELF := LEFT));

OUTPUT(tempFinal,,'~test::TBD::trade_adjusted',overwrite);
