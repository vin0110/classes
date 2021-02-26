import 'package:flutter/material.dart';

import 'Product.dart';

class EconomicsAnnualAGLandProduct extends Product {
  final double agLand;
  final String unitagLand;
  static final List<Tab> myTabs = <Tab>[
    Tab(text: 'Area'),
  ];

  EconomicsAnnualAGLandProduct(
    String crop,
    String state_alpha,
    int year,
    this.agLand,
    this.unitagLand,
  ) : super(state_alpha, crop, year);

  factory EconomicsAnnualAGLandProduct.fromJson(Map<String, dynamic> data) {
    return EconomicsAnnualAGLandProduct(
      data['crop'],
      data['state_alpha'],
      data['year'],
      data['area'],
      data['unit_area'],
    );
  }
}
