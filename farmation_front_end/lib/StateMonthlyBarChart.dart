import 'package:charts_flutter/flutter.dart' as charts;
import 'products/StateMonthlyCropProduct.dart';
import 'package:flutter/material.dart';

class StateMonthlyBarChart extends StatelessWidget {
  final Future<List<StateMonthlyCropProduct>> crops;
  final String crop;
  final bool animate;

  StateMonthlyBarChart({Key key, this.animate, this.crops, this.crop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Trends for "' + crop + '"')),
        body: Center(
          child: FutureBuilder<List<StateMonthlyCropProduct>>(
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
  final List<StateMonthlyCropProduct> items;

  final bool animate;

  SimpleBarChartList({this.items, this.animate});
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Price Received'),
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
          ],
        ),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<StateMonthlyCropProduct, String>> _createSampleData() {
    return [
      new charts.Series<StateMonthlyCropProduct, String>(
        id: 'Entry',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (StateMonthlyCropProduct entry, _) =>
            new DateTime.utc(entry.year, entry.begin).toString(),
        measureFn: (StateMonthlyCropProduct entry, _) => entry.priceReceived,
        data: items,
      ),
    ];
  }
}
