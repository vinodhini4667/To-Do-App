import 'package:flutter/material.dart';
import 'package:food/home_page.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  //initialize the hive data base
  await Hive.initFlutter();

  //open a box
  var bax= await Hive.openBox("mybox");
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:HomePage(),
      theme: ThemeData(primarySwatch: Colors.grey),
    );
  }
}

