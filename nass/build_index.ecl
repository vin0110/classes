import $.records;

filename:= '~test::usda::economics::hierarchy6::state::annual::income_Formatted';
ds := DATASET(filename, 
                {records.combinedrec,UNSIGNED8 fpos {virtual(fileposition)}},
                // RECORDOF(filename,{ integer year, string2 state_alpha, string177 crop ,UNSIGNED8 fpos {virtual(fileposition)}}, lookup),
                FLAT,lookup);
IDX_byStateYearCrop :=
INDEX(ds,{state_alpha,year,crop,fpos},'~test::usda::economics::hierarchy6::state::annual::income_Formatted_index');

BUILDINDEX(IDX_byStateYearCrop,OVERWRITE);