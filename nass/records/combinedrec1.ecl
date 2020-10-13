export combinedrec1 := RECORD
    $.QuickstatsRecord.year;
	// $.QuickstatsRecord.begin_code;//
	// $.QuickstatsRecord.end_code;//
    $.QuickstatsRecord.state_alpha;
	$.QuickStatsRecord.county_name;
	$.QuickstatsRecord.statisticcat_desc;
	$.QuickstatsRecord.unit_desc;//

	string177 crop;
	// decimal price_received;
    // string unit_price_received;
	// decimal GAIN;
    // string unit_GAIN;
	// decimal EXPENSE;
    // string unit_EXPENSE;
	// decimal NET_INCOME;
    // string unit_NET_INCOME;
	decimal IRRIGATED;
    DECIMAL17_2 irrigated_roll_ave;
    DECIMAL17_2 irrigated_roll_std;
    // string unit_Area_harvested;
	decimal NON_IRRIGATED;
    DECIMAL17_2 non_irrigated_roll_ave;
    DECIMAL17_2 non_irrigated_roll_std;
    // string unit_production;
	decimal ALL_PRODN_PRACTICES;
    DECIMAL17_2 all_roll_ave;
    DECIMAL17_2 all_roll_std;
    // string unit_yield;
	// decimal Area_planted;
    // string unit_Area_planted;
END;
