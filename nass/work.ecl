import $,$.records;
rec:= RECORD
  string6 source_desc;
  string25 group_desc;
  string50 commodity_desc;
  string100 class_desc;
  string60 prodn_practice_desc;
  string30 util_practice_desc;
  string35 statisticcat_desc;
  string30 unit_desc;
  string short_desc;
  string50 domain_desc;
  string domaincat_desc;
  integer8 _unnamed_cnt_12;
 END;

ds := DATASET('~test::usda::what',rec,THOR  );
sort(ds(_unnamed_cnt_12>9999),-_unnamed_cnt_12)

// ds := DATASET('~test::usda::quick_stats_crops',$.records.QuickStatsRecord,THOR  );
// output(ds(short_desc = 'CORN, GRAIN - YIELD, MEASURED IN BU / ACRE'),
//     {short_desc, agg_level_desc,state_ansi,state_fips_code,state_alpha,state_name,asd_code,asd_desc,
//     county_ansi,county_code,county_name,region_desc,zip_5,watershed_code,watershed_desc,
//     congr_district_code,country_code,country_name,location_desc,year,freq_desc,begin_code,end_code,
//     reference_period_desc,week_ending,load_date,load_time,value,cv
//     },'~test::usda::hierarchy1::Corn_grain_yield_BU_acre',thor,named('rname'),overwrite);

// ds := DATASET('~test::usda::hierarchy1::Corn_grain_yield_BU_acre',RECORDOF('~test::usda::hierarchy1::Corn_grain_yield_BU_acre', lookup),flat);
// output(sort(ds(agg_level_desc='STATE'),state_alpha,year),
//             {state_ansi,state_alpha,location_desc,year,reference_period_desc,value},
//             '~test::usda::hierarchy1::Corn_grain_yield_BU_acre::state',thor,overwrite);


// ds := DATASET('~test::usda::hierarchy1::Corn_grain_yield_BU_acre',RECORDOF('~test::usda::hierarchy1::Corn_grain_yield_BU_acre', lookup),flat);
// output(sort(ds(agg_level_desc='COUNTY',state_alpha='AL'),county_name,year),
//             {county_ansi,county_name,location_desc,year,value},
//             '~test::usda::hierarchy1::Corn_grain_yield_BU_acre::Alabama',thor,overwrite);



