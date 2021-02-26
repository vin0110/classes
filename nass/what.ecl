stats_record := RECORD
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
    integer8 _unnamed_cnt_12;
END;

df1 := dataset('~test::usda::what', stats_record, thor);
df := df1(_unnamed_cnt_12>999);
output(df,,'~test::usda::what_1000_or_more',overwrite);

tab := table(
    df,
    {
    source_desc,
    group_desc,
    commodity_desc,
    COUNT(GROUP),
    SUM(GROUP, _unnamed_cnt_12)
    },
    source_desc,
    group_desc,
    commodity_desc
);
output(tab,,'~test::usda::what_1000_or_more_summary',overwrite);
