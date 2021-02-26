import $;
EXPORT CME_group_raw := RECORD
 String tradeDate{xpath('tradeDate')};
 DATASET($.sub_CME_raw) quotes{xpath('quotes')};
end;
