import 'dart:async';

import 'package:farmation_front_end/Util.dart';
import 'package:farmation_front_end/VariantsList.dart' hide RaisedButton;
import 'package:farmation_front_end/products/Product.dart';
import 'package:flutter/material.dart';
import 'Constants.dart';
import 'package:farmation_front_end/Endpoint/endpoint.dart';

int tabIndex = 0;

class SimpleBarChart extends StatelessWidget {
  final Future<List<Product>> crops;
  final String crop;
  final bool animate;
  final int dataIndicator;
  final List<List<Product>> allData;
  // final int tabControllerIdx;

  SimpleBarChart(
      {Key key,
      this.animate,
      this.crops,
      this.crop,
      this.dataIndicator,
      int tabControllerIdx,
      this.allData})
      : super(key: key) {
    tabIndex = tabControllerIdx ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, tabIndex),
            ),
            title: Text('Trends for "' + crop.trim() + '"')),
        body: Center(
          child: FutureBuilder<List<Product>>(
            future: crops,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? SimpleBarChartList(
                      key: key,
                      items: [snapshot.data],
                      animate: animate,
                      dataIndicator: dataIndicator,
                      allData: allData,
                      // tabctrlIdx: tabControllerIdx,
                    )
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}

class SimpleBarChartList extends StatefulWidget {
  final List<List<Product>> items;
  final int dataIndicator;
  final bool animate;
  final List<List<Product>> allData;
  // final int tabctrlIdx;

  SimpleBarChartList(
      {this.items, this.animate, this.dataIndicator, Key key, this.allData})
      : super(key: key);

  @override
  _SimpleBarChartList createState() => _SimpleBarChartList();
}

class _SimpleBarChartList extends State<SimpleBarChartList>
    with SingleTickerProviderStateMixin {
  int comparisonMode = COMPARISON_MODE_NONE;

  void addState(String state) async {
    if (comparisonMode == COMPARISON_MODE_WHAT) return;
    List<Product> newData =
        await getProducts(widget.dataIndicator, widget.items[0][0].crop, state);
    if (newData == null || newData.isEmpty) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('No data found')));
      return;
    }
    widget.items.add(newData);
    setState(() {
      comparisonMode = COMPARISON_MODE_WHERE;
    });
  }

  void addCrop(String state, newCrop, String county) async {
    if (comparisonMode == COMPARISON_MODE_WHERE) return;
    List<Product> newData =
        await getProducts(widget.dataIndicator, newCrop, state);
    county == null
        ? widget.items.add(newData)
        : widget.items
            .add(newData.where((element) => element.county == county).toList());
    setState(() {
      comparisonMode = COMPARISON_MODE_WHAT;
    });
  }

  void addCounty(String county) async {
    if (comparisonMode == COMPARISON_MODE_WHAT) return;
    widget.items.add(
        widget.allData.firstWhere((element) => element.first.county == county));
    setState(() {
      comparisonMode = COMPARISON_MODE_WHERE;
    });
  }

  final stateController = TextEditingController();
  ScrollController ctrl;
  TabController tabctrl;
  @override
  void initState() {
    super.initState();
    ctrl = ScrollController();
    tabctrl =
            // widget.tabctrl == null    ?
            TabController(
                length: getMyTabs(widget.dataIndicator).length,
                vsync: this,
                initialIndex: tabIndex)
        // : widget.tabctrl
        ;
  }

  @override
  void dispose() {
    // tabctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        TabBar(
          key: widget.key,
          controller: tabctrl,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.red,
          tabs: getMyTabs(widget.dataIndicator),
          onTap: (num) {
            print('tab changed to ' + num.toString());
            tabIndex = num;
            tabctrl.index = num;
          },
        ),
        // ),
        SizedBox(
            height: MediaQuery.of(context).size.height * 3 / 4,
            child: TabBarView(
              key: widget.key,
              controller: tabctrl,
              children: getChildren(widget.dataIndicator, widget.animate,
                  widget.items, comparisonMode),
            )),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                widget.dataIndicator == EXP
                    ? null
                    : SizedBox(
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
                  onPressed: comparisonMode != COMPARISON_MODE_WHAT
                      ? () {
                          widget.dataIndicator == EXP
                              ? showCountiesAndUpdateGraph(context)
                              : addState(stateController.text);
                        }
                      : null,
                  child: Text('Compare with other locations'),
                ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                //   child:
                RaisedButton(
                  onPressed: comparisonMode != COMPARISON_MODE_WHERE
                      ? () => showVariantsAndUpdateGraph(context)
                      : null,
                  child: Text('Compare with other crops'),
                ),
                // ),
              ].where((t) => t != null).toList(),
            )),
      ],
    );
  }

  Future showCountiesAndUpdateGraph(BuildContext context) async {
    if (comparisonMode == COMPARISON_MODE_WHERE) return;

    List<String> countyList =
        widget.allData.map((e) => e.first.county).toList();
    String newCounty = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select other county to compare with'),
            children: <Widget>[VariantsList(crops: countyList, isPopup: true)],
          );
        });
    addCounty(newCounty);
    return;
  }

  Future showVariantsAndUpdateGraph(BuildContext context) async {
    if (comparisonMode == COMPARISON_MODE_WHERE) return;

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
                  // Error due to wrong user input not happening here so not handling
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
    addCrop(widget.items[0][0].state_alpha, newCrop, widget.items[0][0].county);
    return;
  }
}
