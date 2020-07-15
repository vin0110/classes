import $;
export Nested_record := RECORD
	$.QuickstatsRecord.year;
	$.QuickstatsRecord.begin_code;//
	$.QuickstatsRecord.end_code;//
	$.QuickstatsRecord.reference_period_desc;//
	$.QuickstatsRecord.state_alpha;
    $.QuickstatsRecord.commodity_desc;
	$.QuickstatsRecord.class_desc;
	$.QuickstatsRecord.util_practice_desc;
	$.QuickStatsRecord.prodn_practice_desc;
	$.QuickStatsRecord.county_name;
	$.QuickStatsRecord.source_desc;
	$.QuickstatsRecord.short_desc;
	$.QuickstatsRecord.cv;
    DATASET($.sub_Record) sub_record;
END;
