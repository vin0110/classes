IMPORT $.includes;
IMPORT $.records;

state := 'AL' : stored('state');
stat_cat := 'AREA PLANTED' : stored('cat');

fetch_corn :=
    FETCH(includes.corn_index_records,
	includes.corn_index(state_alpha=state, statisticcat_desc=stat_cat),
	RIGHT.fpos);
OUTPUT(fetch_corn); //,{year,state_name,statisticcat_desc,value,unit_desc,freq_desc});