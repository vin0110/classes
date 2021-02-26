import $;

PARALLEL(
        OUTPUT($.processquickstats_function('animals_products'),,
            '~test::usda::quick_stats_animals_products',overwrite),

        OUTPUT($.processquickstats_function('crops'),,
            '~test::usda::quick_stats_crops',overwrite),

        OUTPUT($.processquickstats_function('demographics'),,
            '~test::usda::quick_stats_demographics',overwrite),

        OUTPUT($.processquickstats_function('economics'),,
            '~test::usda::quick_stats_economics',overwrite),

        OUTPUT($.processquickstats_function('environmental'),,
            '~test::usda::quick_stats_environmental',overwrite)
        );
