import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async {
  Map _data = await getJson();
  List _features = _data['features'];

  runApp(new MaterialApp(
    home: new Scaffold(
      appBar: new AppBar(
        title: new Text("Quakes"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
          child: ListView.builder(
              itemCount: _features.length,
              padding: const EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, int position) {
                if (position.isOdd) return new Divider();

                final index = position ~/
                    2; //this will dividing the position by 2 and return an integer result

                //convert computer time(UNIX timestamp) to human readable time
                var formate = new DateFormat.yMMMMd("en_US").add_jm();
                var date = formate.format(
                    new DateTime.fromMicrosecondsSinceEpoch(
                        _features[position]['properties']['time'] * 1000));

                return ListTile(
                  title: new Text(
                    "$date",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500),
                  ),

                  subtitle: new Text(
                    "${_features[index]['properties']['place']}",
                    style: new TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic),
                  ),

                  leading: new CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: new Text(
                      "${_features[index]['properties']['mag']}",
                      style: new TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                    ),
                  ),

                  onTap: () => _showAlertDialog(
                      context, '${_features[index]['properties']['title']}'),
                );
              })),
    ),
  ));
}

_showAlertDialog(BuildContext context, String title) {
  var alrt = new AlertDialog(
    title: new Text("Quakes"),
    content: new Text(title),
    actions: <Widget>[
      new FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: new Text("OK"))
    ],
  );

  showDialog(
      context: context,
      builder: (context) {
        return alrt;
      });
}

Future<Map> getJson() async {
  String apiUrl =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}
