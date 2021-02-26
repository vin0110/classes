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

df := dataset('~test::usda::what', stats_record, thor);

tab := table(
    df,
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
    SUM(GROUP, _unnamed_cnt_12)
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
    domaincat_desc
);

output(tab,,'~test::usda::what_all',overwrite);

//output(count(tab(_unnamed_sum__unnamed_cnt_1211>1000000)));
