import $;

tue_satMorning := 
// CRON('25 19 * * *');
CRON('30 22 * * *');
//17 - 1pm

SEQUENTIAL(
    $.CME_spray,
    $.Process_CME
        ) : WHEN(tue_satMorning);
