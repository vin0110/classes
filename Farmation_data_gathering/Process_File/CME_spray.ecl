import std;

today := STD.Date.AdjustDate(STD.Date.Today(),0,0,-0);
cornFiles:= STD.File.RemoteDirectory('10.0.2.4', '/var/lib/HPCCSystems/mydropzone/incoming/cme/Corn', 'cmeCorn'+'*', True);
cornNames:=SET(cornFiles(STD.Str.StartsWith(name,'cmeCorn'+today)), name); 
STD.File.SprayDelimited('10.0.2.4',
                    '/var/lib/HPCCSystems/mydropzone/incoming/cme/Corn/'+cornNames[1],,,,,
                    'mythor','~test::tbd::cme::raw::'+cornNames[1][1..length(cornNames[1])-11]+cornNames[1][length(cornNames[1])-4..],,,,True,False,False,,True,,,,,);

SoyFiles:= STD.File.RemoteDirectory('10.0.2.4', '/var/lib/HPCCSystems/mydropzone/incoming/cme/Soy', 'cmeSoy'+'*', True);
SoyNames:=SET(SoyFiles(STD.Str.StartsWith(name,'cmeSoy'+today)), name); 
STD.File.SprayDelimited('10.0.2.4',
                    '/var/lib/HPCCSystems/mydropzone/incoming/cme/Soy/'+SoyNames[1],,,,,
                    'mythor','~test::tbd::cme::raw::'+SoyNames[1][1..length(SoyNames[1])-11]+SoyNames[1][length(SoyNames[1])-4..],,,,True,False,False,,True,,,,,);

WheatFiles:= STD.File.RemoteDirectory('10.0.2.4', '/var/lib/HPCCSystems/mydropzone/incoming/cme/Wheat', 'cmeWheat'+'*', True);
WheatNames:=SET(WheatFiles(STD.Str.StartsWith(name,'cmeWheat'+today)), name); 
STD.File.SprayDelimited('10.0.2.4',
                    '/var/lib/HPCCSystems/mydropzone/incoming/cme/Wheat/'+WheatNames[1],,,,,
                    'mythor','~test::tbd::cme::raw::'+WheatNames[1][1..length(WheatNames[1])-11]+WheatNames[1][length(WheatNames[1])-4..],,,,True,False,False,,True,,,,,);

feeder_cattle_futuresFiles:= STD.File.RemoteDirectory('10.0.2.4', '/var/lib/HPCCSystems/mydropzone/incoming/cme/feeder_cattle_futures', 'cmefeeder_cattle_futures'+'*', True);
feeder_cattle_futuresNames:=SET(feeder_cattle_futuresFiles(STD.Str.StartsWith(name,'cmefeeder_cattle_futures'+today)), name); 
STD.File.SprayDelimited('10.0.2.4',
                    '/var/lib/HPCCSystems/mydropzone/incoming/cme/feeder_cattle_futures/'+feeder_cattle_futuresNames[1],,,,,
                    'mythor','~test::tbd::cme::raw::'+feeder_cattle_futuresNames[1][1..length(feeder_cattle_futuresNames[1])-11]+feeder_cattle_futuresNames[1][length(feeder_cattle_futuresNames[1])-4..],,,,True,False,False,,True,,,,,);

lean_hog_futuresFiles:= STD.File.RemoteDirectory('10.0.2.4', '/var/lib/HPCCSystems/mydropzone/incoming/cme/lean_hog_futures', 'cmelean_hog_futures'+'*', True);
lean_hog_futuresNames:=SET(lean_hog_futuresFiles(STD.Str.StartsWith(name,'cmelean_hog_futures'+today)), name); 
STD.File.SprayDelimited('10.0.2.4',
                    '/var/lib/HPCCSystems/mydropzone/incoming/cme/lean_hog_futures/'+lean_hog_futuresNames[1],,,,,
                    'mythor','~test::tbd::cme::raw::'+lean_hog_futuresNames[1][1..length(lean_hog_futuresNames[1])-11]+lean_hog_futuresNames[1][length(lean_hog_futuresNames[1])-4..],,,,True,False,False,,True,,,,,);

live_cattle_futuresFiles:= STD.File.RemoteDirectory('10.0.2.4', '/var/lib/HPCCSystems/mydropzone/incoming/cme/live_cattle_futures', 'cmelive_cattle_futures'+'*', True);
live_cattle_futuresNames:=SET(live_cattle_futuresFiles(STD.Str.StartsWith(name,'cmelive_cattle_futures'+today)), name); 
STD.File.SprayDelimited('10.0.2.4',
                    '/var/lib/HPCCSystems/mydropzone/incoming/cme/live_cattle_futures/'+live_cattle_futuresNames[1],,,,,
                    'mythor','~test::tbd::cme::raw::'+live_cattle_futuresNames[1][1..length(live_cattle_futuresNames[1])-11]+live_cattle_futuresNames[1][length(live_cattle_futuresNames[1])-4..],,,,True,False,False,,True,,,,,);

marsFiles:= STD.File.RemoteDirectory('10.0.2.4', '/var/lib/HPCCSystems/mydropzone/', 'ra_gr110_'+'*', True);
marsNames:=SET(marsFiles(name = 'ra_gr110_'+today+'.json'), name); 
STD.File.SprayDelimited('10.0.2.4',
                    '/var/lib/HPCCSystems/mydropzone/'+marsNames[1],,,,,
                    'mythor','~test::mars::raw::'+marsNames[1],,,,True,False,False,,True,,,,,);

// SEQUENTIAL(
//  STD.File.StartSuperFileTransaction(),
//  STD.File.CreateSuperFile( 'RawFile', True, True);
//  STD.File.ClearSuperFile('RawFile');
//  STD.File.CreateSuperFile( 'RawMarsFile', True, True);
//  STD.File.ClearSuperFile('RawMarsFile');
//  STD.File.AddSuperFile('RawMarsFile','~test::mars::raw::'+marsNames[1]),
//  STD.File.AddSuperFile('RawFile','~test::tbd::cme::raw::'+cornNames[1]),
//  STD.File.AddSuperFile('RawFile','~test::tbd::cme::raw::'+SoyNames[1]),
//  STD.File.AddSuperFile('RawFile','~test::tbd::cme::raw::'+WheatNames[1]),
//  STD.File.AddSuperFile('RawFile','~test::tbd::cme::raw::'+feeder_cattle_futuresNames[1]),
//  STD.File.AddSuperFile('RawFile','~test::tbd::cme::raw::'+lean_hog_futuresNames[1]),
//  STD.File.AddSuperFile('RawFile','~test::tbd::cme::raw::'+live_cattle_futuresNames[1]),
//  STD.File.AddSuperFile('RawFile','~test::tbd::cme::raw::'+live_cattle_futuresNames[1]),
//  STD.File.FinishSuperFileTransaction()
// );

