IMPORT $.Records,std;

// files:= STD.File.RemoteDirectory('10.0.2.4', '/var/lib/HPCCSystems/mydropzone/incoming/cme/Corn', '*', True);

today := STD.Date.AdjustDate(STD.Date.Today(),0,0,-0);

$.records.ContractLayout tnf(String tradeDate, $.records.sub_CME_raw rec) := TRANSFORM
    SELF.crop := STD.Str.ToLowerCase(rec.productCode[2]);
    dte := std.date.FromStringToDate(tradeDate, '%d %b %Y');
    expDte := std.date.FromStringToDate(rec.expirationMonth, '%b %Y');
    lstTrdDte := std.date.FromStringToDate(rec.lastTradeDateSet[1].lastTradeDate, '%d %b %Y');
    SELF.ContractMonth := STD.Date.Month(expDte);
    SELf.ContractYear := STD.Date.Year(expDte);;
    SELf.DaysToExpire := STD.Date.DaysBetween(dte,lstTrdDte);
    SELf.Date := dte;
    SELf.Open := (DECIMAL)STD.Str.FindReplace( rec.open,'\'', '.' );
    SELf.High := (DECIMAL)STD.Str.FindReplace( rec.high,'\'', '.' );
    SELf.Low := (DECIMAL)STD.Str.FindReplace( rec.low,'\'', '.' );
    SELf.Close := (DECIMAL)STD.Str.FindReplace( rec.last_val,'\'', '.' );
    SELf.Volume := (DECIMAL)STD.Str.FindReplace( rec.volume,',', '' );
    SELF := [];
END;

$.records.marsRec tnfMars($.Records.MARS_raw rec) := TRANSFORM,
    skip(rec.avg_price = '')
    SELF.date := today;
    SELF.location_city := rec.location_city;
    SELf.field3 := IF(rec.delivery_point='Country Elevators', 'elevator', 'feed_mill');
    SELf.commodity := STD.Str.ToLowerCase(IF(rec.commodity = 'Soybeans', 'soy', rec.commodity));
    SELf.price := (DECIMAL)rec.avg_price;
    SELF := [];
END;

cornToday := DATASET('~test::tbd::cme::raw::cmeCorn'+today+'.json',$.Records.CME_group_raw,JSON('/'));
SoyToday := DATASET('~test::tbd::cme::raw::cmeSoy'+today+'.json',$.Records.CME_group_raw,JSON('/'));
WheatToday := DATASET('~test::tbd::cme::raw::cmeWheat'+today+'.json',$.Records.CME_group_raw,JSON('/'));
feeder_cattle_futuresToday := DATASET('~test::tbd::cme::raw::cmefeeder_cattle_futures'+today+'.json',$.Records.CME_group_raw,JSON('/'));
lean_hog_futuresToday := DATASET('~test::tbd::cme::raw::cmelean_hog_futures'+today+'.json',$.Records.CME_group_raw,JSON('/'));
live_cattle_futuresToday := DATASET('~test::tbd::cme::raw::cmelive_cattle_futures'+today+'.json',$.Records.CME_group_raw,JSON('/'));
marsToday := DATASET('~test::mars::raw::ra_gr110_20201125.json',$.Records.MARS_raw,JSON('/results/'));

cornNorm := NORMALIZE(cornToday, LEFT.quotes,tnf(LEFT.tradeDate,RIGHT));
SoyNorm := NORMALIZE(SoyToday, LEFT.quotes,tnf(LEFT.tradeDate,RIGHT));
WheatNorm := NORMALIZE(WheatToday, LEFT.quotes,tnf(LEFT.tradeDate,RIGHT));
feeder_cattle_futuresNorm := NORMALIZE(feeder_cattle_futuresToday, LEFT.quotes,tnf(LEFT.tradeDate,RIGHT));
lean_hog_futuresNorm := NORMALIZE(lean_hog_futuresToday, LEFT.quotes,tnf(LEFT.tradeDate,RIGHT));
live_cattle_futuresNorm := NORMALIZE(live_cattle_futuresToday, LEFT.quotes,tnf(LEFT.tradeDate,RIGHT));
marsNorm := PROJECT(marsToday, tnfMars(LEFT));

