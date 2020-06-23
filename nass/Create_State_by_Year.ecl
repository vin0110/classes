import $.includes;

ds := includes.commodity_index_records;
a:=ds(state_alpha = 'NC');
output(SORT(a,county_name,year), {year,state_name, county_name,asd_desc,statisticcat_desc,value,unit_desc,freq_desc},'~test::usda::NC_Data',overwrite);