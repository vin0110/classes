import std,$.Records,$.Dictionaries;

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

fn := '~test::mars::ra_gr110_fixed';
ds := Dataset(fn,rec,flat);

ds1:=ds((field5='new'and (commodity='corn' or commodity='soy'))or(field5='cash'and commodity='wheat'));
marsds:= ds-ds1;
cityList := sort(TABLE(marsds(date>=20150101),{ location_city,field3,commodity, cnt:=count(group)}, location_city,field3,commodity),-cnt);

templateRec := RECORD
	STD.Date.Date_t  date;
    STRING20 location_city;
    STRING10 commodity;
    STRING10 elevator_feed;
END;
marsTemplate := JOIN(daysOfYears,cityList(cnt>1000), 
 True
 ,transform(templateRec, 
            self.date := STD.Date.DateFromParts(left.year,left.month,left.dom);
            SELF.elevator_feed:=right.field3;
            SELF := right;
),LEFT OUTER,ALL);

marsFinalRec:=Record(templateRec)
    Decimal mars;
end;

marsjoinedds := JOIN(marsTemplate,marsds, 
 left.date=RIGHT.date and left.location_city=right.location_city and left.elevator_feed=right.field3 and left.commodity=right.commodity
 ,transform(marsFinalRec, 
            Self.mars:=right.price;
            SELF := LEFT;
),LEFT OUTER);
marsFinalRec marsfiller(marsFinalRec prev, marsFinalRec curr):= TRANSFORM
    SELF.date:=curr.date;
    SELF.location_city:=curr.location_city;
    SELF.commodity:=curr.commodity;
    SELF.elevator_feed:=curr.elevator_feed;
    SELF.mars := IF(curr.mars=0, prev.mars, curr.mars);
END;

groupedMars:=GROUP(sort(marsjoinedds,location_city,commodity,elevator_feed,date),location_city,commodity,elevator_feed);
marsfullds := ITERATE(sort(groupedMars,date), marsfiller(LEFT,right));

output(sort(marsfullds,date),,'~test::basis::marsPrices',thor,overwrite);

fn3w := '~test::tbd::cme::cumulative::wheat';
ds2w:=Dataset(fn3w,records.ContractLayout,flat);
fn3c := '~test::tbd::cme::cumulative::corn';
ds2c:=Dataset(fn3c,records.ContractLayout,flat);
fn3s := '~test::tbd::cme::cumulative::soy';
ds2s:=Dataset(fn3s,records.ContractLayout,flat);
subds := ds2w(date>oldDate)+ds2s(date>oldDate)+ds2c(date>oldDate);

cmegroup:=GROUP(sort(subds,date,contractmonth,crop),date,contractmonth,crop);
cmeDS:=ROLLUP(cmegroup,GROUP,
    TRANSFORM(Records.ContractLayout,
        subdata := Rows(LEFT);
        entry := sort(subdata,daystoexpire)[1];
        SELF := entry)
);


cmeUniques:=TABLE(cmeds,{crop,contractmonth},crop,contractmonth);
templateRecCme := RECORD
	Records.ContractLayout.crop;
    Records.ContractLayout.contractmonth;
    STD.Date.Date_t  date
END;

cmeJoinLeft := JOIN(daysOfYears,cmeUniques, 
 True
 ,transform(templateRecCme, 
            self.date := STD.Date.DateFromParts(left.year,left.month,left.dom);
            SELF := right;
),LEFT OUTER,ALL);


Records.ContractLayout cmejointransform(templateRecCme lefta,Records.ContractLayout righta):= transform 
            self.date := lefta.date;
            SELF.crop:=lefta.crop;
            SELF.contractmonth:=lefta.contractmonth;
            SELF := righta;
            Self:=[];
end;

cmejoinedds := JOIN(cmeJoinLeft,cmeds, 
 left.date=RIGHT.date and LEFT.crop=RIGHT.crop and LEFT.contractmonth=RIGHT.contractmonth
 ,cmejointransform(left,right),LEFT OUTER);


Records.ContractLayout cmefiller(Records.ContractLayout prev, Records.ContractLayout curr):= TRANSFORM
    SELF.date:=curr.date;
    self.contractmonth:=curr.contractmonth;
    self.crop:=curr.crop;
    SELF := IF(curr.high=0, prev, curr);
