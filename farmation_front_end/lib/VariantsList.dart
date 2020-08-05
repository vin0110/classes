import 'package:farmation_front_end/GridGraphs.dart';
import 'package:farmation_front_end/SimpleBarChart.dart';
import 'package:flutter/material.dart';

import 'Constants.dart';
import 'Endpoint/endpoint.dart';

class VariantsList extends StatelessWidget {
  final List<String> crops;
  final String state;
  final int dataIndicator;
  final bool isPopup;
  VariantsList(
      {Key key, this.crops, this.state, this.dataIndicator, this.isPopup});
  ScrollController ctrl = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        controller: ctrl,
        isAlwaysShown: true,
        child: Container(
            // color: Colors.blue,
            padding: const EdgeInsets.only(left: 16),
            height: MediaQuery.of(context).size.height * 1 / 2,
            width: MediaQuery.of(context).size.width * 3 / 4,
            child: ListView.builder(
              controller: ctrl,
              itemCount: crops.length,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Text(crops[index]),
                  onTap: () {
                    isPopup
                        ? popOut(context, index)
                        : pushToNewScreen(context, index);
                  },
                );
              },
            )));
  }

  void pushToNewScreen(BuildContext context, int index) {
    var products = getProducts(dataIndicator, crops[index], state);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EXP == dataIndicator
            ? GridGraphs(
                animate: false,
                dataIndicator: dataIndicator,
                items: products,
              )
            : SimpleBarChart(
                crops: products,
                animate: true,
                crop: crops[index],
                dataIndicator: dataIndicator,
              ),
        // builder: (context) => PiePage(items),
      ),
    );
  }

  void popOut(BuildContext context, int index) {
    Navigator.pop(
      context,
      crops[index],
    );
  }
}
