import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List restList;
  double screenHeight, screenWidth;
  String titlecenter = "Loading Restaurant...";


  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Restaurants'),
      )
    );
    
}
}
 