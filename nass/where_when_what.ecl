import $.records,std;


// ds := DATASET('~test::usda::quick_stats_crops',records.QuickStatsRecord,THOR  );

// output(ds(agg_level_desc='COUNTY'),
//     {state_alpha,source_desc,group_desc,commodity_desc,class_desc,prodn_practice_desc,util_practice_desc,
//     statisticcat_desc,unit_desc,short_desc,domain_desc,domaincat_desc,asd_code,asd_desc,county_code,
//     county_name,year,freq_desc,begin_code,end_code,reference_period_desc,value,cv}
//     ,'~test::usda::hierarchy6::county',thor,overwrite);

// ----------------------------------------------------------------------

// ds2 := DATASET('~test::usda::hierarchy6::county', 
//                 records.QuickStatsRecord,
//                 FLAT,lookup);

// output(ds2(freq_desc='ANNUAL'),//, reference_period_desc = 'YEAR'),
//     {state_alpha,source_desc,group_desc,commodity_desc,class_desc,prodn_practice_desc,util_practice_desc,
//     statisticcat_desc,unit_desc,short_desc,domain_desc,domaincat_desc,asd_code,asd_desc,county_code,
//     county_name,year,freq_desc,begin_code,end_code,reference_period_desc,value,cv}
//     ,'~test::usda::hierarchy6::county::annual',thor,overwrite);

// --------------------------------------------

// ds3 := DATASET('~test::usda::hierarchy6::county::annual', 
//                 records.QuickStatsRecord,
//                 FLAT,lookup);

// tmp := ds3(statisticcat_desc = 'AREA HARVESTED' or statisticcat_desc = 'YIELD' or statisticcat_desc = 'PRODUCTION');

// output(tmp(commodity_desc='CORN'
//             or commodity_desc ='BARLEY'
//             or commodity_desc = 'HAY'
//             or commodity_desc = 'WHEAT'
//             ),
//     {state_alpha,source_desc,commodity_desc,class_desc,prodn_practice_desc,util_practice_desc,
//     statisticcat_desc,unit_desc,short_desc,domain_desc,domaincat_desc,asd_code,asd_desc,county_code,
//     county_name,year,value,cv}
//     ,'~test::usda::hierarchy6::county::annual::corn_wheat_barley_hay',thor,overwrite);

// -----------------------------------------------------

ds4 := DATASET('~test::usda::exp', 
                records.QuickStatsRecord,
                FLAT,lookup);


groupds:= GROUP(SORT(ds4(prodn_practice_desc != 'ALL PRODUCTION PRACTICES'),//(statisticcat_desc = 'AREA HARVESTED' or statisticcat_desc = 'YIELD' or statisticcat_desc = 'PRODUCTION'), 
                    commodity_desc,class_desc,util_practice_desc,prodn_practice_desc,state_alpha,year),
                commodity_desc,class_desc,util_practice_desc,prodn_practice_desc,state_alpha,year);

tempDs := ROLLUP(groupds, GROUP,
            TRANSFORM(records.nested_record,
                self.sub_record := project(Rows(left),TRANSFORM(records.sub_record, SELF := LEFT));
                SELF := LEFT));
// tempDs; //W20200701-231042

records.combinedrec reshape(records.nested_record tempds) := 
    TRANSFORM
    // , SKIP(not (exists(tempds.sub_record(statisticcat_desc='AREA HARVESTED'))
    //             and exists(tempds.sub_record(statisticcat_desc='YIELD'))
    //             and exists(tempds.sub_record(statisticcat_desc='PRODUCTION'))))
        tmp:=tempds.sub_record(statisticcat_desc = 'AREA HARVESTED');
        SELF.AREA_HARVESTED := tmp[1].value;
        SELF.unit_AREA_HARVESTED := tmp[1].unit_desc;
        tmp1:=tempds.sub_record(statisticcat_desc = 'YIELD');// and not unit_desc='$');
        SELF.YIELD := tmp1[1].value;
        SELF.unit_YIELD := tmp1[1].unit_desc;
        tmp3:=tempds.sub_record(statisticcat_desc = 'PRODUCTION');
        SELF.PRODUCTION := tmp3[1].value;
        SELF.unit_PRODUCTION := tmp3[1].unit_desc;
        tmp4:=tempds.sub_record(statisticcat_desc = 'AREA PLANTED');
        SELF.AREA_PLANTED := tmp4[1].value;
        SELF.unit_AREA_PLANTED := tmp4[1].unit_desc;
        tmpCrop:= tempds.commodity_desc + '-' + tempds.class_desc + '-' + tempds.util_practice_desc;
        SELF.crop :=  STD.Str.CleanSpaces(tmpCrop);
        SELF := tempds;
END;
fds := PROJECT(tempDs, reshape(LEFT));

OUTPUT(fds,,'~test::usda::exp2',thor,overwrite);

// ---------------------------------------------

ds5 := DATASET('~test::usda::exp2', 
                records.combinedrec,
                FLAT,lookup);



crosstabDS := sort(Table(ds5, {state_alpha,crop,entries:= count(group)}, 
                            state_alpha,crop),-entries);

output(crosstabDS,, '~test::usda::exp2V',overwrite)
