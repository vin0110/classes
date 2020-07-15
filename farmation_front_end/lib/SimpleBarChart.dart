import 'package:charts_flutter/flutter.dart' as charts;
import 'package:farmation_front_end/products/EconomicsAnnualAGLandProduct.dart';
import 'package:farmation_front_end/products/EconomicsAnnualIncomeProduct.dart';
import 'products/Product.dart';
import 'products/StateAnnualCropProduct.dart';
import 'package:flutter/material.dart';
import 'Constants.dart' as constc;
import 'products/StateMonthlyCropProduct.dart';

class SimpleBarChart extends StatelessWidget {
  final Future<List<Product>> crops;
  final String crop;
  final bool animate;
  final int dataIndicator;

  SimpleBarChart(
      {Key key, this.animate, this.crops, this.crop, this.dataIndicator})
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
                      dataIndicator: dataIndicator,
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
  final int dataIndicator;
  final bool animate;

  SimpleBarChartList({this.items, this.animate, this.dataIndicator});
  // List<Tab> myTabs =
  //     getMyTabs(dataIndicator);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: getMyTabs(dataIndicator).length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: getMyTabs(dataIndicator),
          ),
        ),
        body: TabBarView(
          children: getChildren(dataIndicator),
        ),
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<StateAnnualCropProduct, DateTime>>
      _createAnnualCropDataInstance(int flag) {
    return [
      new charts.Series<StateAnnualCropProduct, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (StateAnnualCropProduct sales, _) =>
            new DateTime(sales.year), //.toString(),
        measureFn: (StateAnnualCropProduct sales, _) => flag == 1
            ? sales.areaHarvested
            : flag == 2 ? sales.unitProduction : sales.yieldVal,
        data: items,
      ),
    ];
  }

  getChildren(int dataIndicator) {
    switch (dataIndicator) {
      case constc.STATE_ANNUAL_CROP:
        // return StateAnnualCropProduct.myTabs;
        return createAnnualCropData(animate);
        break;
      case constc.STATE_MONTHLY_CROP:
        return createMonthlyCropData(animate);
        break;
      case constc.ECONOMICS_ANNUAL_AG_LAND:
        return createAnnualAGLandData(animate);
        break;
      case constc.ECONOMICS_ANNUAL_INCOME:
        return createAnnualIncomeData(animate);
        break;
      default:
        print('ERROR 56485');
        return createAnnualCropData(animate);
    }
  }

  List<Tab> getMyTabs(int dataIndicator) {
    switch (dataIndicator) {
      case constc.STATE_ANNUAL_CROP:
        return StateAnnualCropProduct.myTabs;
        break;
      case constc.STATE_MONTHLY_CROP:
        return <Tab>[
          Tab(text: 'Price Received'),
        ];
        break;
      case constc.ECONOMICS_ANNUAL_AG_LAND:
        return <Tab>[
          Tab(text: 'Area'),
        ];
        break;
      case constc.ECONOMICS_ANNUAL_INCOME:
        return <Tab>[
          Tab(text: 'Gain'),
        ];
        break;
      default:
        return StateAnnualCropProduct.myTabs;
    }
  }

  List<charts.Series<StateMonthlyCropProduct, DateTime>>
      _createMonthlyCropDataInstance(int flag) {
    return [
      new charts.Series<StateMonthlyCropProduct, DateTime>(
        id: 'Entry',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (StateMonthlyCropProduct entry, _) =>
            new DateTime.utc(entry.year, entry.begin),
        measureFn: (StateMonthlyCropProduct entry, _) => entry.priceReceived,
        data: items,
      ),
    ];
  }

  List<charts.Series<EconomicsAnnualIncomeProduct, DateTime>>
      _createAnnualIncomeDataInstance(int flag) {
    return [
      new charts.Series<EconomicsAnnualIncomeProduct, DateTime>(
        id: 'Entry',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (EconomicsAnnualIncomeProduct entry, _) =>
            new DateTime.utc(entry.year),
        measureFn: (EconomicsAnnualIncomeProduct entry, _) => entry.gain,
        data: items,
      ),
    ];
  }

  List<charts.Series<EconomicsAnnualAGLandProduct, DateTime>>
      _createAnnualAGLandDataInstance(int flag) {
    return [
      new charts.Series<EconomicsAnnualAGLandProduct, DateTime>(
        id: 'Entry',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (EconomicsAnnualAGLandProduct entry, _) =>
            new DateTime.utc(entry.year),
        measureFn: (EconomicsAnnualAGLandProduct entry, _) => entry.agLand,
        data: items,
      ),
    ];
  }

  createAnnualCropData(bool animate) {
    List<Tab> tabs = getMyTabs(dataIndicator);
    List<Widget> widgets = [];
    for (int i = 1; i <= tabs.length; i++)
      widgets.add(new charts.TimeSeriesChart(
        //).BarChart(
        _createAnnualCropDataInstance(i),
        animate: animate,
      ));

    return widgets;
  }

  createMonthlyCropData(bool animate) {
    List<Tab> tabs = getMyTabs(dataIndicator);
    List<Widget> widgets = [];
    for (int i = 1; i <= tabs.length; i++)
      widgets.add(new charts.TimeSeriesChart(
        //).BarChart(
        _createMonthlyCropDataInstance(i),
        animate: animate,
      ));

    return widgets;
  }

  createAnnualAGLandData(bool animate) {
    List<Tab> tabs = getMyTabs(dataIndicator);
    List<Widget> widgets = [];
    for (int i = 1; i <= tabs.length; i++)
      widgets.add(new charts.TimeSeriesChart(
        //).BarChart(
        _createAnnualAGLandDataInstance(i),
        animate: animate,
      ));

    return widgets;
  }

  createAnnualIncomeData(bool animate) {
    List<Tab> tabs = getMyTabs(dataIndicator);
    List<Widget> widgets = [];
    for (int i = 1; i <= tabs.length; i++)
      widgets.add(new charts.TimeSeriesChart(
        //).BarChart(
        _createAnnualIncomeDataInstance(i),
        animate: animate,
      ));

    return widgets;
  }
}
