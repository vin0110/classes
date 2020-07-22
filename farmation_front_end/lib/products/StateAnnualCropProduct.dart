import 'Product.dart';
import 'package:flutter/material.dart';

class StateAnnualCropProduct extends Product {
  final double areaHarvested;
  final String unitAreaHarvested;
  final double production;
  final String unitProduction;
  final double yieldVal;
  final String unitYield;
  final double areaPlanted;
  final String unitAreaPlanted;
  static final List<Tab> myTabs = <Tab>[
    Tab(text: 'Area Harvested'),
    Tab(text: 'Production'),
    Tab(text: 'Yield'),
    Tab(text: 'Area Harvested / Planted'),
  ];

  StateAnnualCropProduct(
      String crop,
      String state_alpha,
      int year,
      this.areaHarvested,
      this.unitAreaHarvested,
      this.production,
      this.unitProduction,
      this.yieldVal,
      this.unitYield,
      this.areaPlanted,
      this.unitAreaPlanted)
      : super(state_alpha, crop, year);

  @override
  factory StateAnnualCropProduct.fromJson(Map<String, dynamic> data) {
    return StateAnnualCropProduct(
        data['crop'],
        data['state_alpha'],
        data['year'],
        data['area_harvested'],
        data['unit_area_harvested'],
        data['production'],
        data['unit_production'],
        data['yield'],
        data['unit_yield'],
        data['area_planted'] == 0
            ? 0
            : data['area_harvested'] / data['area_planted'],
        data['unit_area_planted']);
  }
}
