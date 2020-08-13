IMPORT $.records,std;

filename:= '~test::usda::exp2';

ds := DATASET(filename, 
                {records.combinedrec,UNSIGNED8 fpos {virtual(fileposition)}},
                FLAT,lookup);
idx := INDEX(ds,{state_alpha,crop,fpos},'~test::usda::exp2_index');

// integer4 yearVar := 2009 :STORED('year');
STRING117 cropVar := 'BARLEY -ALL CLASSES -ALL UTILIZATION PRACTICES' :STORED('crop');
STRING2 state := 'NC' :STORED('state');
resultSet :=
 FETCH(ds,
 idx(state_alpha=state,  STD.Str.CleanSpaces(crop) = STD.Str.CleanSpaces(cropVar)),
 RIGHT.fpos);
OUTPUT(resultset);


