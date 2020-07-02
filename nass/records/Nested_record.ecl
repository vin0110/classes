import $;
export Nested_record := RECORD
    $.QuickstatsRecord.commodity_desc;
	$.QuickstatsRecord.class_desc;
	$.QuickstatsRecord.util_practice_desc;
	$.QuickstatsRecord.short_desc;
	$.QuickstatsRecord.cv;
    DATASET($.sub_Record) sub_record;
END;
