import std,$.Records;

#DECLARE (SetString)
#DECLARE (day)
#DECLARE (year)
#SET (SetString, '['); //initialize SetString to [
#SET (year, 2014); //initialize day to 1
#Loop
    #SET (day, 0); //initialize day to 1
    #IF (%year% > 2020)
        #BREAK
    #ELSE
        #LOOP
            #IF (%day% > 363) //if we've iterated 9 times
                #BREAK // break out of the loop
            #ELSE //otherwise
                #APPEND (SetString, '{'+ %'year'% + ',' + %'day'% +'},');
                #SET (day, %day% + 1)
            #END
        #END
        #APPEND (SetString, '{'+%'year'% + ',' + %'day'% +'},'); //add 10th element and closing ]
    #END
    #SET (year, %year% + 1)
#END
#APPEND (SetString, '{'+%'year'% + ',' + %'day'% +'}]'); //add 10th element and closing ]

recdate:={Integer4 year,Integer3 day};
newrecdate:={Integer4 year,Integer3 day,integer2 month,integer2 dom};

tds := DATASET(%SetString%, recdate);
daysOfYears:=project(tds,transform(newrecDate, 
                                    dte:=STD.Date.AdjustDate(STD.Date.FromStringToDate('2015', '%Y'),0,0,left.day);
                              		self.month:=std.date.month(dte);
                              		self.dom:=std.date.day(dte);
                                   self:=left));

oldDate:= STD.Date.FromStringToDate('2014', '%Y');

rec := RECORD
    STD.Date.Date_t  date;
    STRING location_city;
    STRING field3;
    STRING commodity;
    STRING field5;
    Decimal price;
END;
entry:=STD.Str.SplitWords( 
'13	Laurinburg	feed_mill	corn'
, '\t' );
fn := '~test::mars::ra_gr110_fixed';
ds := Dataset(fn,recordof(fn,rec,lookup),flat);
marsds := ds(location_city=entry[2],field3=entry[3],
                commodity=entry[4],field5='cash');
fn1:='~test::basistmp::basis'+entry[1];
fn2:='~test::basisavtmp::Avg_basis'+entry[1];
		
marsjoinedds := JOIN(daysOfYears,marsds, 
 STD.Date.DateFromParts(left.year,left.month,left.dom)=RIGHT.date
 ,transform(rec, 
            self.date := STD.Date.DateFromParts(left.year,left.month,left.dom);
            SELF := right;
            Self:=[];
),LEFT OUTER);

rec marsfiller(rec prev, rec curr):= TRANSFORM
    SELF.date:=curr.date;
    SELF := IF(curr.price=0, prev, curr);
END;
marsfullds := ITERATE(sort(marsjoinedds,date), marsfiller(LEFT,right),local);

output(sort(marsfullds,date),,'~test::basis::marsPrices',thor,overwrite);

fn3 := '~test::tbd::cme::cumulative::wheat';
ds2:=Dataset(fn3,records.ContractLayout,flat);
subds := ds2(date>oldDate);

dates := Table(subds,{contractmonth,date},contractmonth,date);

cmeDS := DENORMAlize(dates, subds, LEFT.date=RIGHT.date and left.contractmonth=right.contractmonth, group, TRANSFORM(Records.ContractLayout,
                                                                        subdata := Rows(RIGHT);
                                                                        entry := sort(subdata,daystoexpire)[1];
                                                                         SELF := entry));

Records.ContractLayout cmejointransform(newrecDate lefta,Records.ContractLayout righta):= transform 
            self.date := STD.Date.DateFromParts(lefta.year,lefta.month,lefta.dom);
            SELF := righta;
            Self:=[];
end;

cmejoinedds3 := JOIN(daysOfYears,cmeds(contractmonth=3), 
 STD.Date.DateFromParts(left.year,left.month,left.dom)=RIGHT.date
 ,cmejointransform(left,right),LEFT OUTER);
cmejoinedds5 := JOIN(daysOfYears,cmeds(contractmonth=5), 
 STD.Date.DateFromParts(left.year,left.month,left.dom)=RIGHT.date
 ,cmejointransform(left,right),LEFT OUTER);
cmejoinedds7 := JOIN(daysOfYears,cmeds(contractmonth=7), 
 STD.Date.DateFromParts(left.year,left.month,left.dom)=RIGHT.date
 ,cmejointransform(left,right),LEFT OUTER);
cmejoinedds9 := JOIN(daysOfYears,cmeds(contractmonth=9), 
 STD.Date.DateFromParts(left.year,left.month,left.dom)=RIGHT.date
 ,cmejointransform(left,right),LEFT OUTER);
cmejoinedds12 := JOIN(daysOfYears,cmeds(contractmonth=12), 
 STD.Date.DateFromParts(left.year,left.month,left.dom)=RIGHT.date
 ,cmejointransform(left,right),LEFT OUTER);

Records.ContractLayout cmefiller(Records.ContractLayout prev, Records.ContractLayout curr):= TRANSFORM
    SELF.date:=curr.date;
    SELF := IF(curr.high=0, prev, curr);
END;
cmefullds3 := ITERATE(cmejoinedds3, cmefiller(LEFT,right),local);
cmefullds5 := ITERATE(cmejoinedds5, cmefiller(LEFT,right),local);
cmefullds7 := ITERATE(cmejoinedds7, cmefiller(LEFT,right),local);
cmefullds9 := ITERATE(cmejoinedds9, cmefiller(LEFT,right),local);
cmefullds12 := ITERATE(cmejoinedds12, cmefiller(LEFT,right),local);

cmefullds:= cmefullds3+cmefullds5+cmefullds7+cmefullds9+cmefullds12;

OUTPUT(sort(cmefullds,date,contractmonth),,'~test::basis::cmePrices',thor,overwrite);

basisrec := RECORD
	STD.Date.Date_t  date;
    STRING20 location_city;
    STRING5 commodity;
    STRING10 elevator_feed;
    Integer2 contractmonth;
    Decimal relativeBasis;
    Decimal additiveBasis;
    Decimal mars;
    Decimal cme;
END;


basisds := JOIN(marsfullds(date>=20150101,date<=20191213),cmefullds(date>=20150101,date<=20191213), 
 LEFT.date=RIGHT.date
 ,transform(basisrec, 
            self.relativeBasis := LEFT.price/(Right.close/100);
            self.additiveBasis := LEFT.price-(Right.close/100);
            self.mars:=left.price;
            self.cme:=right.close/100;
            self.contractmonth := right.contractmonth;
            self.elevator_feed := LEFT.field3;
            SELF := LEFT;
),INNER);


OUTPUT(sort(basisds,date),,fn1,thor,overwrite);

avgRec := RECORD
    UNSIGNED1   month:=STD.Date.Month(basisds.date);
    UNSIGNED1   day := STD.Date.day(basisds.date);
    UNSIGNED3 dayOfYear := STD.Date.DayOfYear(basisds.date);
    basisds.contractmonth;
    basisds.location_city;
    basisds.commodity;
    basisds.elevator_feed;
    Decimal averageBasisAdditive :=  AVE(GROUP, basisds.additiveBasis);
    Decimal averageBasisRelative :=  AVE(GROUP, basisds.relativeBasis);
END;

crossTabDs := TABLE(basisds, avgRec, STD.Date.day(date),STD.Date.Month(date),contractmonth);
OUTPUT(sort(crossTabDs,month,day),,fn2,thor,overwrite);

