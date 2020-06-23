# NASS

## State x Annual

Extract only values at state level aggregated yearly from `quick_stats_crops`.

Try one:

* agg_level_dec = 'STATE'
* freq_desc = 'ANNUAL'

Got 51 states.
One of the states is "OT" -- other.

Try two:


* agg_level_dec = 'STATE'
* state_ansi != 0
* freq_desc = 'ANNUAL'

Now only 50 states.

* source_desc: census 1.8M; survey 0.8M
* sector_desc: 100% crops --- makes sense: only reading from crops file.
* group_desc:
  * CROP_TOTALS: 15K
  * FIELD_CROPS: 1.3M
  * FRUIT & TREE NUTS: 0.3M
  * HORTICULTURE: 0.6M
  * VEGETABLES: 0.4M
* statisticcat_desc: 46 results; 13 > 9999; 25 < 1000
  
### W20200623-124141

This work
[unit]*http://localhost:8123/?Wuid=W20200623-124141&Widget=WUDetailsWidget)
looks at `statisticcat_desc` by
* source_desc (census or survey)
* group_desc ('CROP TOTALS', 'FIELD CROPS', 'FRUIT & TREE NUTS', 'HORTICULTURE','VEGETABLES')


test::usda::state_annual_fieldcrops_corn 
* contains pretty readable data
* If we filter there by year (eg. 1955) the data looks comporehensible and presentable.
* Also the scattered cardinality of statisticcat_desc too makes sense now as it is a combination of statisticcat_desc and unit_desc
* We can restructure at this level into complex DS's and form queries.