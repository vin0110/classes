IMPORT $, $.Dictionaries, $.Records, $.Transforms, STD;

String superfilename := '' : Stored('superfilename');

SubFiles := NOTHOR(STD.File.SuperFileContents('~'+superfilename));

NestedDS := PROJECT(SubFiles, Transforms.FromFileNamesToNestedDS(LEFT.name));

finalContent := NORMALIZE(NestedDS,LEFT.file,Transforms.NormalizedToFinalFormat(RIGHT,LEFT.individualRec[1]));

outputFilename := '~'+superfilename + '_formatted';
superFileName1 := '~test::tbd::crop_prices_sf';

SEQUENTIAL(
IF(STD.File.SuperFileExists( superfileName1), STD.File.RemoveSuperFile(superFileName1,outputFilename)),

Output(finalContent,,outputFilename,overwrite),

STD.File.CreateSuperFile( superfileName1,false,true);

STD.File.AddSuperFile(superFileName1,outputFilename));
