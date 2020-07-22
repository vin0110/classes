import 'package:farmation_front_end/SimpleBarChart.dart';
import 'package:flutter/material.dart';

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
    Navigator.push(
      context,
      MaterialPageRoute(
        // builder: (context) => ProductPage(item: items[index]),
        builder: (context) => SimpleBarChart(
          crops: getProducts(dataIndicator, crops[index], state),
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
