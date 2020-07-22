library product;

export 'package:farmation_front_end/products/EconomicsAnnualAGLandProduct.dart';
export 'package:farmation_front_end/products/StateAnnualCropProduct.dart';
export 'package:farmation_front_end/products/EconomicsAnnualIncomeProduct.dart';
export 'package:farmation_front_end/products/StateMonthlyCropProduct.dart';

abstract class Product {
  final String state_alpha;
  final String crop;
  final int year;
  Product(this.state_alpha, this.crop, this.year);
  // ignore: empty_constructor_bodies,missing_return
  // Product.fromJson(Map<String, dynamic> data);
  // Product();

  // static Future<List<String>> fetchProducts(String state) {}
  // static Future<List<Product>> getProducts(){}
}
