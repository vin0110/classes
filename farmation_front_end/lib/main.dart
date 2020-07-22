import 'package:farmation_front_end/VariantsList.dart';
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
                                  crops: fetchVariants(
                                      STATE_ANNUAL_CROP, stateController.text),
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
                                  crops: fetchVariants(ECONOMICS_ANNUAL_INCOME,
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
                                  crops: fetchVariants(ECONOMICS_ANNUAL_AG_LAND,
                                      stateController.text),
                                  state: stateController.text,
                                  dataIndicator: ECONOMICS_ANNUAL_AG_LAND)));
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
                  ? VariantsList(
                      crops: snapshot.data,
                      state: state,
                      dataIndicator: dataIndicator,
                      isPopup: false)
                  // return the ListView widget :
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}
