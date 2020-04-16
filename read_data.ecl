import Std;

FutureRecord := RECORD
    string crop;
    unsigned1 year;
    unsigned1 month;
    unsigned1 day;
    decimal8_3 open;
    decimal8_3 close;
    real4 open_net;
    real4 open_rel;
    real4 close_net;
    real4 close_rel;
    real4 volume;
    real4 openint;
    string date;
END;

topdir := '/home/vin/Work/price/FarmationCodes/data/barchart';
crop := 'corn';
base := 'zch03_price-history.csv';

fname := topdir + '/' + crop + '/' + base;

RawRecord := record
    string date;
    decimal8_3 open;
    decimal8_3 high;
    decimal8_3 low;
    decimal8_3 last;
    real4 change;
    unsigned volume;
    unsigned openint;    
end;

rawdata := dataset(fname, RawRecord, CSV(HEADING(1)));

last_row := rawdata[sizeof(rawdata)];
output(last_row);


// transform raw csv data into future record
FutureRecord parseRawFuture(RawRecord l) := transform
    self.crop := crop;
    date := Std.Date.FromStringToDate(l.date, '%m/%d/%Y');
    self.year := date.year;
end;
