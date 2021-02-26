import std;

today := STD.Date.Today();

// OUTPUT(STD.Date.CurrentTime(True));
PARALLEL(
    STD.File.SprayDelimited('10.0.2.4','/var/lib/HPCCSystems/mydropzone/qs.environmental_'+today+'.txt',
                            ,
                            '\\t',,,
                            'mythor','~test::usda::qs.environmental_'+today+'.txt',,,,
                            true,false,false,,false,,,,,);

    STD.File.SprayDelimited('10.0.2.4','/var/lib/HPCCSystems/mydropzone/qs.animals_products_'+today+'.txt',
                            ,
                            '\\t',,,
                            'mythor','~test::usda::qs.animals_products_'+today+'.txt',,,,
                            true,false,false,,false,,,,,);

    STD.File.SprayDelimited('10.0.2.4','/var/lib/HPCCSystems/mydropzone/qs.crops_'+today+'.txt',
                            ,
                            '\\t',,,
                            'mythor','~test::usda::qs.crops_'+today+'.txt',,,,
                            true,false,false,,false,,,,,);

    STD.File.SprayDelimited('10.0.2.4','/var/lib/HPCCSystems/mydropzone/qs.demographics_'+today+'.txt',
                            ,
                            '\\t',,,
                            'mythor','~test::usda::qs.demographics_'+today+'.txt',,,,
                            true,false,false,,false,,,,,);

    STD.File.SprayDelimited('10.0.2.4','/var/lib/HPCCSystems/mydropzone/qs.economics_'+today+'.txt',
                            ,
                            '\\t',,,
                            'mythor','~test::usda::qs.economics_'+today+'.txt',,,,
                            true,false,false,,false,,,,,);

    );

// STD.File.SprayDelimited('sourceIP','sourcepath',
//                         'int~sourceMaxRecordSize',
//                         'sourceCsvSeparate','sourceCsvTerminate','sourceCsvQuote',
//                         'destinationGroup','destinationlogicalname',,,,
//                          allowOverwrite,replicate,compress,,failIfNoSourceFile,,,,,int~expireDays);


