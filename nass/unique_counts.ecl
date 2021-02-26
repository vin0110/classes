import $.records;

//category := 'animals_products';
//category := 'crops';
//category := 'demographics';
//category := 'economics';
//category := 'environmental';

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
    source_desc,
    sector_desc,
    group_desc,
    commodity_desc,
    class_desc,
    prodn_practice_desc,
    util_practice_desc,
    statisticcat_desc,
    domain_desc,
    domaincat_desc,
    agg_level_desc
    },
    source_desc,
    sector_desc,
    group_desc,
    commodity_desc,
    class_desc,
    prodn_practice_desc,
    util_practice_desc,
    statisticcat_desc,
    domain_desc,
    domaincat_desc,
    agg_level_desc
);

//output(df);

s1 := table(df, {source_desc}, source_desc);
s1a := SORT(s1, source_desc);
s1b := count(s1a);
output('sector_desc');
output(s1b);
if(s1b<20, output(s1a));

s2 := table(df, {sector_desc}, sector_desc);
s2a := SORT(s2, sector_desc);
s2b := count(s2a);
output('sector_desc');
output(s2b);
if(s2b<20, output(s2a));

s3 := table(df, {group_desc}, group_desc);
s3a := SORT(s3, group_desc);
s3b := count(s3a);
output('group_desc');
output(s3b);
if(s3b<20, output(s3a));

s4 := table(df, {commodity_desc}, commodity_desc);
s4a := SORT(s4, commodity_desc);
s4b := count(s4a);
output('commodity_desc');
output(s4b);
if(s4b<20, output(s4a));

s5 := table(df, {class_desc}, class_desc);
s5a := SORT(s5, class_desc);
s5b := count(s5a);
output('class_desc');
output(s5b);
if(s5b<20, output(s5a));

s6 := table(df, {prodn_practice_desc}, prodn_practice_desc);
s6a := SORT(s6, prodn_practice_desc);
s6b := count(s6a);
output('prodn_practice_desc');
output(s6b);
if(s6b<20, output(s6a));

s7 := table(df, {util_practice_desc}, util_practice_desc);
s7a := SORT(s7, util_practice_desc);
s7b := count(s7a);
output('util_practice_desc');
output(s7b);
if(s7b<20, output(s7a));

s8 := table(df, {statisticcat_desc}, statisticcat_desc);
s8a := SORT(s8, statisticcat_desc);
s8b := count(s8a);
output('statisticcat_desc');
output(s8b);
if(s8b<20, output(s8a));

s9 := table(df, {domain_desc}, domain_desc);
s9a := SORT(s9, domain_desc);
s9b := count(s9a);
output('domain_desc');
output(s9b);
if(s9b<20, output(s9a));

s10 := table(df, {domaincat_desc}, domaincat_desc);
s10a := SORT(s10, domaincat_desc);
s10b := count(s10a);
output('domaincat_desc');
output(s10b);
if(s10b<20, output(s10a));

s11 := table(df, {agg_level_desc}, agg_level_desc);
s11a := SORT(s11, agg_level_desc);
s11b := count(s11a);
output('agg_level_desc');
output(s11b);
if(s11b<20, output(s11a));
