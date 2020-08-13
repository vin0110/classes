import $.records;

filename:= '~test::usda::exp2';
ds := DATASET(filename, 
                {records.combinedrec,UNSIGNED8 fpos {virtual(fileposition)}},
                // RECORDOF(filename,{ integer year, string2 state_alpha, string177 crop ,UNSIGNED8 fpos {virtual(fileposition)}}, lookup),
                FLAT,lookup);
IDX_byStateYearCrop :=
INDEX(ds,{state_alpha,crop,fpos},'~test::usda::exp2_index');

BUILDINDEX(IDX_byStateYearCrop,OVERWRITE);