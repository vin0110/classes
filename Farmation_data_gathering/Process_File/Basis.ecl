import std,$.Records,$.Dictionaries;

#DECLARE (SetString)
#DECLARE (day)
#DECLARE (year)
#SET (SetString, '['); //initialize SetString to [
#SET (year, 2013); //initialize day to 1
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

oldDate:= STD.Date.FromStringToDate('2013', '%Y');

rec := RECORD
	STD.Date.Date_t  date;
    STRING city;
    STRING what;
    STRING crop;
    STRING value_type;
    Decimal value;
    STRING loc;
END;

fn := '~test::mars::ra_gr110';
ds := Dataset(fn,rec,flat);

// ds1:=ds((field5='new'and (crop='corn' or crop='soy'))or(field5='cash'and crop='wheat'));
marsds:= ds;//-ds1;
cityList := sort(TABLE(marsds(date>=20140101),{ city,what,crop,loc, cnt:=count(group)}, city,what,crop),-cnt);

templateRec := RECORD
	STD.Date.Date_t  date;
    STRING20 city;
    STRING10 crop;
    STRING10 what;
    STRING loc;
END;
marsTemplate := JOIN(daysOfYears,cityList(cnt>1100), 
 True
 ,transform(templateRec, 
            self.date := STD.Date.DateFromParts(left.year,left.month,left.dom);
            SELF.what:=right.what;
            SELF := right;
),LEFT OUTER,ALL);

marsFinalRec:=Record(templateRec)
    Decimal mars;
end;

marsjoinedds := JOIN(marsTemplate,marsds, 
 left.date=RIGHT.date and left.city=right.city and left.what=right.what and left.crop=right.crop
 ,transform(marsFinalRec, 
            Self.mars:=right.value;
            SELF := LEFT;
),LEFT OUTER);
marsFinalRec marsfiller(marsFinalRec prev, marsFinalRec curr):= TRANSFORM
    SELF.date:=curr.date;
    SELF.city:=curr.city;
    SELF.crop:=curr.crop;
    SELF.what:=curr.what;
    SELF.loc:=curr.loc;
    SELF.mars := IF(curr.mars=0, prev.mars, curr.mars);
END;

groupedMars:=GROUP(sort(marsjoinedds,city,crop,what,date),city,crop,what);
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
    STRING20 city;
    STRING10 crop;
    STRING10 what;
    Integer2 contractmonth;
    // Decimal relativeBasis;
    // Decimal netBasis;
    String30 loc;
    Decimal mars;
    Decimal cme;
    Integer1 upcomingContract;
END;
// basisrolluprec := RECORD
// 	STD.Date.Date_t  date;
//     STRING20 city;
//     STRING10 crop;
//     STRING10 what;
//     Decimal10_8 contract1Basis;
//     Decimal10_8 contract2Basis;
//     Decimal10_8 contract3Basis;
//     Decimal10_8 contract4Basis;
//     Decimal10_8 contract5Basis;
//     Decimal10_8 mars;
//     Integer1 upcomingContract;
// END;

// crn := [3,5,7,9,12];

crnwt := sort(DATASET([3,5,7,9,12], {Integer2 mnth}),mnth);
sy := sort(DATASET([3,5,7,9,11], {Integer2 mnth}),mnth);

basisds := JOIN(marsfullds(date>=20140101,date<=20190313),cmefullds(date>=20140101,date<=20190313), 
 LEFT.date=RIGHT.date and LEFT.crop=Dictionaries.Crop_code_DCT(RIGHT.crop)
 ,transform(basisrec, 
            // self.relativeBasis := LEFT.mars/(Right.close/100);
            // self.netBasis := LEFT.mars-(Right.close/100);
            self.mars:=left.mars;
            self.cme:=right.close/100;
            self.contractmonth := right.contractmonth;
            self.what := LEFT.what;
            self.upcomingContract:= IF(LEFT.crop='soybeans', 
            IF(STD.Date.Month(left.date)>=11, sy[1].mnth, sy(mnth>STD.Date.Month(left.date))[1].mnth), 
            IF(STD.Date.Month(left.date)=12, crnwt[1].mnth, crnwt(mnth>STD.Date.Month(left.date))[1].mnth));
            
            SELF := LEFT;
),INNER);

// basisNewRec := RECORD
// 	STD.Date.Date_t  date;
//     STRING20 city;
//     STRING10 crop;
//     STRING10 what;
//     Integer2 contractmonth;
//     String10 basisType;
//     Decimal basis;
//     Integer1 upcomingContract;
//     // Decimal netBasis;
// END;

