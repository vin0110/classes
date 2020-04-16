// convert local price data files into DFS files
import Std;

LocalRecord := RECORD
    Std.Date.Date_t date;
    STRING25 location;
    DECIMAL8_2 price;
END;

Local_CSV_Record := RECORD
    STRING lineno;
    STRING date;
    STRING location;
    DECIMAL8_2 price;
END;

fname := '/home/vin/Research/croperator/data/soy_updated.csv';
//fname := '~::soy_local.csv';
ds := DATASET(fname, Local_CSV_Record, CSV(HEADING(1)));

LocalRecord tolocalrecord(Local_CSV_Record l) := TRANSFORM
  date := Std.Date.FromStringToDate(l.date, '%Y-%m-%d');
  SELF.date := date; 
  SELF.location := l.location;
  self.price := l.price;
END;

localDataSet := PROJECT(ds, tolocalrecord(LEFT));

OUTPUT(localDataSet);
//OUTPUT(localDataSet, , 'localprices::soy.dat', OVERWRITE);
