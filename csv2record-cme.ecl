// convert cme data files into DFS files
import Std;
import Std;

// select different crop with -Xcrop=<crop> command line options to `ecl run`
// Eg, `ecl run hthor this_file.ecl -Xcrop=soybeans`

/**********************
 * Parameters
 */
crop := 'corn': stored('crop');

topdir := '/home/vin/Work/price/FarmationCodes/data/barchart';
base := 'zch03_price-history.csv';

//fin := '~rawcsv::cme::' + crop + '.csv';
//fout := 'cmeprices::' + crop + '.dat';

fname := topdir + '/' + crop + '/' + base;

/**********************
 * records
 */
FutureRecord := RECORD
    string crop;
    unsigned2 year;
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
    integer date;
    string rawdate;
END;

RawRecord := record
    string rawdate;
    decimal8_3 open;
    decimal8_3 high;
    decimal8_3 low;
    decimal8_3 close;
    real4 change;
    unsigned volume;
    unsigned openint;    
end;

DatedRecord := record
    integer date;
    RawRecord;
end;

/**********************
 * actions & transform
 */

/**********************
 * add a date field to the raw data
 * this is necessary in order to find the latest date (the contract date).
 */
DatedRecord addDate(RawRecord l) := transform
    self.date := Std.Date.FromStringToDate(l.rawdate, '%m/%d/%Y');
    self := l;
end;

/**********************
 * read raw data, add date, sort, and extract the contract date.
 * in barchart data the last row is a comment -- so throw it away
 */
rawdata_all := dataset(fname, RawRecord, CSV(HEADING(1)));
rawdata := rawdata_all[1..count(rawdata_all)-1];

sorteddata := SORT(project(rawdata, addDate(left)), date);
final := sorteddata[count(sorteddata)];
contract_year := final.date div 10000;
contract_month := (final.date % 10000) div 100;
output(final);
output(final.date);
output(contract_year);
output(contract_month);
output(final.close);

/**********************
 * transform dated csv data into future record
 */
FutureRecord parseFuture(DatedRecord l) := transform

    self.crop := crop;
    self.year := contract_year;
    self.month := contract_month;
    self.day := STD.Date.DaysBetween(l.date, final.date);
    self.open_net := l.open - final.close;
    self.close_net := l.close - final.close;
    self.open_rel := l.open / final.close;
    self.close_rel := l.close / final.close;

    self := l;
end;

ds := project(sorteddata, parseFuture(left));
output(ds[1..10]);

/**********************
 * fill in missing values
 * if there is a date gap betwen two consecutive rows, then fill that gap
 * with deplicates of the previous record.
 */
FutureRecord fillMissing(FutureRecord l, FutureRecord r) := transform
    // no idea how to do this
end;