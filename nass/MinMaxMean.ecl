import $.records,std;

// ds3 := DATASET('~test::usda::hierarchy6::county::annual::corn_wheat_soy_yield_NC2', 
//                 records.QuickStatsRecord,
//                 FLAT,lookup);

// corns := ds3(commodity_desc = 'CORN'and year>=2015);
// wheats := ds3(commodity_desc = 'WHEAT'and year>=2003);
// soys := ds3(commodity_desc = 'SOYBEANS'and year>=2015);

// crossTabLayout := RECORD
//                     String crop := ds3.commodity_desc;
//                     ds3.county_name;
//                     String statistic := 'Yield';
//                     low := Min(GROUP, ds3.value);
//                     mean := AVE(GROUP, ds3.value);
//                     high := max(GROUP, ds3.value);
// end;
// crn := TABLE(corns, crossTabLayout, commodity_desc,county_name);
// wht := TABLE(wheats,  crossTabLayout, commodity_desc,county_name);
// soy := TABLE(soys,  crossTabLayout, commodity_desc,county_name);

// output(crn+wht+soy,,'~test::usda::hierarchy6::county::annual::corn_wheat_soy_yield_NC5year',thor,overwrite);

rec := RECORD
	STD.Date.Date_t  date;
    STRING location_city;
    STRING field3;
    STRING commodity;
    STRING field5;
    Decimal price;
END;

ds4 := DATASET('~test::MARS::ra_gr110', 
                rec,
                FLAT,lookup);

ds5 := PROJECT(ds4, TRANSFORM(rec, 
                                Self.location_city := IF(left.location_city=']Bladenboro', 'Bladenboro', left.location_city);
                                SELF := LEFT));

output(ds5,,'~test::MARS::ra_gr110_fixed',thor,overwrite);

corns := ds5(commodity = 'corn'and STD.Date.Year(date) >=2015 and field3 = 'elevator' and field5='cash');
wheats := ds5(commodity = 'wheat'and STD.Date.Year(date) >=2015 and field3 = 'elevator' and field5='cash');
soys := ds5(commodity = 'soy'and STD.Date.Year(date) >=2015 and field3 = 'elevator' and field5='cash');

crossTabLayout := RECORD
                    String crop := ds5.commodity;
                    ds5.location_city;
                    String statistic := 'Price';
                    low := Min(GROUP, ds5.price);
                    mean := AVE(GROUP, ds5.price);
                    high := max(GROUP, ds5.price);
end;
crn := TABLE(corns, crossTabLayout, commodity,location_city);
wht := TABLE(wheats,  crossTabLayout, commodity,location_city);
soy := TABLE(soys,  crossTabLayout, commodity,location_city);
output(count(crn));
output(count(wht));
output(count(soy));
output(crn+wht+soy,,'~test::usda::hierarchy6::county::annual::corn_wheat_soy_price_NC5year',thor,overwrite);

