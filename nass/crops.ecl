import $.records;

logical_file_name := '~test::usda::quick_stats_';

df1 := dataset(logical_file_name+'animals_products',
    Records.QuickStatsRecord, thor);
df2 := dataset(logical_file_name+'crops',
    Records.QuickStatsRecord, thor);
df3 := dataset(logical_file_name+'demographics',
    Records.QuickStatsRecord, thor);
df4 := dataset(logical_file_name+'economics',
    Records.QuickStatsRecord, thor);
df5 := dataset(logical_file_name+'environmental',
    Records.QuickStatsRecord, thor);

dfall := df1 + df2 + df3 + df4 + df5;

//df := df2;
df := dfall;

output(df(
    source_desc='SURVEY',
    //sector_desc='CROPS',
    //group_desc='CROP TOTALS',
    // commodity_desc='CORN',
    // commodity_desc='SWEET POTATOES',
    // commodity_desc='BARLEY',
    // commodity_desc='COTTON',
    // commodity_desc='COTTON',
    statisticcat_desc='PRODUCTION',
    domain_desc='TOTAL',
    agg_level_desc='STATE',
    state_alpha='NC',
    unit_desc='$',
    year=2020,
    freq_desc='ANNUAL',
    reference_period_desc='YEAR'
),{state_alpha,year,short_desc, value});
