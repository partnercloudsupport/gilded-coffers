import 'package:flutter/material.dart';
import 'package:dnd_coin_balancer/firebase_functions.dart';
import 'package:dnd_coin_balancer/app.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gilded Coffers',
      theme: ThemeData.dark().copyWith(
        accentColor: Color(0xffffca28),
        primaryColor: Color(0xff2a1b11),
        scaffoldBackgroundColor: Color(0xff544237),
      ),
//      debugShowCheckedModeBanner: false,
      home: GCApp(
        auth: new Auth(),
      ),
    );
  }
}
