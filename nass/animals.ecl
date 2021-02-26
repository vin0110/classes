import $.records;

logical_file_name := '~test::usda::quick_stats_';

df1 := dataset(logical_file_name+'animals_products',
    Records.QuickStatsRecord, thor);
// df2 := dataset(logical_file_name+'crops',
//     Records.QuickStatsRecord, thor);
// df3 := dataset(logical_file_name+'demographics',
//     Records.QuickStatsRecord, thor);
// df4 := dataset(logical_file_name+'economics',
//     Records.QuickStatsRecord, thor);
// df5 := dataset(logical_file_name+'environmental',
//     Records.QuickStatsRecord, thor);

// dfall := df1 + df2 + df3 + df4 + df5;
// df := dfall;

df := df1;

output(df(
    source_desc='SURVEY',
    sector_desc='ANIMALS & PRODUCTS',
    group_desc='POULTRY',
    commodity_desc='CHICKENS',
    class_desc='BROILERS',
    prodn_practice_desc='ALL PRODUCTION PRACTICES',
    statisticcat_desc='PRODUCTION',
    domain_desc='TOTAL',
    agg_level_desc='STATE',
    state_alpha='NC',
    unit_desc='$',
    year>2015,
    freq_desc='ANNUAL',
    reference_period_desc='YEAR'
));
