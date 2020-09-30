import $;

tue_satMorning := 
// CRON('25 19 * * *');
CRON('30 13 * * 2-6');
//17 - 1pm

SEQUENTIAL(
    $.nass_daily_spray,
    $.processquickstatsfiles
        ) : WHEN(tue_satMorning);
// $.nass_daily_spray : WHEN(tue_satMorning)