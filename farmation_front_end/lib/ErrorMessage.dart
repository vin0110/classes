import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('No data found for the given input'),
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: RaisedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            )),
      ],
    ); // TODO: implement build
    throw UnimplementedError();
  }
}
