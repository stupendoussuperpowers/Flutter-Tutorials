import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String number = '1';
String typeVal = 'people';

Future<Post> fetchPost() async {
  final response =
      await http.get('https://swapi.co/api/$typeVal/$number');

  return Post.fromJson(json.decode(response.body));
  
}

class Post {

  final String name;
  final String height;
  final String mass;
  final String gender;
  final String birth_year;

  Post({this.name,this.height,this.mass,this.gender,this.birth_year});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      name: json['name'],
      height: json['height'],
      mass: json['mass'],
      gender: json['gender'],
      birth_year: json['birth_year']
    );
  }
}

void main() => runApp(Appyappapp());

class MyApp extends StatelessWidget {
  Future<Post> post;

  MyApp({Key key, this.post}) : super(key: key);

  Widget displayInfo(BuildContext context){

    final _biggerFont = const TextStyle(fontSize: 20.0);

    return Container(child: FutureBuilder<Post>(
        future: post,
        builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(child:Column(children:[Text("Name: ${snapshot.data.name}",style: _biggerFont,),
                                        Text("Mass: ${snapshot.data.mass}",style: _biggerFont),
                                        Text("Height: ${snapshot.data.height}",style: _biggerFont),
                                        Text("Birth Year: ${snapshot.data.birth_year}",style: _biggerFont),
                                        Text("Gender: ${snapshot.data.gender}",style: _biggerFont)
                          ],
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          ));
              } else if (snapshot.hasError) {
                return Text("whoooops!");
              }
              return Center(child:CircularProgressIndicator());
        }
    ),
    );
  }


  @override
  Widget build(BuildContext context) {
    print("$number");
    return MaterialApp( 
        home: Scaffold(appBar: AppBar(),
        body: displayInfo(context) 
      )
    );
  }
}

class StateMainPage extends StatefulWidget{
  @override
  createState() => new MainPage();
}

class Appyappapp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Star Wars Info',
      home: StateMainPage()
    );
  }
}

class MainPage extends State<StateMainPage>{
 
  final formKey = GlobalKey<FormState>();




  Widget boxesandbuttons(BuildContext context){
    
    List<DropdownMenuItem<String>> listCat = []; 


    void listCatinit(){
      listCat = [];
      listCat.add(new DropdownMenuItem(child:Text("People"),value:'people'));
      listCat.add(new DropdownMenuItem(child:Text("Planets"),value:'planets'));
      listCat.add(new DropdownMenuItem(child:Text("Spaceships"),value:'spaceships'));
    }

    listCatinit();

    Widget typeBox = Center(child:DropdownButton(items:listCat,onChanged: (value)=>typeVal=value));

    Widget numberBox = Container(child: TextFormField(
      decoration: InputDecoration(labelText: "Enter Number",
      hintText: "1,2,...",                            
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
      onSaved: (String val)=> number = val),
      margin: const EdgeInsets.all(20.0));

    Widget submitButton = Container(child: RaisedButton(child: new Text("SUBMIT"), padding: EdgeInsets.all(8.0),
      onPressed: (){
        formKey.currentState.save();
        final welcomeScreen = MaterialPageRoute(builder: (context) => MyApp(post:fetchPost()));
        Navigator.push(context, welcomeScreen);
      }, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
      ),
      margin: const EdgeInsets.all(20.0));

    return Container(
      child: Column(children: [typeBox,numberBox,submitButton],mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center)
    );
  }

  Widget build(BuildContext context){
    
    return Form(key: formKey,
                child:Scaffold(
                  appBar: AppBar(title: Text("Star Wars Humans"),),
                  body: boxesandbuttons(context),
                )
                );
  }
}