corn := DATASET('~test::tbd::cme::new::corn',$.records.ContractLayout,flat);
Soy := DATASET('~test::tbd::cme::new::soy',$.records.ContractLayout,flat);
Wheat := DATASET('~test::tbd::cme::new::wheat',$.records.ContractLayout,flat);
feeder_cattle_futures := DATASET('~test::tbd::cme::new::feeder_cattle_futures',$.records.ContractLayout,flat);
lean_hog_futures := DATASET('~test::tbd::cme::new::lean_hog_futures',$.records.ContractLayout,flat);
live_cattle_futures := DATASET('~test::tbd::cme::new::live_cattle_futures',$.records.ContractLayout,flat);
mars := DATASET('~test::mars::new::ra_gr110',$.records.marsRec,flat);


SEQUENTIAL(
OUTPUT(DEDUP(cornNorm+corn),,'~test::tbd::cme::new::corntmp',overwrite),
STD.File.RenameLogicalFile( '~test::tbd::cme::new::corntmp', '~test::tbd::cme::new::corn', true)
);
SEQUENTIAL(
OUTPUT(DEDUP(SoyNorm+Soy),,'~test::tbd::cme::new::soytmp',overwrite),
STD.File.RenameLogicalFile( '~test::tbd::cme::new::soytmp', '~test::tbd::cme::new::soy', true)
);
SEQUENTIAL(
OUTPUT(DEDUP(WheatNorm+Wheat),,'~test::tbd::cme::new::wheattmp',overwrite),
STD.File.RenameLogicalFile( '~test::tbd::cme::new::wheattmp', '~test::tbd::cme::new::wheat', true)
);
SEQUENTIAL(
OUTPUT(DEDUP(feeder_cattle_futuresNorm+feeder_cattle_futures),,'~test::tbd::cme::new::feeder_cattle_futurestmp',overwrite),
STD.File.RenameLogicalFile( '~test::tbd::cme::new::feeder_cattle_futurestmp', '~test::tbd::cme::new::feeder_cattle_futures', true)
);
SEQUENTIAL(
OUTPUT(DEDUP(lean_hog_futuresNorm+lean_hog_futures),,'~test::tbd::cme::new::lean_hog_futurestmp',overwrite),
STD.File.RenameLogicalFile( '~test::tbd::cme::new::lean_hog_futurestmp', '~test::tbd::cme::new::lean_hog_futures', true)
);
SEQUENTIAL(
OUTPUT(DEDUP(live_cattle_futuresNorm+live_cattle_futures),,'~test::tbd::cme::new::live_cattle_futurestmp',overwrite),
STD.File.RenameLogicalFile( '~test::tbd::cme::new::live_cattle_futurestmp', '~test::tbd::cme::new::live_cattle_futures', true)
);
SEQUENTIAL(
OUTPUT(DEDUP(marsNorm+mars),,'~test::mars::new::ra_gr110tmp',overwrite),
STD.File.RenameLogicalFile( '~test::mars::new::ra_gr110tmp', '~test::mars::new::ra_gr110', true)
);

today;
// parsed := PROJECT(files[0..1], tnf(left.name));
                    // SELF := DATASET('~test::cme::cmeCorn20201111210156.json',$.Records.CME_group_raw,JSON('/'));


// parsed;
// STD.File.LogicalFileList(( '*filename*', Includenormal, Includesuper, Unknownszeror,'sourceDali');


// STD.File.MoveExternalFile( 'IP/DNS', 'frompath', 'topath' );

// STD.File.CreateExternalDirectory( 'IP/DNS', 'frompath');

// STD.File.DeleteExternalFile( 'IP/DNS', 'frompath');