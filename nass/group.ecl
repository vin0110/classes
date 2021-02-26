import $.records;

logical_file_name := '~test::usda::state_annual';

df := dataset(logical_file_name, Records.QuickStatsRecord, thor);
output(Table(df,
    {group_desc, source_desc, statisticcat_desc, COUNT(GROUP)},
    group_desc, source_desc, statisticcat_desc));


