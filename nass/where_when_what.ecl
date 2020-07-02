import $.records,std;


// ds := DATASET('~test::usda::quick_stats_crops',records.QuickStatsRecord,THOR  );

// output(ds(agg_level_desc='STATE',state_alpha='NC'),
//     {source_desc,group_desc,commodity_desc,class_desc,prodn_practice_desc,util_practice_desc,
//     statisticcat_desc,unit_desc,short_desc,domain_desc,domaincat_desc,year,freq_desc,
//     begin_code,end_code,reference_period_desc,week_ending,value}
//     ,'~test::usda::hierarchy6::state_nc',thor,overwrite);

// ds2 := DATASET('~test::usda::hierarchy6::state_nc', 
//                 records.QuickStatsRecord,
//                 FLAT,lookup);

// output(ds2(year=2009, freq_desc='ANNUAL', reference_period_desc = 'YEAR'),
//     {source_desc,group_desc,commodity_desc,class_desc,prodn_practice_desc,util_practice_desc,
//     statisticcat_desc,unit_desc,short_desc,domain_desc,domaincat_desc, value}
//     ,'~test::usda::hierarchy6::state_nc::2009_annual',thor,overwrite);

ds3 := DATASET('~test::usda::hierarchy6::state_nc::2009_annual', 
                records.QuickStatsRecord,
                FLAT,lookup);

output(ds3(commodity_desc='CORN' 
            or commodity_desc='WHEAT'
            or commodity_desc='HAY'
            or commodity_desc='BARLEY'
            ),
    {commodity_desc,class_desc,util_practice_desc,
    statisticcat_desc,unit_desc,short_desc,value}
    ,'~test::usda::hierarchy6::state_nc::2009_annual::corn_wheat_barley_hay',thor,overwrite);


ds4 := DATASET('~test::usda::hierarchy6::state_nc::2009_annual::corn_wheat_barley_hay', 
                records.QuickStatsRecord,
                FLAT,lookup);


rolluprec := RECORD
	string50 commodity_desc;
	string100 class_desc;
	string30 util_practice_desc;
	decimal17 Area_harvested;
    string30 unit_Area_harvested;
	decimal17 production;
    string30 unit_production;
	decimal17 yield;
    string30 unit_yield;
END;

groupds:= GROUP(SORT(ds4(statisticcat_desc = 'AREA HARVESTED' or statisticcat_desc = 'YIELD' or statisticcat_desc = 'PRODUCTION'), 
                    commodity_desc,class_desc,util_practice_desc),
                commodity_desc,class_desc,util_practice_desc);

tempDs := ROLLUP(groupds, GROUP,
            TRANSFORM(records.nested_record,
                self.sub_record := project(Rows(left),TRANSFORM(records.sub_record, SELF := LEFT));
                SELF := LEFT));
// tempDs; //W20200701-231042

rolluprec reshape(records.nested_record tempds) := 
    TRANSFORM
    , SKIP(not (exists(tempds.sub_record(statisticcat_desc='AREA HARVESTED'))
                        and exists(tempds.sub_record(statisticcat_desc='YIELD'))
                        and exists(tempds.sub_record(statisticcat_desc='PRODUCTION'))))
        tmp:=tempds.sub_record(statisticcat_desc = 'AREA HARVESTED');
        SELF.Area_harvested := tmp[1].value;
        SELF.unit_Area_harvested := tmp[1].unit_desc;
        tmp1:=tempds.sub_record(statisticcat_desc = 'PRODUCTION' and not unit_desc='$');
        SELF.production := tmp1[1].value;
        SELF.unit_production := tmp1[1].unit_desc;
        tmp3:=tempds.sub_record(statisticcat_desc = 'YIELD');
        SELF.yield := tmp3[1].value;
        SELF.unit_yield := tmp3[1].unit_desc;
        SELF := tempds;
END;
fds := PROJECT(tempDs, reshape(LEFT));

OUTPUT(fds,,'~test::usda::hierarchy6::state_nc::2009_annual::corn_wheat_barley_hay_Formatted',thor,overwrite); 