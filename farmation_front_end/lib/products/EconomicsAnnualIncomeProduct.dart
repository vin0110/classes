import 'package:flutter/material.dart';

import 'Product.dart';

class EconomicsAnnualIncomeProduct extends Product {
  final double gain;
  final String unitGain;
  static final List<Tab> myTabs = <Tab>[
    Tab(text: 'Gain'),
  ];

  EconomicsAnnualIncomeProduct(
    String crop,
    String state_alpha,
    int year,
    this.gain,
    this.unitGain,
  ) : super(state_alpha, crop, year);

  factory EconomicsAnnualIncomeProduct.fromJson(Map<String, dynamic> data) {
    return EconomicsAnnualIncomeProduct(
      data['crop'],
      data['state_alpha'],
      data['year'],
      data['gain'],
      data['unit_gain'],
    );
  }
}
