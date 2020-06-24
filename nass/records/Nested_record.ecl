import $;
export Nested_record := RECORD
    $.Quickstats_state_annual.statisticcat_desc;
	$.Quickstats_state_annual.util_practice_desc;
	$.Quickstats_state_annual.domain_desc;
	$.Quickstats_state_annual.short_desc;
	$.Quickstats_state_annual.cv;
    DATASET($.sub_Record) sub_record;
END;
