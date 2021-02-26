import $.records;

export includes := module
    export corn_index_file := '~test::usda::IDX_corn';

    //category := 'animals_products';
    category := 'crops';
    //category := 'demographics';
    //category := 'economics';
    //category := 'environmental';

    export logical_file_name := '~test::usda::quick_stats_' + category;

    export commodity_index_records := dataset(logical_file_name,
	{Records.QuickStatsRecord, UNSIGNED8 fpos {virtual(fileposition)}},
	thor);

    export corn_index_records := commodity_index_records(
	commodity_desc='CORN',
	year>=2015);

    export corn_index := INDEX(corn_index_records,
	{state_alpha,statisticcat_desc,fpos}, corn_index_file);
end;