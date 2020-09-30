import 'package:farmation_front_end/VariantsList.dart';
import 'package:farmation_front_end/ErrorMessage.dart' as a;
import 'package:flutter/material.dart';

import 'package:farmation_front_end/Endpoint/endpoint.dart';

import 'Constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NASS data view',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFFCC0000, {
          50: Color(0xFFCC0000),
          100: Color(0xFFCC0000),
          200: Color(0xFFCC0000),
          300: Color(0xFFCC0000),
          400: Color(0xFFCC0000),
          500: Color(0xFFCC0000),
          600: Color(0xFFCC0000),
          700: Color(0xFFCC0000),
          800: Color(0xFFCC0000),
          900: Color(0xFFCC0000),
        }),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // routes: {
      //   MyHomePage.route: (context) =>
      //       MyHomePage(title: 'Farmation Demo Home Page'),
      //   ListwidgetRouteHolder.route: (context) => ListwidgetRouteHolder()
      // },
      home: MyHomePage(title: 'NASS data view'),
      // initialRoute: MyHomePage.route,
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
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                      crops: fetchVariants(STATE_ANNUAL_CROP,
                                          stateController.text),
                                      state: stateController.text,
                                      dataIndicator: STATE_ANNUAL_CROP)));
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
                                        crops: fetchVariants(STATE_MONTHLY_CROP,
                                            stateController.text),
                                        state: stateController.text,
                                        dataIndicator: STATE_MONTHLY_CROP,
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
                                          ECONOMICS_ANNUAL_INCOME,
                                          stateController.text),
                                      state: stateController.text,
                                      dataIndicator: ECONOMICS_ANNUAL_INCOME)));
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
                                          ECONOMICS_ANNUAL_AG_LAND,
                                          stateController.text),
                                      state: stateController.text,
                                      dataIndicator:
                                          ECONOMICS_ANNUAL_AG_LAND)));
                        }
                      },
                      child: Text(
                          'Continue to Annual Economic Agricultural Land data'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // Navigator.pushNamed(context, '/variants',
                          //     arguments: Args(
                          //         state: stateController.text, dataIndicator: EXP));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Listwidget(
                                      crops: fetchVariants(
                                          EXP, stateController.text),
                                      state: stateController.text,
                                      dataIndicator: EXP)));
                        }
                      },
                      child: Text('Continue to County level Annual data'),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

// class ListwidgetRouteHolder extends StatelessWidget {
//   static const String route = '/variants';
//   @override
//   Widget build(BuildContext context) {
//     // Args args = ModalRoute.of(context).settings.arguments;
//     Future<List<String>> crops = fetchVariants(args.dataIndicator, args.state);
//     // fetchVariants(args['dataIndicator'], args['state']);
//     // print(args.dataIndicator);
//     // print(args.state);
//     return Listwidget(
//       crops: crops,
//       dataIndicator: args.dataIndicator,
//       state: args.state,
//       // dataIndicator: args['dataIndicator'],
//       // state: args['state'],
//     );
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
              if (snapshot.hasError ||
                  (snapshot.hasData && snapshot.data.isEmpty)) {
                print(snapshot.error);
                print('Error 564847');
                return a.ErrorWidget();
              }
              if (snapshot.hasData && snapshot.data.length > 0)
                return VariantsList(
                    crops: snapshot.data,
                    state: state,
                    dataIndicator: dataIndicator,
                    isPopup: false);
              return Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}
