library product;

export 'package:farmation_front_end/products/EconomicsAnnualAGLandProduct.dart';
export 'package:farmation_front_end/products/StateAnnualCropProduct.dart';
export 'package:farmation_front_end/products/EconomicsAnnualIncomeProduct.dart';
export 'package:farmation_front_end/products/StateMonthlyCropProduct.dart';

abstract class Product {
  final String state_alpha;
  final String crop;
  final int year;
  final String county;
  Product(this.state_alpha, this.crop, this.year, {this.county});
}
