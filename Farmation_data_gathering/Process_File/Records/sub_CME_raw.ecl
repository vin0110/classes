tradeDate:=RECORD
  String lastTradeDate{xpath('dateOnlyLongFormat')}
END;
EXPORT sub_CME_raw:=record
 STRING10 last_val{xpath('last')} ;
 STRING10 change{xpath('change')};
 STRING10 priorSettle{xpath('priorSettle')};
 STRING10 open{xpath('open')};
 STRING10 close{xpath('close')};
 STRING10 high{xpath('high')};
 STRING10 low{xpath('low')};
 STRING10 highLimit{xpath('highLimit')};
 STRING10 volume{xpath('volume')};
 STRING mdKey{xpath('mdKey')};
 STRING10 quoteCode{xpath('quoteCode')};
 STRING10 escapedQuoteCode{xpath('escapedQuoteCode')};
 STRING10 code{xpath('code')};
 STRING updated{xpath('updated')};
 STRING10 percentageChange{xpath('percentageChange')};
 STRING10 expirationMonth{xpath('expirationMonth')};
 STRING10 expirationCode{xpath('expirationCode')};
 STRING10 expirationDate{xpath('expirationDate')};
 STRING productName{xpath('productName')};
 STRING10 productCode{xpath('productCode')};
 STRING uri{xpath('uri')};
 STRING10 productId{xpath('productId')};
 STRING10 exchangeCode{xpath('exchangeCode')};
 STRING optionUri{xpath('optionUri')};
 STRING10 hasOption{xpath('hasOption')};
 STRING10 netChangeStatus{xpath('netChangeStatus')};
 STRING highLowLimits{xpath('highLowLimits')};
 DATASET(tradeDate) lastTradeDateSet{xpath('lastTradeDate')};
END;