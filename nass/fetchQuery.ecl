IMPORT $.records,std;

filename:= '~test::usda::hierarchy6::state::annual::corn_wheat_barley_hay_Formatted';

ds := DATASET(filename, 
                {records.combinedrec,UNSIGNED8 fpos {virtual(fileposition)}},
                FLAT,lookup);
idx := INDEX(ds,{state_alpha,year,crop,fpos},'~test::usda::hierarchy6::state::annual::corn_wheat_barley_hay_Formatted_index');

// integer4 yearVar := 2009 :STORED('year');
STRING117 cropVar := 'BARLEY -ALL CLASSES -ALL UTILIZATION PRACTICES' :STORED('crop');
STRING2 state := 'NC' :STORED('state');
resultSet :=
 FETCH(ds,
 idx(state_alpha=state,  STD.Str.CleanSpaces(crop) = STD.Str.CleanSpaces(cropVar)),
 RIGHT.fpos);
OUTPUT(resultset);


