import 'package:farmation_front_end/Util.dart';
import 'package:farmation_front_end/products/Product.dart';
import 'package:flutter/material.dart';
import 'package:farmation_front_end/Constants.dart';

class GridGraphs extends StatefulWidget {
  final Future<List<Product>> items;
  final int dataIndicator;
  final bool animate;

  GridGraphs({Key key, this.items, this.animate, this.dataIndicator})
      : super(key: key) {}

  @override
  _GridGraphs createState() => _GridGraphs();
}

class _GridGraphs extends State<GridGraphs>
    with SingleTickerProviderStateMixin {
  List<List<Product>> itemsListByCounty;
  ScrollController ctrl;
  TabController tabctrl;
  int dataIndicator;
  bool animate;

  @override
  void initState() {
    super.initState();
    dataIndicator = widget.dataIndicator;
    animate = widget.animate;
    ctrl = ScrollController();
    tabctrl =
        TabController(length: getMyTabs(dataIndicator).length, vsync: this);
  }

  @override
  void dispose() {
    // tabctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.key);
    return Scaffold(
        appBar: AppBar(title: Text('Grids')),
        body: ListView(
          children: <Widget>[
            TabBar(
              controller: tabctrl,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.red,
              tabs: getMyTabs(dataIndicator),
            ),
            // ),
            FutureBuilder<List<Product>>(
              future: widget.items,
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? _GridView(
                        data: snapshot.data,
                        tabctrl: tabctrl,
                        dataIndicator: dataIndicator,
                        animate: animate,
                        key: widget.key,
                      )
                    : Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ));
  }
}

class _GridView extends StatelessWidget {
  _GridView({
    Key key,
    @required this.data,
    @required this.tabctrl,
    @required this.dataIndicator,
    @required this.animate,
  }) : super(key: key);

  final List<Product> data;
  List<List<Product>> itemsListByCounty = [];
  final TabController tabctrl;
  final int dataIndicator;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    Set countySet = data.map((e) => e.county).toSet();
    countySet.forEach((county) => itemsListByCounty
        .add(data.where((element) => element.county == county).toList()));
    return SizedBox(
        height: MediaQuery.of(context).size.height * 3 / 4,
        child: TabBarView(
          key: key,
          controller: tabctrl,
          children: createAnnualCountyDataForGrid(animate, itemsListByCounty,
              dataIndicator, COMPARISON_MODE_NONE, context, tabctrl),
          // getChildren(
          //     dataIndicator, animate, itemsListByCounty, COMPARISON_MODE_NONE),
        ));
  }
}
