const int STATE_ANNUAL_CROP = 1;
const int STATE_MONTHLY_CROP = 2;
const int ECONOMICS_ANNUAL_INCOME = 3;
const int ECONOMICS_ANNUAL_AG_LAND = 4;
const int EXP = 5;

const String ENDPOINT_URL = 'http://localhost:8002/WsEcl/submit/query/thor/';

const int COMPARISON_MODE_NONE = 0;
const int COMPARISON_MODE_WHERE = 1;
const int COMPARISON_MODE_WHAT = 2;

const Map QUERIES = {
  STATE_ANNUAL_CROP: 'fetchquery1',
  STATE_MONTHLY_CROP: 'state_monthly',
  ECONOMICS_ANNUAL_INCOME: 'economics_getincome',
  ECONOMICS_ANNUAL_AG_LAND: 'economics_getagland',
  EXP: 'fetchquery3'
};
const Map VARIANTS = {
  STATE_ANNUAL_CROP: 'getcroplist1',
  STATE_MONTHLY_CROP: 'state_monthly_crop_list',
  ECONOMICS_ANNUAL_INCOME: 'economics_getincomevariantsbystate',
  ECONOMICS_ANNUAL_AG_LAND: 'economics_getaglandvariantsbystate',
  EXP: 'getcroplist2'
};
