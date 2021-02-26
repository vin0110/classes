import $.records,std;
statsRecE := RECORD(records.combinedrec1)
    SET OF DECIMAL irr_history := [];
    SET OF DECIMAL nirr_history := [];
    SET OF DECIMAL all_history := [];

END;

array_rec := RECORD
    DECIMAL num;
END;

statsRecE computeRollingAve(statsRecE prev, statsRecE curr) := TRANSFORM
    // newCases := IF(le.location = ri.location, ri.cumCases - le.cumCases, ri.cumCases);
    irr_history := IF(prev.state_alpha = curr.state_alpha 
                        and prev.county_name = curr.county_name
                        and prev.statisticcat_desc = curr.statisticcat_desc
                        and prev.crop = curr.crop,
                            ([curr.IRRIGATED]+prev.irr_history)[..10],
                            [curr.IRRIGATED]);
    SELF.irr_history := irr_history;
    SELF.irrigated_roll_ave := AVE(irr_history);
    SELF.irrigated_roll_std := SQRT(VARIANCE(DATASET(irr_history,array_rec),num));

    nirr_history := IF(prev.state_alpha = curr.state_alpha 
                        and prev.county_name = curr.county_name
                        and prev.statisticcat_desc = curr.statisticcat_desc
                        and prev.crop = curr.crop,
                            ([curr.NON_IRRIGATED]+prev.nirr_history)[..10],
                            [curr.NON_IRRIGATED]);
    SELF.nirr_history := nirr_history;
    SELF.non_irrigated_roll_ave := AVE(nirr_history);
    SELF.non_irrigated_roll_std := SQRT(VARIANCE(DATASET(nirr_history,array_rec),num));

    all_history := IF(prev.state_alpha = curr.state_alpha 
                        and prev.county_name = curr.county_name
                        and prev.statisticcat_desc = curr.statisticcat_desc
                        and prev.crop = curr.crop,
                            ([curr.ALL_PRODN_PRACTICES]+prev.all_history)[..10],
                            [curr.ALL_PRODN_PRACTICES]);
    SELF.all_history := all_history;
    SELF.all_roll_ave := AVE(all_history);
    SELF.all_roll_std := SQRT(VARIANCE(DATASET(all_history,array_rec),num));
    SELF := curr;
END;

d := DATASET('~test::usda::hierarchy6::county::annual::corn_harvested_yield_production_planted',
                    statsRecE,flat,lookup);
ds:= sort(d,state_alpha,county_name,statisticcat_desc,crop,year);

recs4 := ITERATE(ds, computeRollingAve(LEFT, RIGHT), LOCAL);

recs5 := SORT(recs4, state_alpha, county_name, statisticcat_desc,crop, year);

recs6 := PROJECT(recs5, records.combinedrec);



OUTPUT(recs6,,'~test::usda::hierarchy6::county::annual::corn_harvested_yield_production_planted_Averages',thor,overwrite);