// basisNormed:=Normalize(basisds,2,
//                             TRANSFORM(basisNewRec, 
//                                         self.basisType:=IF(COUNTER=1, 'net', 'relative');
//                                         self.basis:=IF(counter=1, left.netBasis, left.relativeBasis);
//                                         SELF := LEFT)
// );
OUTPUT(sort(basisds,crop,city,what,date),,'~test::basistmp::basis',thor,overwrite);

// basisgroup:=GROUP(sort(basisds,date,crop,city,what),date,crop,city,what);
// basisRollup:=ROLLUP(basisgroup,GROUP,
//     TRANSFORM(basisrolluprec,
//         subdata := sort(Rows(LEFT),contractmonth);
//         self.contract1Basis:= subdata[1].netBasis;
//         self.contract2Basis:= subdata[2].netBasis;
//         self.contract3Basis:= subdata[3].netBasis;
//         self.contract4Basis:= subdata[4].netBasis;
//         self.contract5Basis:= subdata[5].netBasis;
//         self.upcomingContract:= IF(STD.Date.Month(subdata[1].date)=12, subdata[1].contractmonth, subdata(contractmonth>STD.Date.Month(subdata[1].date))[1].contractmonth);
//         SELF := subdata[1])
// );

// OUTPUT(sort(basisRollup,crop,city,what,date),,'~test::basistmp::additivebasis',thor,overwrite);

// relBasisRollup:=ROLLUP(basisgroup,GROUP,
//     TRANSFORM(basisrolluprec,
//         subdata := sort(Rows(LEFT),contractmonth);
//         self.contract1Basis:= subdata[1].relativeBasis;
//         self.contract2Basis:= subdata[2].relativeBasis;
//         self.contract3Basis:= subdata[3].relativeBasis;
//         self.contract4Basis:= subdata[4].relativeBasis;
//         self.contract5Basis:= subdata[5].relativeBasis;
//         self.upcomingContract:= IF(STD.Date.Month(subdata[1].date)=12, subdata[1].contractmonth, subdata(contractmonth>STD.Date.Month(subdata[1].date))[1].contractmonth);
//         SELF := subdata[1])
// );

// OUTPUT(sort(relBasisRollup,crop,city,what,date),,'~test::basistmp::relativebasis',thor,overwrite);

avgRec := RECORD
    UNSIGNED1   month:=STD.Date.Month(basisds.date);
    UNSIGNED1   day := STD.Date.day(basisds.date);
    UNSIGNED3 dayOfYear := STD.Date.DayOfYear(basisds.date);
    basisds.city;
    basisds.crop;
    basisds.contractmonth;
    basisds.what;
    basisds.loc;
    // basisds.basisType;
    Decimal averageCme :=  AVE(GROUP, basisds.cme);
    Decimal averageMars :=  AVE(GROUP, basisds.mars);
    // Decimal10_8 min:=MIN(GROUP, basisds.basis);
    // Decimal10_8 max:=MAX(GROUP, basisds.basis);
    // UNSIGNED1   month:=STD.Date.Month(basisRollup.date);
    // UNSIGNED1   day := STD.Date.day(basisRollup.date);
    // UNSIGNED3 dayOfYear := STD.Date.DayOfYear(basisRollup.date);
    // basisRollup.city;
    // basisRollup.crop;
    // basisRollup.what;
    // Decimal10_8 aveContract1Basis:=AVE(GROUP, basisRollup.contract1Basis);
    // Decimal10_8 minContract1Basis:=MIN(GROUP, basisRollup.contract1Basis);
    // Decimal10_8 maxContract1Basis:=MAX(GROUP, basisRollup.contract1Basis);
    // Decimal10_8 aveContract2Basis:=AVE(GROUP, basisRollup.contract2Basis);
    // Decimal10_8 minContract2Basis:=MIN(GROUP, basisRollup.contract2Basis);
    // Decimal10_8 maxContract2Basis:=MAX(GROUP, basisRollup.contract2Basis);
    // Decimal10_8 aveContract3Basis:=AVE(GROUP, basisRollup.contract3Basis);
    // Decimal10_8 minContract3Basis:=MIN(GROUP, basisRollup.contract3Basis);
    // Decimal10_8 maxContract3Basis:=MAX(GROUP, basisRollup.contract3Basis);
    // Decimal10_8 aveContract4Basis:=AVE(GROUP, basisRollup.contract4Basis);
    // Decimal10_8 minContract4Basis:=MIN(GROUP, basisRollup.contract4Basis);
    // Decimal10_8 maxContract4Basis:=MAX(GROUP, basisRollup.contract4Basis);
    // Decimal10_8 aveContract5Basis:=AVE(GROUP, basisRollup.contract5Basis);
    // Decimal10_8 minContract5Basis:=MIN(GROUP, basisRollup.contract5Basis);
    // Decimal10_8 maxContract5Basis:=MAX(GROUP, basisRollup.contract5Basis);
