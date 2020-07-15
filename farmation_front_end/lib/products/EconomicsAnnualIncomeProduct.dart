import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Product.dart';

class EconomicsAnnualIncomeProduct implements Product {
  final String crop;
  final int year;
  final String state_alpha;
  final double gain;
  final String unitGain;

  EconomicsAnnualIncomeProduct(
    this.crop,
    this.state_alpha,
    this.year,
    this.gain,
    this.unitGain,
  );

  factory EconomicsAnnualIncomeProduct.fromJson(Map<String, dynamic> data) {
    return EconomicsAnnualIncomeProduct(
      data['crop'],
      data['state'],
      data['year'],
      data['gain'],
      data['unit_gain'],
    );
  }
  static List<EconomicsAnnualIncomeProduct> parseProducts(String responseBody) {
    // print(responseBody);
    dynamic tmp = json.decode(responseBody);
    final parsed = tmp['economics_getincomeResponse']['Results']['Result 1']
            ['Row']
        .cast<Map<String, dynamic>>();
    print(parsed);
    return parsed
        .map<EconomicsAnnualIncomeProduct>(
            (jsonobj) => EconomicsAnnualIncomeProduct.fromJson(jsonobj))
        .toList();
  }

  static Future<List<EconomicsAnnualIncomeProduct>> getProducts(
      String crop, String state) async {
    final response = await http.post(
        'http://localhost:8002/WsEcl/submit/query/thor/economics_getincome/json',
        body: {'submit_type': 'json', 'crop': crop, 'state': state});
    if (response.statusCode == 200) {
      return parseProducts(response.body);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  static Future<List<String>> fetchVariants(String state) async {
    final response = await http.post(
        'http://localhost:8002/WsEcl/submit/query/thor/economics_getincomevariantsbystate/json',
        body: {'state': state, 'submit_type': 'json'});
    if (response.statusCode == 200) {
      return parseVariants(response.body);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  static List<String> parseVariants(String responseBody) {
    // print(responseBody);
    dynamic tmp = json.decode(responseBody);
    final parsed = tmp['economics_getincomevariantsbystateResponse']['Results']
            ['Result 1']['Row']
        .cast<dynamic>();
    return parsed.map<String>((jsonobj) => jsonobj['crop'].toString()).toList();
  }
}
