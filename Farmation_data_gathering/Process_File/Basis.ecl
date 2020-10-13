import std,$.Records;
//  std.date.adjustdate(std.date.today(),-20);
oldDate:= STD.Date.FromStringToDate('2000', '%Y');

rec := RECORD
	STD.Date.Date_t  date;
    STRING location_city;
    STRING field3;
    STRING commodity;
    STRING field5;
    Decimal price;
END;
fn := '~test::mars::ra_gr110_fixed';
ds := Dataset(fn,recordof(fn,rec,lookup),flat);
marsds := ds(location_city='Candor',field3='feed_mill',commodity='corn',field5='cash');
output(sort(marsds,date),,'~test::basis::marsPrices',thor,overwrite);

fn2 := '~test::tbd::cme::cumulative::corn';
ds2:=Dataset(fn2,records.ContractLayout,flat);
dsSame := ds2(date>oldDate,contractyear = std.date.year(date), std.date.month(date)=contractmonth);
subds := ds2(date>oldDate) - dsSame;

dates := Table(subds,{date},date);
cmeDS := DENORMAlize(dates, subds, LEFT.date=RIGHT.date, group, TRANSFORM(Records.ContractLayout,
                                                                        subdata := Rows(RIGHT);
                                                                        entry := sort(subdata,daystoexpire)[1];
                                                                         SELF := entry));
OUTPUT(sort(cmeds,date),,'~test::basis::cmePrices',thor,overwrite);


basisrec := RECORD
	STD.Date.Date_t  date;
    STRING location_city;
    STRING commodity;
    Decimal basis;
END;

// basisds := DENORMAlize(marsds, cmeDS, LEFT.date=RIGHT.date,group, TRANSFORM(basisrec,
//                                                                         self.basis := LEFT.price-(rows(Right)[1].close/100);
//                                                                          SELF := LEFT));

basisds := JOIN(marsds,cmeDS, 
 LEFT.date=RIGHT.date
 ,transform(basisrec, 
            self.basis := LEFT.price/(Right.close/100);
            SELF := LEFT;
),INNER);


// DENORMAlize(marsds(date=20020218), cmeDS, LEFT.date=RIGHT.date,group, TRANSFORM(basisrec,Skip(Left.price=0),
                                                                        // self.basis := LEFT.price-(rows(Right)[1].close/100);
                                                                        //  SELF := LEFT));

OUTPUT(sort(basisds,date),,'~test::basis::basisRelative',thor,overwrite);

avgRec := RECORD
	// STD.Date.Date_rec date:= Record
    //     INTEGER2    year:= 0;

    // end;
    UNSIGNED1   month:=STD.Date.Month(basisds.date);
    UNSIGNED1   day := STD.Date.day(basisds.date);
	// STD.Date.Date_rec.month month:=STD.Date.Month(date);
    basisds.location_city;
    basisds.commodity;
    Decimal averageBasis :=  AVE(GROUP, basisds.basis);
END;

crossTabDs := TABLE(basisds, avgRec, STD.Date.day(date),STD.Date.Month(date));
OUTPUT(sort(crossTabDs,month,day),,'~test::basis::Avg_basisRelative',thor,overwrite);