END;

// crossTabDs := TABLE(basisRollup, avgRec, STD.Date.day(date),STD.Date.Month(date),city,crop,what);
// OUTPUT(sort(crossTabDs,month,day),,'~test::basisavtmp::Avg_basis_Additive',thor,overwrite);
crossTabDs := TABLE(basisds, avgRec, STD.Date.day(date),STD.Date.Month(date),city,crop,contractmonth,what);//,basistype);
OUTPUT(sort(crossTabDs,month,day),,'~test::basisavtmp::Avg_basis',thor,overwrite);

// avgRecRel := RECORD
//     UNSIGNED1   month:=STD.Date.Month(basisds.date);
//     UNSIGNED1   day := STD.Date.day(basisds.date);
//     UNSIGNED3 dayOfYear := STD.Date.DayOfYear(basisds.date);
//     basisds.city;
//     basisds.crop;
//     basisds.contractmonth;
//     basisds.what;
//     Decimal averageBasis :=  AVE(GROUP, basisds.relativeBasis);
//     Decimal10_8 min:=MIN(GROUP, basisds.relativeBasis);
//     Decimal10_8 max:=MAX(GROUP, basisds.relativeBasis);
// //     UNSIGNED1   month:=STD.Date.Month(relBasisRollup.date);
// //     UNSIGNED1   day := STD.Date.day(relBasisRollup.date);
// //     UNSIGNED3 dayOfYear := STD.Date.DayOfYear(relBasisRollup.date);
// //     relBasisRollup.city;
// //     relBasisRollup.crop;
// //     relBasisRollup.what;
// //     Decimal10_8 aveContract1Basis:=AVE(GROUP, relBasisRollup.contract1Basis);
// //     Decimal10_8 minContract1Basis:=MIN(GROUP, relBasisRollup.contract1Basis);
// //     Decimal10_8 maxContract1Basis:=MAX(GROUP, relBasisRollup.contract1Basis);
// //     Decimal10_8 aveContract2Basis:=AVE(GROUP, relBasisRollup.contract2Basis);
// //     Decimal10_8 minContract2Basis:=MIN(GROUP, relBasisRollup.contract2Basis);
// //     Decimal10_8 maxContract2Basis:=MAX(GROUP, relBasisRollup.contract2Basis);
// //     Decimal10_8 aveContract3Basis:=AVE(GROUP, relBasisRollup.contract3Basis);
// //     Decimal10_8 minContract3Basis:=MIN(GROUP, relBasisRollup.contract3Basis);
// //     Decimal10_8 maxContract3Basis:=MAX(GROUP, relBasisRollup.contract3Basis);
// //     Decimal10_8 aveContract4Basis:=AVE(GROUP, relBasisRollup.contract4Basis);
// //     Decimal10_8 minContract4Basis:=MIN(GROUP, relBasisRollup.contract4Basis);
// //     Decimal10_8 maxContract4Basis:=MAX(GROUP, relBasisRollup.contract4Basis);
// //     Decimal10_8 aveContract5Basis:=AVE(GROUP, relBasisRollup.contract5Basis);
// //     Decimal10_8 minContract5Basis:=MIN(GROUP, relBasisRollup.contract5Basis);
// //     Decimal10_8 maxContract5Basis:=MAX(GROUP, relBasisRollup.contract5Basis);
// END;
// // crossTabDs2 := TABLE(relBasisRollup, avgRecRel, STD.Date.day(date),STD.Date.Month(date),city,crop,what);
// // OUTPUT(sort(crossTabDs2,month,day),,'~test::basisavtmp::Avg_basis_Relative',thor,overwrite);
// crossTabDs2 := TABLE(basisds, avgRecRel, STD.Date.day(date),STD.Date.Month(date),city,crop,contractmonth,what);
// OUTPUT(sort(crossTabDs2,month,day),,'~test::basisavtmp::Avg_basis_relative',thor,overwrite);
