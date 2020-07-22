import 'package:farmation_front_end/products/Product.dart';
import 'package:flutter/material.dart';

class StateMonthlyCropProduct extends Product {
  final int begin;
  final int end;
  final double priceReceived;
  final String unitPriceRecceived;
  static final List<Tab> myTabs = <Tab>[
    Tab(text: 'Price Received'),
  ];

  StateMonthlyCropProduct(String crop, String state_alpha, int year,
      this.priceReceived, this.unitPriceRecceived, this.begin, this.end)
      : super(state_alpha, crop, year);

  factory StateMonthlyCropProduct.fromJson(Map<String, dynamic> data) {
    return StateMonthlyCropProduct(
        data['crop'],
        data['state_alpha'],
        data['year'],
        data['price_received'],
        data['unit_price_received'],
        data['begin_code'],
        data['end_code']);
  }
}
