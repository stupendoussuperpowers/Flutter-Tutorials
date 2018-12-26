import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



void main() => runApp(MatApp());

class MatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("number");
    return MaterialApp( 
        home: StateMyApp()
      );
  }
}

class LocationISS{
  String latitude;
  String longitude;
  int timestamp;

  LocationISS({this.latitude,this.longitude, this.timestamp});

  factory LocationISS.fromJson(Map<String,dynamic> json){
    
    return(LocationISS(
      latitude: json['iss_position']['latitude'],
      longitude: json['iss_position']['longitude'],
      timestamp: json['timestamp']
    ));
  }
}


class StateMyApp extends StatefulWidget{
  @override
  createState() => new MyApp();
}


class MyApp extends State<StateMyApp>{

  String latTemp;
  String lonTemp;

  Future<LocationISS> fetchLoc() async {
  final response = 
      await http.get("http://api.open-notify.org/iss-now.json");

  setState(() {
      var temp = json.decode(response.body);
      latTemp = temp['iss_position']['latitude'];
      lonTemp = temp['iss_position']['longitude'];
    });

  return LocationISS.fromJson(json.decode(response.body));
  }

  //Future<LocationISS> postLoc = fetchLoc();

  @override
  Widget build(BuildContext context){
      print("yeah....");
      fetchLoc();
      return Scaffold(
        body: Center(
          child: Text("Lat: $latTemp \n Lon:$lonTemp") ,
          )
          );
  }
}