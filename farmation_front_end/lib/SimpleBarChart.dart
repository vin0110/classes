import 'package:charts_flutter/flutter.dart' as charts;
import 'Product.dart';
import 'package:flutter/material.dart';

class SimpleBarChart extends StatelessWidget {
  final Future<List<Product>> crops;
  final String crop;
  final bool animate;

  SimpleBarChart({Key key, this.animate, this.crops, this.crop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Trends for "' + crop + '"')),
        body: Center(
          child: FutureBuilder<List<Product>>(
            future: crops,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? SimpleBarChartList(
                      items: snapshot.data,
                      animate: animate,
                    )
                  // return the ListView widget :
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}

class SimpleBarChartList extends StatelessWidget {
  final List<Product> items;

  final bool animate;

  SimpleBarChartList({this.items, this.animate});
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Area Harvested'),
    Tab(text: 'Production'),
    Tab(text: 'Yield'),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: myTabs,
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            new charts.BarChart(
              _createSampleData(),
              animate: animate,
            ),
            new charts.BarChart(
              _createSampleData1(),
              animate: animate,
            ),
            new charts.BarChart(
              _createSampleData2(),
              animate: animate,
            ),
          ],
        ),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<Product, String>> _createSampleData() {
    return [
      new charts.Series<Product, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Product sales, _) => sales.year.toString(),
        measureFn: (Product sales, _) => sales.areaHarvested,
        data: items,
      ),
    ];
  }

  List<charts.Series<Product, String>> _createSampleData1() {
    return [
      new charts.Series<Product, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (Product sales, _) => sales.year.toString(),
        measureFn: (Product sales, _) => sales.production,
        data: items,
      ),
    ];
  }

  List<charts.Series<Product, String>> _createSampleData2() {
    return [
      new charts.Series<Product, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (Product sales, _) => sales.year.toString(),
        measureFn: (Product sales, _) => sales.yieldVal,
        data: items,
      ),
    ];
  }
}
