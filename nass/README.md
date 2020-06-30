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


Proposal:
There are 6 hierarchies that cann be followed for extracting presentable data:
Hierarchy1: What->where->when
Hierarchy2: What->when->where
Hierarchy3: When->what->where
.
.
.
Hierarchy6:When->where->what

The structure in logical file section would follow the given convention:
test::usda::hierarchy(#)::topmost_hierarchy_scope::midlevel_hierarchy_scope::bottomlevel_hierarchy_scope

Explained further below:

Picking up hierarchy1 to start with (what followed by where followed by where)
In this hierarchy, we shal have 3 levels of data filteration to comply with the hierarchy
level1: the what
    the 58,000 combinations of what are summarized in the short_desc field
          (for validation, I used a filter by short_desc='CORN, GRAIN - YIELD, MEASURED IN BU / ACRE' and it had the same number of entries as the largest set of test::usda::what dataset)
    So a filter by short_desc field can be a potential substitute for all the 12 'what' fields' filter
    The corresponding result of the what filter will be stored in accordance with the naming convention, i.e., 'test::usda::hierarchy1::Corn_grain_yield_BU_acre'
    It is very important that the filteration at level 1 is only done for a single value!

level2: the where
    This filter concerns the location based filters, and would define either a specific location or a logical subset of locations which can be comprehended easily.
    Example1: 'test::usda::hierarchy1::Corn_grain_yield_BU_acre::state' - this dataset would filter the previous 'what' data where the agg_level_desc = 'STATE', because a particular data for all the states' can be viewed easily over a timerange.
    Example2: 'test::usda::hierarchy1::Corn_grain_yield_BU_acre::alabama' - this dataset would filter the previous what data for all the counties of Alabama state.

level3: the when
    This filter would specify a time range and frequency for the final data
    Naming example: 'test::usda::hierarchy1::Corn_grain_yield_BU_acre::state::annual_2012_2019'




Having Datasets at level3 can be optional based on the dataset size and other unforeseen factors, publishing queries directly at level 2 data might turn out to be a better option.