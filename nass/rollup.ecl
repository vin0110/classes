import $.records;

filename:='~test::usda::state_annual_Fieldcrops_CORN';
// ds := dataset(filename, recordof(filename,lookup),thor);
ds := dataset(filename, records.QuickStatsRecord,thor);

filteredDs:=ds(prodn_practice_desc = 'ALL PRODUCTION PRACTICES',source_desc = 'CENSUS',reference_period_desc='YEAR');

groupds:= GROUP(SORT(filteredDs, statisticcat_desc),statisticcat_desc);

tempDs := ROLLUP(groupds, GROUP,
            TRANSFORM(Records.nested_record,
                self.sub_record := project(Rows(left),TRANSFORM(records.sub_record, SELF := LEFT));
                SELF := LEFT));

output(tempDs,,'~test::usda::rollup',thor,overwrite);
