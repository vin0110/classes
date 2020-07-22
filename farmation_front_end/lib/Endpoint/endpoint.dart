import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:farmation_front_end/products/Product.dart';
import 'package:farmation_front_end/Constants.dart';

List<Product> parseProducts(int dataIndicator, String responseBody) {
  // print(responseBody);
  dynamic tmp = json.decode(responseBody);
  final parsed = tmp['${QUERIES[dataIndicator]}Response']['Results']['Result 1']
          ['Row']
      .cast<Map<String, dynamic>>();
  switch (dataIndicator) {
    case STATE_ANNUAL_CROP:
      return parsed
          .map<StateAnnualCropProduct>(
              (jsonobj) => StateAnnualCropProduct.fromJson(jsonobj))
          .toList();
    case STATE_MONTHLY_CROP:
      return parsed
          .map<StateMonthlyCropProduct>(
              (jsonobj) => StateMonthlyCropProduct.fromJson(jsonobj))
          .toList();
    case ECONOMICS_ANNUAL_INCOME:
      return parsed
          .map<EconomicsAnnualIncomeProduct>(
              (jsonobj) => EconomicsAnnualIncomeProduct.fromJson(jsonobj))
          .toList();
    case ECONOMICS_ANNUAL_AG_LAND:
      return parsed
          .map<EconomicsAnnualAGLandProduct>(
              (jsonobj) => EconomicsAnnualAGLandProduct.fromJson(jsonobj))
          .toList();
  }
}

Future<List<Product>> getProducts(
    int dataIndicator, String crop, String state) async {
  final response = await http.post(
      '$ENDPOINT_URL${QUERIES[dataIndicator]}/json',
      body: {'submit_type': 'json', 'crop': crop, 'state': state});
  if (response.statusCode == 200) {
    return parseProducts(dataIndicator, response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

Future<List<String>> fetchVariants(int dataIndicator, String state) async {
  final response = await http.get(
      '$ENDPOINT_URL${VARIANTS[dataIndicator]}/json?state=' +
          state +
          '&submit_type=json');
  if (response.statusCode == 200) {
    return parseVariants(dataIndicator, response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

List<String> parseVariants(int dataIndicator, String responseBody) {
  // print(responseBody);
  dynamic tmp = json.decode(responseBody);
  final parsed = tmp['${VARIANTS[dataIndicator]}Response']['Results']
          ['Result 1']['Row']
      .cast<dynamic>();
  return parsed.map<String>((jsonobj) => jsonobj['crop'].toString()).toList();
}
