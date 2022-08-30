import 'package:flutter/material.dart';
import 'package:lear_task/Screens/MainScreen/Components/body.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title:const Text("Test Task"),
      ),
      body:const Body()
    );
  }
}