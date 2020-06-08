IMPORT STD, $.Records;

abc := DATASET('~test::TBD::crop_prices_SF', Records.ContractLayout, THOR);
OUTPUT(abc,,'~test::TBD::crop_prices',overwrite)
