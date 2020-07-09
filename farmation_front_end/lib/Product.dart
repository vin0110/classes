class Product {
  final String crop;
  final int year;
  final String state_alpha;
  final double areaHarvested;
  final String unitAreaHarvested;
  final double production;
  final String unitProduction;
  final double yieldVal;
  final String unitYield;

  Product(
      this.crop,
      this.state_alpha,
      this.year,
      this.areaHarvested,
      this.unitAreaHarvested,
      this.production,
      this.unitProduction,
      this.yieldVal,
      this.unitYield);

  factory Product.fromJson(Map<String, dynamic> data) {
    return Product(
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

  // static List<Product> getProducts() {
  //   List<Product> items = <Product>[];

  //   items.add(Product(
  //       "Pixel", "Pixel is the most feature-full phone ever", 800, "burr.jpg"));
  //   items.add(Product("Laptop", "Laptop is most productive development tool",
  //       2000, "ham.jpg"));
  //   items.add(Product("Tablet",
  //       "Tablet is the most useful device ever for meeting", 1500, "burr.jpg"));
  //   items.add(Product(
  //       "Pendrive", "Pendrive is useful storage medium", 100, "ham.jpg"));
  //   items.add(Product("Floppy Drive",
  //       "Floppy drive is useful rescue storage medium", 20, "burr.jpg"));
  //   return items;
  // }
}
