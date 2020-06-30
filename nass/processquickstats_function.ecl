
export processquickstats_function(String category) := FUNCTION
  IMPORT $.Records, STD;

    today := STD.date.today();

    raw_file_name := '~test::usda::qs.' + category + '_' + today + '.txt';

    raw := DATASET(raw_file_name, Records.RawQSRecord, csv(heading(1)));
    df := PROJECT(raw, 
        TRANSFORM(Records.QuickStatsRecord,
            date := STD.Str.SplitWords(LEFT.load_time, ' ', false);
            SELF.LOAD_DATE := STD.date.FromStringToDate(date[1], '%Y-%m-%d');
            SELF.LOAD_TIME := STD.date.FromStringToTime(date[2], '%H-%M-%S');
            SELF.STATE_ANSI := (INTEGER)LEFT.STATE_ANSI;
            SELF.STATE_FIPS_CODE := (INTEGER)LEFT.STATE_FIPS_CODE;
            SELF.ASD_CODE := (INTEGER)LEFT.ASD_CODE;
            SELF.COUNTY_ANSI := (INTEGER)LEFT.COUNTY_ANSI;
            SELF.COUNTY_CODE := (INTEGER)LEFT.COUNTY_CODE;
            SELF.WATERSHED_CODE := (INTEGER)LEFT.WATERSHED_CODE;
            SELF.COUNTRY_CODE := (INTEGER)LEFT.COUNTRY_CODE;
            SELF.YEAR := (INTEGER)LEFT.YEAR;
            SELF.BEGIN_CODE := (INTEGER)LEFT.BEGIN_CODE;
            SELF.END_CODE := (INTEGER)LEFT.END_CODE;
            SELF.VALUE := (DECIMAL)LEFT.VALUE;
            SELF := LEFT));
	
  return df ;
END;