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
df := table(
    dfall,
    {
    freq_desc,
    reference_period_desc,
    agg_level_desc
    },
    freq_desc,
    reference_period_desc,
    agg_level_desc
);

s := DEDUP(df);

//output(s);
output(s,,'~test::usda::agg_levels',overwrite);