END;
groupedCME:=GROUP(sort(cmejoinedds,crop,contractmonth,date),crop,contractmonth);
cmefullds := ITERATE(sort(groupedCME,date), cmefiller(LEFT,right));

OUTPUT(sort(cmefullds,date,contractmonth),,'~test::basis::cmePrices',thor,overwrite);

basisrec := RECORD
	STD.Date.Date_t  date;
    STRING20 location_city;
    STRING10 commodity;
    STRING10 elevator_feed;
    Integer2 contractmonth;
    Decimal relativeBasis;
    Decimal additiveBasis;
    Decimal mars;
    Decimal cme;
END;
basisrolluprec := RECORD
	STD.Date.Date_t  date;
    STRING20 location_city;
    STRING10 commodity;
    STRING10 elevator_feed;
    Decimal10_8 contract1Basis;
    Decimal10_8 contract2Basis;
    Decimal10_8 contract3Basis;
    Decimal10_8 contract4Basis;
    Decimal10_8 contract5Basis;
    Decimal10_8 mars;
    Integer1 upcomingContract;
END;


basisds := JOIN(marsfullds(date>=20150101,date<=20191213),cmefullds(date>=20150101,date<=20191213), 
 LEFT.date=RIGHT.date and LEFT.commodity=Dictionaries.Crop_code_DCT(RIGHT.crop)
 ,transform(basisrec, 
            self.relativeBasis := LEFT.mars/(Right.close/100);
            self.additiveBasis := LEFT.mars-(Right.close/100);
            self.mars:=left.mars;
            self.cme:=right.close/100;
            self.contractmonth := right.contractmonth;
            self.elevator_feed := LEFT.elevator_feed;
            SELF := LEFT;
),INNER);

basisgroup:=GROUP(sort(basisds,date,commodity,location_city,elevator_feed),date,commodity,location_city,elevator_feed);
basisRollup:=ROLLUP(basisgroup,GROUP,
    TRANSFORM(basisrolluprec,
        subdata := sort(Rows(LEFT),contractmonth);
        self.contract1Basis:= subdata[1].additiveBasis;
        self.contract2Basis:= subdata[2].additiveBasis;
        self.contract3Basis:= subdata[3].additiveBasis;
        self.contract4Basis:= subdata[4].additiveBasis;
        self.contract5Basis:= subdata[5].additiveBasis;
        self.upcomingContract:= IF(STD.Date.Month(subdata[1].date)=12, subdata[1].contractmonth, subdata(contractmonth>STD.Date.Month(subdata[1].date))[1].contractmonth);
        SELF := subdata[1])
);

OUTPUT(sort(basisRollup,commodity,location_city,elevator_feed,date),,'~test::basistmp::additivebasis',thor,overwrite);

relBasisRollup:=ROLLUP(basisgroup,GROUP,
    TRANSFORM(basisrolluprec,
        subdata := sort(Rows(LEFT),contractmonth);
        self.contract1Basis:= subdata[1].relativeBasis;
        self.contract2Basis:= subdata[2].relativeBasis;
        self.contract3Basis:= subdata[3].relativeBasis;
        self.contract4Basis:= subdata[4].relativeBasis;
        self.contract5Basis:= subdata[5].relativeBasis;
        self.upcomingContract:= IF(STD.Date.Month(subdata[1].date)=12, subdata[1].contractmonth, subdata(contractmonth>STD.Date.Month(subdata[1].date))[1].contractmonth);
        SELF := subdata[1])
);

