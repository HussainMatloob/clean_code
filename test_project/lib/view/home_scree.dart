import 'package:flutter/material.dart';

class HomeScree extends StatefulWidget {
  const HomeScree({super.key});

  @override
  State<HomeScree> createState() => _HomeScreeState();
}

class _HomeScreeState extends State<HomeScree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(child: Container()),
    );
  }
}
