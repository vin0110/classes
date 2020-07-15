import 'dart:convert';

import 'package:http/http.dart' as http;

import 'Product.dart';

class StateMonthlyCropProduct implements Product {
  final String crop;
  final int year;
  final int begin;
  final int end;
  final String state_alpha;
  final double priceReceived;
  final String unitPriceRecceived;

  StateMonthlyCropProduct(this.crop, this.state_alpha, this.year,
      this.priceReceived, this.unitPriceRecceived, this.begin, this.end);

  factory StateMonthlyCropProduct.fromJson(Map<String, dynamic> data) {
    return StateMonthlyCropProduct(
        data['crop'],
        data['state'],
        data['year'],
        data['price_received'],
        data['unit_price_received'],
        data['begin_code'],
        data['end_code']);
  }

  static List<StateMonthlyCropProduct> parseStateMonthlyCropProducts(
      String responseBody) {
    // print(responseBody);
    dynamic tmp = json.decode(responseBody);
    final parsed = tmp['state_monthlyResponse']['Results']['Result 1']['Row']
        .cast<Map<String, dynamic>>();
    return parsed
        .map<StateMonthlyCropProduct>(
            (jsonobj) => StateMonthlyCropProduct.fromJson(jsonobj))
        .toList();
  }

  static Future<List<StateMonthlyCropProduct>> getProducts(
      String crop, String state) async {
    final response = await http.post(
        'http://localhost:8002/WsEcl/submit/query/thor/state_monthly/json',
        body: {'submit_type': 'json', 'crop': crop, 'state': state});
    if (response.statusCode == 200) {
      return parseStateMonthlyCropProducts(response.body);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  static Future<List<String>> fetchVariants(String state) async {
    final response = await http.get(
        'http://localhost:8002/WsEcl/submit/query/thor/state_monthly_crop_list/json?state=' +
            state +
            '&submit_type=json');
    if (response.statusCode == 200) {
      return parseStateMonthlyCropResponse(response.body);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  static List<String> parseStateMonthlyCropResponse(String responseBody) {
    // print(responseBody);
    dynamic tmp = json.decode(responseBody);
    final parsed = tmp['state_monthly_crop_listResponse']['Results']['Result 1']
            ['Row']
        .cast<dynamic>();
    return parsed.map<String>((jsonobj) => jsonobj['crop'].toString()).toList();
  }
}
