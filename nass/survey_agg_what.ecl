import $.records;

StatsRecord := RECORD
    string6 source_desc;
    string25 group_desc;
    string50 commodity_desc;
    string100 class_desc;
    string60 prodn_practice_desc;
    string30 util_practice_desc;
    string35 statisticcat_desc;
    string30 unit_desc;
    string50 domain_desc;
    string domaincat_desc;
    string13 freq_desc;
    string10 agg_level_desc;
    string10 reference_period_desc;
    integer4 year;
    integer8 _unnamed_sum_total14;
END;

agg := 'STATE' : stored('agg');
freq := 'ANNUAL' : stored('freq');
//above := 500 : stored('limit');

logical_file_name := '~test::usda::quick_stats_';

df1 := dataset(logical_file_name+'animals_products', StatsRecord, thor);
df2 := dataset(logical_file_name+'crops', StatsRecord, thor);
df3 := dataset(logical_file_name+'demographics', StatsRecord, thor);
df4 := dataset(logical_file_name+'economics', StatsRecord, thor);
df5 := dataset(logical_file_name+'environmental', StatsRecord, thor);

df := df1 + df2 + df3 + df4 + df5;

output_file_name := '~test::usda::survey_agg_' + agg + '_' + freq;

tab := table(
    df(source_desc='SURVEY', agg_level_desc=agg, freq_desc=freq, year>1999),
    {
    source_desc,
    group_desc,
    commodity_desc,
    class_desc,
    prodn_practice_desc,
    util_practice_desc,
    statisticcat_desc,
    unit_desc,
    domain_desc,
    domaincat_desc,
    freq_desc,
    agg_level_desc,
    reference_period_desc,
    SUM(GROUP, _unnamed_sum_total14)
    },
    source_desc,
    group_desc,
    commodity_desc,
    class_desc,
    prodn_practice_desc,
    util_practice_desc,
    statisticcat_desc,
    unit_desc,
    domain_desc,
    domaincat_desc,
    freq_desc,
    agg_level_desc,
    reference_period_desc
);

output(tab,,output_file_name,overwrite);

//output(count(tab(_unnamed_sum__unnamed_cnt_1211>1000000)));
