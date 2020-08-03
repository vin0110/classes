import 'package:charts_flutter/flutter.dart' as charts;
import 'package:farmation_front_end/Constants.dart';
import 'package:farmation_front_end/SimpleBarChart.dart';
import 'package:farmation_front_end/products/Product.dart';
import 'package:flutter/material.dart';

getChildren(int dataIndicator, bool animate, List<List<Product>> items,
    int comparisonMode) {
  switch (dataIndicator) {
    case STATE_ANNUAL_CROP:
      return createAnnualCropData(
          animate, items, dataIndicator, comparisonMode);
      break;
    case STATE_MONTHLY_CROP:
      return createMonthlyCropData(
          animate, items, dataIndicator, comparisonMode);
      break;
    case ECONOMICS_ANNUAL_AG_LAND:
      return createAnnualAGLandData(
          animate, items, dataIndicator, comparisonMode);
      break;
    case ECONOMICS_ANNUAL_INCOME:
      return createAnnualIncomeData(
          animate, items, dataIndicator, comparisonMode);
      break;
    case EXP:
      return createAnnualCountyData(
          animate, items, dataIndicator, comparisonMode);
      break;
    default:
      print('ERROR 56485');
      return createAnnualCropData(
          animate, items, dataIndicator, comparisonMode);
  }
}

List<Tab> getMyTabs(int dataIndicator) {
  switch (dataIndicator) {
    case STATE_ANNUAL_CROP:
      return StateAnnualCropProduct.myTabs;
      break;
    case STATE_MONTHLY_CROP:
      return StateMonthlyCropProduct.myTabs;
      break;
    case ECONOMICS_ANNUAL_AG_LAND:
      return EconomicsAnnualAGLandProduct.myTabs;
      break;
    case ECONOMICS_ANNUAL_INCOME:
      return EconomicsAnnualIncomeProduct.myTabs;
      break;
    case EXP:
      return StateAnnualCropProduct.myTabs;
      break;
    default:
      return StateAnnualCropProduct.myTabs;
  }
}

/// Create one series with sample hard coded data.
List<charts.Series<StateAnnualCropProduct, DateTime>>
    _createAnnualCropDataInstance(
        int flag, List<List<Product>> items, int comparisonMode) {
  List<charts.Series<StateAnnualCropProduct, DateTime>> retVal = [];
  for (var stateData in items) {
    charts.Series<StateAnnualCropProduct, DateTime> data =
        new charts.Series<StateAnnualCropProduct, DateTime>(
      id: comparisonMode != COMPARISON_MODE_CROP
          ? stateData[0].state_alpha
          : stateData[0].crop.trim(),
      // colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (StateAnnualCropProduct sales, _) =>
          new DateTime(sales.year), //.toString(),
      measureFn: (StateAnnualCropProduct sales, _) => flag == 1
          ? sales.areaHarvested
          : flag == 2
              ? sales.production
              : flag == 3 ? sales.yieldVal : sales.areaPlanted,
      data: stateData,
    );

    retVal.add(data);
  }
  return retVal;
}

List<charts.Series<StateMonthlyCropProduct, DateTime>>
    _createMonthlyCropDataInstance(
        int flag, List<List<Product>> items, int comparisonMode) {
  List<charts.Series<StateMonthlyCropProduct, DateTime>> retVal = [];
  for (var stateData in items) {
    charts.Series<StateMonthlyCropProduct, DateTime> data =
        new charts.Series<StateMonthlyCropProduct, DateTime>(
      id: comparisonMode != COMPARISON_MODE_CROP
          ? stateData[0].state_alpha
          : stateData[0].crop.trim(),
      // colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (StateMonthlyCropProduct entry, _) =>
          new DateTime.utc(entry.year, entry.begin),
      measureFn: (StateMonthlyCropProduct entry, _) => entry.priceReceived,
      data: stateData,
    );

    retVal.add(data);
  }
  return retVal;
}

List<charts.Series<EconomicsAnnualIncomeProduct, DateTime>>
    _createAnnualIncomeDataInstance(
        int flag, List<List<Product>> items, int comparisonMode) {
  List<charts.Series<EconomicsAnnualIncomeProduct, DateTime>> retVal = [];
  for (var stateData in items) {
    charts.Series<EconomicsAnnualIncomeProduct, DateTime> data =
        new charts.Series<EconomicsAnnualIncomeProduct, DateTime>(
      id: comparisonMode != COMPARISON_MODE_CROP
          ? stateData[0].state_alpha
          : stateData[0].crop.trim(),
      // colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (EconomicsAnnualIncomeProduct entry, _) =>
          new DateTime.utc(entry.year),
      measureFn: (EconomicsAnnualIncomeProduct entry, _) => entry.gain,
      data: stateData,
    );

    retVal.add(data);
  }
  return retVal;
}

List<charts.Series<EconomicsAnnualAGLandProduct, DateTime>>
    _createAnnualAGLandDataInstance(
        int flag, List<List<Product>> items, int comparisonMode) {
  List<charts.Series<EconomicsAnnualAGLandProduct, DateTime>> retVal = [];
  for (var stateData in items) {
    charts.Series<EconomicsAnnualAGLandProduct, DateTime> data =
        new charts.Series<EconomicsAnnualAGLandProduct, DateTime>(
      id: comparisonMode != COMPARISON_MODE_CROP
          ? stateData[0].state_alpha
          : stateData[0].crop.trim(),
      // colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (EconomicsAnnualAGLandProduct entry, _) =>
          new DateTime.utc(entry.year),
      measureFn: (EconomicsAnnualAGLandProduct entry, _) => entry.agLand,
      data: stateData,
    );

    retVal.add(data);
  }
  return retVal;
}

