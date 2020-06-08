IMPORT $.^.Records;

Export Records.midlevelDS mdt(Records.midlevelDS L) := TRANSFORM
 SELF := L
END;