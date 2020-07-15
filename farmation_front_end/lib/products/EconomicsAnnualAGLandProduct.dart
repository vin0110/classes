import 'dart:convert';

import 'Product.dart';
import 'package:http/http.dart' as http;

class EconomicsAnnualAGLandProduct implements Product {
  final String crop;
  final int year;
  final String state_alpha;
  final double agLand;
  final String unitagLand;

  EconomicsAnnualAGLandProduct(
    this.crop,
    this.state_alpha,
    this.year,
    this.agLand,
    this.unitagLand,
  );
  @override
  static Future<List<String>> fetchProducts(String state) {}

  factory EconomicsAnnualAGLandProduct.fromJson(Map<String, dynamic> data) {
    return EconomicsAnnualAGLandProduct(
      data['crop'],
      data['state'],
      data['year'],
      data['area'],
      data['unit_area'],
    );
  }
  static List<EconomicsAnnualAGLandProduct> parseProducts(String responseBody) {
    // print(responseBody);
    dynamic tmp = json.decode(responseBody);
    final parsed = tmp['economics_getaglandResponse']['Results']['Result 1']
            ['Row']
        .cast<Map<String, dynamic>>();
    return parsed
        .map<EconomicsAnnualAGLandProduct>(
            (jsonobj) => EconomicsAnnualAGLandProduct.fromJson(jsonobj))
        .toList();
  }

  static Future<List<EconomicsAnnualAGLandProduct>> getProducts(
      String crop, String state) async {
    final response = await http.post(
        'http://localhost:8002/WsEcl/submit/query/thor/economics_getagland/json',
        body: {'submit_type': 'json', 'crop': crop, 'state': state});
    if (response.statusCode == 200) {
      return parseProducts(response.body);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  static Future<List<String>> fetchVariants(String state) async {
    final response = await http.post(
        'http://localhost:8002/WsEcl/submit/query/thor/economics_getaglandvariantsbystate/json',
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
    final parsed = tmp['economics_getaglandvariantsbystateResponse']['Results']
            ['Result 1']['Row']
        .cast<dynamic>();
    return parsed.map<String>((jsonobj) => jsonobj['crop'].toString()).toList();
  }
}