OUTPUT(sort(relBasisRollup,commodity,location_city,elevator_feed,date),,'~test::basistmp::relativebasis',thor,overwrite);
avgRec := RECORD
    UNSIGNED1   month:=STD.Date.Month(basisRollup.date);
    UNSIGNED1   day := STD.Date.day(basisRollup.date);
    UNSIGNED3 dayOfYear := STD.Date.DayOfYear(basisRollup.date);
    basisRollup.location_city;
    basisRollup.commodity;
    basisRollup.elevator_feed;
    Decimal10_8 aveContract1Basis:=AVE(GROUP, basisRollup.contract1Basis);
    Decimal10_8 minContract1Basis:=MIN(GROUP, basisRollup.contract1Basis);
    Decimal10_8 maxContract1Basis:=MAX(GROUP, basisRollup.contract1Basis);
    Decimal10_8 aveContract2Basis:=AVE(GROUP, basisRollup.contract2Basis);
    Decimal10_8 minContract2Basis:=MIN(GROUP, basisRollup.contract2Basis);
    Decimal10_8 maxContract2Basis:=MAX(GROUP, basisRollup.contract2Basis);
    Decimal10_8 aveContract3Basis:=AVE(GROUP, basisRollup.contract3Basis);
    Decimal10_8 minContract3Basis:=MIN(GROUP, basisRollup.contract3Basis);
    Decimal10_8 maxContract3Basis:=MAX(GROUP, basisRollup.contract3Basis);
    Decimal10_8 aveContract4Basis:=AVE(GROUP, basisRollup.contract4Basis);
    Decimal10_8 minContract4Basis:=MIN(GROUP, basisRollup.contract4Basis);
    Decimal10_8 maxContract4Basis:=MAX(GROUP, basisRollup.contract4Basis);
    Decimal10_8 aveContract5Basis:=AVE(GROUP, basisRollup.contract5Basis);
    Decimal10_8 minContract5Basis:=MIN(GROUP, basisRollup.contract5Basis);
    Decimal10_8 maxContract5Basis:=MAX(GROUP, basisRollup.contract5Basis);
END;

crossTabDs := TABLE(basisRollup, avgRec, STD.Date.day(date),STD.Date.Month(date),location_city,commodity,elevator_feed);
OUTPUT(sort(crossTabDs,month,day),,'~test::basisavtmp::Avg_basis_Additive',thor,overwrite);

avgRecRel := RECORD
    UNSIGNED1   month:=STD.Date.Month(relBasisRollup.date);
    UNSIGNED1   day := STD.Date.day(relBasisRollup.date);
    UNSIGNED3 dayOfYear := STD.Date.DayOfYear(relBasisRollup.date);
    relBasisRollup.location_city;
    relBasisRollup.commodity;
    relBasisRollup.elevator_feed;
    Decimal10_8 aveContract1Basis:=AVE(GROUP, relBasisRollup.contract1Basis);
    Decimal10_8 minContract1Basis:=MIN(GROUP, relBasisRollup.contract1Basis);
    Decimal10_8 maxContract1Basis:=MAX(GROUP, relBasisRollup.contract1Basis);
    Decimal10_8 aveContract2Basis:=AVE(GROUP, relBasisRollup.contract2Basis);
    Decimal10_8 minContract2Basis:=MIN(GROUP, relBasisRollup.contract2Basis);
    Decimal10_8 maxContract2Basis:=MAX(GROUP, relBasisRollup.contract2Basis);
    Decimal10_8 aveContract3Basis:=AVE(GROUP, relBasisRollup.contract3Basis);
    Decimal10_8 minContract3Basis:=MIN(GROUP, relBasisRollup.contract3Basis);
    Decimal10_8 maxContract3Basis:=MAX(GROUP, relBasisRollup.contract3Basis);
    Decimal10_8 aveContract4Basis:=AVE(GROUP, relBasisRollup.contract4Basis);
    Decimal10_8 minContract4Basis:=MIN(GROUP, relBasisRollup.contract4Basis);
    Decimal10_8 maxContract4Basis:=MAX(GROUP, relBasisRollup.contract4Basis);
    Decimal10_8 aveContract5Basis:=AVE(GROUP, relBasisRollup.contract5Basis);
    Decimal10_8 minContract5Basis:=MIN(GROUP, relBasisRollup.contract5Basis);
    Decimal10_8 maxContract5Basis:=MAX(GROUP, relBasisRollup.contract5Basis);
END;
crossTabDs2 := TABLE(relBasisRollup, avgRecRel, STD.Date.day(date),STD.Date.Month(date),location_city,commodity,elevator_feed);
OUTPUT(sort(crossTabDs2,month,day),,'~test::basisavtmp::Avg_basis_Relative',thor,overwrite);
