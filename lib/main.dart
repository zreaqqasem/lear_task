import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Screens/MainScreen/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home:MaterialApp(
              debugShowCheckedModeBanner: false,
              showSemanticsDebugger: false,
              title: 'Flutter Task',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const MainScreen(),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home:MaterialApp(
              debugShowCheckedModeBanner: false,
              showSemanticsDebugger: false,
              title: 'Flutter Task',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const MainScreen(),
            ),
          );
        }
        return CupertinoActivityIndicator();
      },
    );
  }}

