import $.records,std;


// ds := DATASET('~test::usda::quick_stats_economics',records.QuickStatsRecord,THOR  );

// output(ds(agg_level_desc='STATE'),
//     {state_alpha,source_desc,group_desc,commodity_desc,class_desc,prodn_practice_desc,util_practice_desc,
//     statisticcat_desc,unit_desc,short_desc,domain_desc,domaincat_desc,year,freq_desc,
//     begin_code,end_code,reference_period_desc,value,cv}
//     ,'~test::usda::economics::hierarchy6::state',thor,overwrite);

// ----------------------------------------------------------------------

// ds2 := DATASET('~test::usda::economics::hierarchy6::state', 
//                 records.QuickStatsRecord,
//                 FLAT,lookup);

// output(ds2(freq_desc='ANNUAL'),//, reference_period_desc = 'YEAR'),
//     {state_alpha,source_desc,group_desc,commodity_desc,class_desc,prodn_practice_desc,util_practice_desc,
//     statisticcat_desc,unit_desc,short_desc,domain_desc,domaincat_desc,year,
//     value,cv}
//     ,'~test::usda::economics::hierarchy6::state::annual',thor,overwrite);

// --------------------------------------------

// ds3 := DATASET('~test::usda::economics::hierarchy6::state::annual', 
//                 records.QuickStatsRecord,
//                 FLAT,lookup);

// // output(ds3(commodity_desc='FARM OPERATIONS' 
// //             or (commodity_desc='INCOME, NET CASH FARM' and (class_desc = 'OF OPERATIONS' or class_desc = 'OF OPERATORS' ))
// //             or (commodity_desc='COMMODITY TOTALS' and class_desc='INCL GOVT PROGRAMS')
// //             or (commodity_desc='LABOR' and class_desc='HIRED')
// //             ),
// output(ds3(commodity_desc='INCOME, NET CASH FARM' 
//         and (class_desc = 'OF OPERATIONS' or class_desc = 'OF OPERATORS')
//         and statisticcat_desc = 'GAIN'
//             ),
//     {state_alpha,class_desc,commodity_desc,
//     statisticcat_desc,unit_desc,short_desc,domain_desc,domaincat_desc,year,
//     value,cv}
//     ,'~test::usda::economics::hierarchy6::state::annual::income',thor,overwrite);


// -----------------------------------------------------

// ds4 := DATASET('~test::usda::economics::hierarchy6::state::annual::income', 
//                 records.QuickStatsRecord,
//                 FLAT,lookup);


// groupds:= GROUP(SORT(ds4,//(statisticcat_desc = 'LOSS' or statisticcat_desc = 'GAIN' or statisticcat_desc = 'EXPENSE' or statisticcat_desc = 'NET INCOME'), 
//                     commodity_desc,class_desc,util_practice_desc,state_alpha,year),
//                 commodity_desc,class_desc,util_practice_desc,state_alpha,year);

// tempDs := ROLLUP(groupds, GROUP,
//             TRANSFORM(records.nested_record,
//                 self.sub_record := project(Rows(left),TRANSFORM(records.sub_record, SELF := LEFT));
//                 SELF := LEFT));
// // tempDs; //W20200701-231042

// records.combinedrec reshape(records.nested_record tempds) := 
//     TRANSFORM
//     // , SKIP(not (exists(tempds.sub_record(statisticcat_desc='PRICE RECEIVED'))
//     //             and exists(tempds.sub_record(statisticcat_desc='SALES'))
//     //             and exists(tempds.sub_record(statisticcat_desc='DISAPPEARANCE'))))
//         // tmp:=tempds.sub_record(statisticcat_desc = 'LOSS');
//         // SELF.LOSS := tmp[1].value;
//         // SELF.unit_LOSS := tmp[1].unit_desc;
//         tmp1:=tempds.sub_record(statisticcat_desc = 'GAIN' and not unit_desc='OPERATIONS');
//         SELF.GAIN := tmp1[1].value;
//         SELF.unit_GAIN := tmp1[1].unit_desc;
//         // tmp3:=tempds.sub_record(statisticcat_desc = 'EXPENSE');
//         // SELF.EXPENSE := tmp3[1].value;
//         // SELF.unit_EXPENSE := tmp3[1].unit_desc;
//         // tmp4:=tempds.sub_record(statisticcat_desc = 'NET INCOME');
//         // SELF.NET_INCOME := tmp4[1].value;
//         // SELF.unit_NET_INCOME := tmp4[1].unit_desc;
//         tmpCrop:= 'INCOME, NET CASH FARM' + '-' + tempds.class_desc;// + '-' + tempds.util_practice_desc;
//         SELF.crop :=  STD.Str.CleanSpaces(tmpCrop); //not helpful
//         SELF := tempds;
// END;
// fds := PROJECT(tempDs, reshape(LEFT));

// OUTPUT(fds,,'~test::usda::economics::hierarchy6::state::annual::income_Formatted',thor,overwrite);

// ---------------------------------------------

ds5 := DATASET('~test::usda::economics::hierarchy6::state::annual::income_Formatted', 
                records.combinedrec,
                FLAT,lookup);

// combinedDs := PROJECT(ds5, TRANSFORM(records.combinedrec, 
//                                     tmp:= LEFT.commodity_desc + '-' + LEFT.class_desc + '-' + LEFT.util_practice_desc;
//                                     SELF.crop :=  STD.Str.CleanSpaces(tmp); //not helpful
//                                     SELF := LEFT));

// OUTPUT(combinedDs,,'~test::usda::hierarchy6::state::annual::corn_wheat_barley_hay_combined',thor,overwrite);


crosstabDS := sort(Table(ds5, {state_alpha,crop,entries:= count(group)}, 
                            state_alpha,crop),-entries);

output(crosstabDS,, '~test::usda::economics::hierarchy6::state::annual::income_variants_by_state',overwrite)