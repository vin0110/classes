import 'dart:convert';

import 'package:farmation_front_end/products/Product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StateAnnualCropProduct extends Product {
  final String crop;
  final int year;
  final String state_alpha;
  final double areaHarvested;
  final String unitAreaHarvested;
  final double production;
  final String unitProduction;
  final double yieldVal;
  final String unitYield;
  static final List<Tab> myTabs = <Tab>[
    Tab(text: 'Area Harvested'),
    Tab(text: 'Production'),
    Tab(text: 'Yield'),
  ];

  StateAnnualCropProduct(
      this.crop,
      this.state_alpha,
      this.year,
      this.areaHarvested,
      this.unitAreaHarvested,
      this.production,
      this.unitProduction,
      this.yieldVal,
      this.unitYield);

  @override
  factory StateAnnualCropProduct.fromJson(Map<String, dynamic> data) {
    return StateAnnualCropProduct(
      data['crop'],
      data['state'],
      data['year'],
      data['area_harvested'],
      data['unit_area_harvested'],
      data['production'],
      data['unit_production'],
      data['yield'],
      data['unit_yield'],
    );
  }

  // @override
  // static Future<List<String>> fetchProducts(String state) {}

  static List<StateAnnualCropProduct> parseProducts(String responseBody) {
    // print(responseBody);
    dynamic tmp = json.decode(responseBody);
    final parsed = tmp['fetchqueryResponse']['Results']['Result 1']['Row']
        .cast<Map<String, dynamic>>();
    return parsed
        .map<StateAnnualCropProduct>(
            (jsonobj) => StateAnnualCropProduct.fromJson(jsonobj))
        .toList();
  }

  static Future<List<StateAnnualCropProduct>> getProducts(
      String crop, String state) async {
    final response = await http.post(
        'http://localhost:8002/WsEcl/submit/query/thor/fetchquery/json',
        body: {'submit_type': 'json', 'crop': crop, 'state': state});
    if (response.statusCode == 200) {
      return parseProducts(response.body);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  static Future<List<String>> fetchVariants(String state) async {
    final response = await http.get(
        'http://localhost:8002/WsEcl/submit/query/thor/getcroplist/json?state=' +
            state +
            '&submit_type=json');
    if (response.statusCode == 200) {
      return parseVariants(response.body);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  static List<String> parseVariants(String responseBody) {
    // print(responseBody);
    dynamic tmp = json.decode(responseBody);
    final parsed = tmp['getcroplistResponse']['Results']['Result 1']['Row']
        .cast<dynamic>();
    return parsed.map<String>((jsonobj) => jsonobj['crop'].toString()).toList();
  }
}