List<charts.Series<StateAnnualCropProduct, DateTime>>
    _createAnnualCountyDataInstance(
        int flag, List<List<Product>> items, int comparisonMode) {
  List<charts.Series<StateAnnualCropProduct, DateTime>> retVal = [];
  for (var stateData in items) {
    charts.Series<StateAnnualCropProduct, DateTime> data =
        new charts.Series<StateAnnualCropProduct, DateTime>(
      id: comparisonMode != COMPARISON_MODE_CROP
          ? stateData[0].county
          : stateData[0].crop.trim(),
      // colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (StateAnnualCropProduct sales, _) =>
          new DateTime(sales.year), //.toString(),
      measureFn: (StateAnnualCropProduct sales, _) => flag == 1
          ? sales.areaHarvested
          : flag == 2
              ? sales.production
              : flag == 3 ? sales.yieldVal : sales.areaPlanted,
      data: stateData,
    );

    retVal.add(data);
  }
  return retVal;
}

createAnnualCropData(bool animate, List<List<Product>> items, int dataIndicator,
    int comparisonMode) {
  List<Tab> tabs = getMyTabs(dataIndicator);
  List<Widget> widgets = [];
  for (int i = 1; i <= tabs.length; i++)
    widgets.add(new charts.TimeSeriesChart(
      //).BarChart(
      _createAnnualCropDataInstance(i, items, comparisonMode),
      animate: animate,
      behaviors: [
        new charts.SeriesLegend(
            desiredMaxColumns: comparisonMode != COMPARISON_MODE_CROP ? 5 : 2)
      ],
    ));

  return widgets;
}

createMonthlyCropData(bool animate, List<List<Product>> items,
    int dataIndicator, int comparisonMode) {
  List<Tab> tabs = getMyTabs(dataIndicator);
  List<Widget> widgets = [];
  for (int i = 1; i <= tabs.length; i++)
    widgets.add(new charts.TimeSeriesChart(
      //).BarChart(
      _createMonthlyCropDataInstance(i, items, comparisonMode),
      animate: animate,
      behaviors: [new charts.SeriesLegend()],
    ));

  return widgets;
}

createAnnualAGLandData(bool animate, List<List<Product>> items,
    int dataIndicator, int comparisonMode) {
  List<Tab> tabs = getMyTabs(dataIndicator);
  List<Widget> widgets = [];
  for (int i = 1; i <= tabs.length; i++)
    widgets.add(new charts.TimeSeriesChart(
      //).BarChart(
      _createAnnualAGLandDataInstance(i, items, comparisonMode),
      animate: animate,
      behaviors: [new charts.SeriesLegend()],
    ));

  return widgets;
}

createAnnualIncomeData(bool animate, List<List<Product>> items,
    int dataIndicator, int comparisonMode) {
  List<Tab> tabs = getMyTabs(dataIndicator);
  List<Widget> widgets = [];
  for (int i = 1; i <= tabs.length; i++)
    widgets.add(new charts.TimeSeriesChart(
      //).BarChart(
      _createAnnualIncomeDataInstance(i, items, comparisonMode),
      animate: animate,
      behaviors: [new charts.SeriesLegend()],
    ));

  return widgets;
}

createAnnualCountyDataForGrid(
    bool animate,
    List<List<Product>> items,
    int dataIndicator,
    int comparisonMode,
    BuildContext context,
    TabController tabctrl,
    Key key) {
  List<Tab> tabs = getMyTabs(dataIndicator);
  List<Widget> widgets = [];
  for (int i = 1; i <= tabs.length; i++) {
    List<Widget> cells = [];
    items.forEach((element) {
      cells.add(InkWell(
        onTap: () {
          return Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SimpleBarChart(
                  key: key,
                  dataIndicator: dataIndicator,
                  crop: element[0].crop,
                  animate: true,
                  crops: Future<List<Product>>.value(element),
                  tabController: tabctrl,
                ),
              ));
        },
        child: IgnorePointer(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Expanded(
                  flex: 3,
                  child: (charts.TimeSeriesChart(
                    _createAnnualCountyDataInstance(
                        i, [element], comparisonMode),
                    animate: false,
                  ))),
              Expanded(child: Text(element.first ?? element.first.county))
            ])),
      ));
    });
    GridView grid = GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10, childAspectRatio: 1),
      itemBuilder: (context, index) => cells[index],
      itemCount: cells.length,
    );

    widgets.add(grid);
  }
  return widgets;
}

createAnnualCountyData(bool animate, List<List<Product>> items,
    int dataIndicator, int comparisonMode) {
  List<Tab> tabs = getMyTabs(dataIndicator);
  List<Widget> widgets = [];
  for (int i = 1; i <= tabs.length; i++)
    widgets.add(new charts.TimeSeriesChart(
      //).BarChart(
      _createAnnualCountyDataInstance(i, items, comparisonMode),
      animate: animate,
      behaviors: [
        new charts.SeriesLegend(
            desiredMaxColumns: comparisonMode != COMPARISON_MODE_CROP ? 5 : 2)
      ],
    ));

  return widgets;
}
