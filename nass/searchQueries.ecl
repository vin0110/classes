IMPORT  $.Records,STD;
//category := 'animals_products';
//category := 'crops';
//category := 'demographics';
//category := 'economics';
//category := 'environmental';

category := 'crops' : stored('cat');

logical_file_name := '~test::usda::quick_stats_crops';

raw := DATASET(logical_file_name, Records.QuickStatsRecord, flat);

raw1 := raw(commodity_desc = 'CORN',statisticcat_desc = 'YIELD', short_desc='CORN, GRAIN - YIELD, MEASURED IN BU / ACRE',agg_level_desc = 'STATE', state_alpha = 'NC'  or state_alpha = 'IA');
	
OUTPUT(raw1,,'~test::usda::searchResult',overwrite);