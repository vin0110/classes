import 'package:charts_flutter/flutter.dart' as charts;
import 'package:farmation_front_end/VariantsList.dart' hide RaisedButton;
import 'package:farmation_front_end/products/Product.dart';
import 'package:flutter/material.dart';
import 'Constants.dart';
import 'package:farmation_front_end/Endpoint/endpoint.dart';

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
        appBar: AppBar(title: Text('Trends for "' + crop.trim() + '"')),
        body: Center(
          child: FutureBuilder<List<Product>>(
            future: crops,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? SimpleBarChartList(
                      items: [snapshot.data],
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

class SimpleBarChartList extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final List<List<Product>> items;
  final int dataIndicator;
  final bool animate;

  SimpleBarChartList({this.items, this.animate, this.dataIndicator});

  @override
  _SimpleBarChartList createState() => _SimpleBarChartList();
}

class _SimpleBarChartList extends State<SimpleBarChartList> {
  int comparisonMode = COMPARISON_MODE_NONE;
  void addState(String state) async {
    if (comparisonMode == COMPARISON_MODE_CROP) return;
    List<Product> newData =
        await getProducts(widget.dataIndicator, widget.items[0][0].crop, state);
    widget.items.add(newData);
    setState(() {
      comparisonMode = COMPARISON_MODE_STATE;
      print('refreshed');
    });
  }

  void addCrop(String state, newCrop) async {
    if (comparisonMode == COMPARISON_MODE_STATE) return;
    List<Product> newData =
        await getProducts(widget.dataIndicator, newCrop, state);
    widget.items.add(newData);
    setState(() {
      comparisonMode = COMPARISON_MODE_CROP;
      print('refreshed');
    });
  }

  final stateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: getMyTabs(widget.dataIndicator).length,
      child: ListView(
        children: <Widget>[
          // appBar: AppBar(
          TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.red,
            tabs: getMyTabs(widget.dataIndicator),
          ),
          // ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 3 / 4,
              child: TabBarView(
                children: getChildren(widget.dataIndicator),
              )),
          Row(
            children: <Widget>[
              SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter state to compare with',
                    ),
                    controller: stateController,
                  )),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 16.0),
              //   child:
              RaisedButton(
                onPressed: comparisonMode != COMPARISON_MODE_CROP
                    ? () {
                        addState(stateController.text);
                      }
                    : null,
                child: Text('Compare'),
              ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 16.0),
              //   child:
              RaisedButton(
                onPressed: comparisonMode != COMPARISON_MODE_STATE
                    ? () => showVariantsAndUpdateGraph(context)
                    : null,
                child: Text('Compare with other crops'),
              ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Future showVariantsAndUpdateGraph(BuildContext context) async {
    if (comparisonMode == COMPARISON_MODE_STATE) return;

    Future<List<String>> data =
        fetchVariants(widget.dataIndicator, widget.items[0][0].state_alpha);
    String newCrop = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select other variant to compare with'),
            children: <Widget>[
              FutureBuilder<List<String>>(
                future: data,
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? VariantsList(
                          crops: snapshot.data,
                          state: widget.items[0][0].state_alpha,
                          dataIndicator: widget.dataIndicator,
                          isPopup: true)
                      // return the ListView widget :
                      : Center(child: CircularProgressIndicator());
                },
              )
            ],
          );
        });
    addCrop(widget.items[0][0].state_alpha, newCrop);
    return;
  }

  getChildren(int dataIndicator) {
    switch (dataIndicator) {
      case STATE_ANNUAL_CROP:
        return createAnnualCropData(widget.animate);
        break;
      case STATE_MONTHLY_CROP:
        return createMonthlyCropData(widget.animate);
        break;
      case ECONOMICS_ANNUAL_AG_LAND:
        return createAnnualAGLandData(widget.animate);
        break;
      case ECONOMICS_ANNUAL_INCOME:
        return createAnnualIncomeData(widget.animate);
        break;
      default:
        print('ERROR 56485');
        return createAnnualCropData(widget.animate);
    }
  }

  // Future<List<Product>> getNewData(Product item, String state) async {
  //   switch (widget.dataIndicator) {
  //     case constc.STATE_ANNUAL_CROP:
  //       return await getProducts(widget.dataIndicator, item.crop, state);
  //       break;
  //     case constc.STATE_MONTHLY_CROP:
  //       return await getProducts(widget.dataIndicator,
  //           ((item) as StateMonthlyCropProduct).crop, state);
  //       break;
  //     case constc.ECONOMICS_ANNUAL_AG_LAND:
  //       return await getProducts(widget.dataIndicator,
  //           ((item) as EconomicsAnnualAGLandProduct).crop, state);
  //       break;
  //     case constc.ECONOMICS_ANNUAL_INCOME:
  //       return await getProducts(widget.dataIndicator,
  //           ((item) as EconomicsAnnualIncomeProduct).crop, state);
  //       break;
  //     default:
  //       return await getProducts(widget.dataIndicator,
  //           ((item) as StateAnnualCropProduct).crop, state);
  //   }
  // }

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
      default:
        return StateAnnualCropProduct.myTabs;
    }
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<StateAnnualCropProduct, DateTime>>
      _createAnnualCropDataInstance(int flag) {
    List<charts.Series<StateAnnualCropProduct, DateTime>> retVal = [];
    for (var stateData in widget.items) {
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
      _createMonthlyCropDataInstance(int flag) {
    List<charts.Series<StateMonthlyCropProduct, DateTime>> retVal = [];
    for (var stateData in widget.items) {
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
      _createAnnualIncomeDataInstance(int flag) {
    List<charts.Series<EconomicsAnnualIncomeProduct, DateTime>> retVal = [];
    for (var stateData in widget.items) {
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
      _createAnnualAGLandDataInstance(int flag) {
    List<charts.Series<EconomicsAnnualAGLandProduct, DateTime>> retVal = [];
    for (var stateData in widget.items) {
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

  createAnnualCropData(bool animate) {
    List<Tab> tabs = getMyTabs(widget.dataIndicator);
    List<Widget> widgets = [];
    for (int i = 1; i <= tabs.length; i++)
      widgets.add(new charts.TimeSeriesChart(
        //).BarChart(
        _createAnnualCropDataInstance(i),
        animate: animate,
        behaviors: [
          new charts.SeriesLegend(
              desiredMaxColumns: comparisonMode != COMPARISON_MODE_CROP ? 5 : 2)
        ],
      ));

    return widgets;
  }

  createMonthlyCropData(bool animate) {
    List<Tab> tabs = getMyTabs(widget.dataIndicator);
    List<Widget> widgets = [];
    for (int i = 1; i <= tabs.length; i++)
      widgets.add(new charts.TimeSeriesChart(
        //).BarChart(
        _createMonthlyCropDataInstance(i),
        animate: animate,
        behaviors: [new charts.SeriesLegend()],
      ));

    return widgets;
  }

  createAnnualAGLandData(bool animate) {
    List<Tab> tabs = getMyTabs(widget.dataIndicator);
    List<Widget> widgets = [];
    for (int i = 1; i <= tabs.length; i++)
      widgets.add(new charts.TimeSeriesChart(
        //).BarChart(
        _createAnnualAGLandDataInstance(i),
        animate: animate,
        behaviors: [new charts.SeriesLegend()],
      ));

    return widgets;
  }

  createAnnualIncomeData(bool animate) {
    List<Tab> tabs = getMyTabs(widget.dataIndicator);
    List<Widget> widgets = [];
    for (int i = 1; i <= tabs.length; i++)
      widgets.add(new charts.TimeSeriesChart(
        //).BarChart(
        _createAnnualIncomeDataInstance(i),
        animate: animate,
        behaviors: [new charts.SeriesLegend()],
      ));

    return widgets;
  }
}
