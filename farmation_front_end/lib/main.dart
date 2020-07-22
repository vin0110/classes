import 'package:flutter/material.dart';

// import 'package:farmation_front_end/products/Product.dart';
import 'package:farmation_front_end/Endpoint/endpoint.dart';

import 'SimpleBarChart.dart';
import 'Constants.dart' as constc;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  final _formKey = GlobalKey<FormState>();
  final stateController = TextEditingController();
  final yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter State eg. NC',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some state';
                  }
                  return null;
                },
                controller: stateController,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Listwidget(
                                  crops: fetchVariants(constc.STATE_ANNUAL_CROP,
                                      stateController.text),
                                  state: stateController.text,
                                  dataIndicator: constc.STATE_ANNUAL_CROP)));
                    }
                  },
                  child: Text('Continue to Annual Data'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Listwidget(
                                    crops: fetchVariants(
                                        constc.STATE_MONTHLY_CROP,
                                        stateController.text),
                                    state: stateController.text,
                                    dataIndicator: constc.STATE_MONTHLY_CROP,
                                  )));
                    }
                  },
                  child: Text('Continue to Monthly Data'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Listwidget(
                                  crops: fetchVariants(
                                      constc.ECONOMICS_ANNUAL_INCOME,
                                      stateController.text),
                                  state: stateController.text,
                                  dataIndicator:
                                      constc.ECONOMICS_ANNUAL_INCOME)));
                    }
                  },
                  child: Text('Continue to Annual Economic Income Data'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Listwidget(
                                  crops: fetchVariants(
                                      constc.ECONOMICS_ANNUAL_AG_LAND,
                                      stateController.text),
                                  state: stateController.text,
                                  dataIndicator:
                                      constc.ECONOMICS_ANNUAL_AG_LAND)));
                    }
                  },
                  child: Text(
                      'Continue to Annual Economic Agricultural Land data'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Future<List<String>> fetchVariants(int dataIndicator, String state) {
//   switch (dataIndicator) {
//     case constc.STATE_ANNUAL_CROP:
//       return StateAnnualCropProduct.fetchVariants(state);
//       break;
//     case constc.STATE_MONTHLY_CROP:
//       return StateMonthlyCropProduct.fetchVariants(state);
//       break;
//     case constc.ECONOMICS_ANNUAL_AG_LAND:
//       return EconomicsAnnualAGLandProduct.fetchVariants(state);
//       break;
//     case constc.ECONOMICS_ANNUAL_INCOME:
//       return EconomicsAnnualIncomeProduct.fetchVariants(state);
//       break;
//     default:
//       print('ERROR 5984954');
//       return null;
//   }
// }

class Listwidget extends StatelessWidget {
  final Future<List<String>> crops;

  final String state;

  final int dataIndicator;

  Listwidget({Key key, this.crops, this.state, this.dataIndicator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("List of data variants available for view for state: " +
                state)),
        body: Center(
          child: FutureBuilder<List<String>>(
            future: crops,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? BoxList(
                      crops: snapshot.data,
                      state: state,
                      dataIndicator: dataIndicator,
                    )
                  // return the ListView widget :
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}

class BoxList extends StatelessWidget {
  final List<String> crops;
  final String state;
  final int dataIndicator;
  BoxList({Key key, this.crops, this.state, this.dataIndicator});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: crops.length,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Text(crops[index]),
          onTap: () {
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
          },
        );
      },
    );
  }
}

// fetchCrops(int dataIndicator, String crop, String state) {
//   switch (dataIndicator) {
//     case constc.STATE_ANNUAL_CROP:
//       return getProducts(dataIndicator, crop, state);
//       break;
//     case constc.STATE_MONTHLY_CROP:
//       return StateMonthlyCropProduct.getProducts(crop, state);
//       break;
//     case constc.ECONOMICS_ANNUAL_AG_LAND:
//       return EconomicsAnnualAGLandProduct.getProducts(crop, state);
//       break;
//     case constc.ECONOMICS_ANNUAL_INCOME:
//       return EconomicsAnnualIncomeProduct.getProducts(crop, state);
//       break;
//     default:
//       print('ERROR 64897');
//       return null;
//   }
// }
