import 'package:flutter/material.dart';
 
// function to trigger build when the app is run
void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeRoute(),
      '/food': (context) => const FoodRoute(),
      '/review': (context) => const ReviewRoute(),
      '/help': (context) => const HelpRoute(),
    },
  )); //MaterialApp
}
 
class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FoodGrind'),
        backgroundColor: Colors.green,
      ), // AppBar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Food Route'),
              onPressed: () {
                Navigator.pushNamed(context, '/food');
              },
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('Review Route'),
              onPressed: () {
                Navigator.pushNamed(context, '/review');
              },
            ), // ElevatedButton
            ElevatedButton(
              child: const Text('Help Route'),
              onPressed: () {
                Navigator.pushNamed(context, '/help');
              },
            ), // ElevatedButton
          ], // <Widget>[]
        ), // Column
      ), // Center
    ); // Scaffold
  }
}
 
class FoodRoute extends StatelessWidget {
  const FoodRoute({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Route"),
        backgroundColor: Colors.green,
      ), // AppBar
    ); // Scaffold
  }
}
 
class ReviewRoute extends StatelessWidget {
  const ReviewRoute({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Route"),
        backgroundColor: Colors.green,
      ), // AppBar
    ); // Scaffold
  }
}

class HelpRoute extends StatelessWidget {
  const HelpRoute({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Route"),
        backgroundColor: Colors.green,
      ), // AppBar
    ); // Scaffold
  }
}