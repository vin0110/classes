import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'Product.dart';

import 'SimpleBarChart.dart';

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

  int _counter = 0;
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
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CropListwidget(
                                  crops:
                                      fetchAvailableCrops(stateController.text),
                                  state: stateController.text)));
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CropListwidget extends StatelessWidget {
  final Future<List<String>> crops;

  final String state;

  CropListwidget({Key key, this.crops, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text("List of crops available for view for state: " + state)),
        body: Center(
          child: FutureBuilder<List<String>>(
            future: crops,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? CropBoxList(
                      crops: snapshot.data,
                      state: state,
                    )
                  // return the ListView widget :
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}

class CropBoxList extends StatelessWidget {
  final List<String> crops;
  final String state;
  CropBoxList({Key key, this.crops, this.state});

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
                  crops: getProductList(crops[index], state),
                  animate: true,
                  crop: crops[index],
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

Future<List<String>> fetchAvailableCrops(String state) async {
  final response = await http.get(
      'http://localhost:8002/WsEcl/submit/query/thor/getcroplist/json?state=' +
          state +
          '&submit_type=json');
  if (response.statusCode == 200) {
    return parseCropResponse(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}

List<String> parseCropResponse(String responseBody) {
  print(responseBody);
  dynamic tmp = json.decode(responseBody);
  final parsed =
      tmp['getcroplistResponse']['Results']['Result 1']['Row'].cast<dynamic>();
  return parsed.map<String>((jsonobj) => jsonobj['crop'].toString()).toList();
}

List<Product> parseProducts(String responseBody) {
  print(responseBody);
  dynamic tmp = json.decode(responseBody);
  final parsed = tmp['fetchqueryResponse']['Results']['Result 1']['Row']
      .cast<Map<String, dynamic>>();
  return parsed.map<Product>((jsonobj) => Product.fromJson(jsonobj)).toList();
}

Future<List<Product>> getProductList(String crop, String state) async {
  final response = await http.post(
      'http://localhost:8002/WsEcl/submit/query/thor/fetchquery/json',
      body: {'submit_type': 'json', 'crop': crop, 'state': state});
  if (response.statusCode == 200) {
    return parseProducts(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}
