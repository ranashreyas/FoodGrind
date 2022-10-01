import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeRoute(),
      '/food': (context) => const FoodRoute(),
      '/review': (context) => const ReviewRoute(),
      '/help': (context) => const HelpRoute(),
    },
  ));
}

class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC4C4C4),
      appBar: AppBar(
        title: const Text('FoodGrind'),
        backgroundColor: const Color(0xFF2F80EC),
      ),
      body: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/food');
              },
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(30),
                child: const Text(
                  'Cafe 3',
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/food');
              },
              child: Container(
                height: 200,
                width: double.infinity,
                color: const Color(0xFFEFEFEF),
                padding: const EdgeInsets.all(30),
                child: const Text(
                  'Crossroads',
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/food');
              },
              child: Container(
                height: 200,
                width: double.infinity,
                color: const Color(0xFFD6D6D6),
                padding: const EdgeInsets.all(30),
                child: const Text(
                  'Foothill',
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/food');
              },
              child: Container(
                height: 200,
                width: double.infinity,
                color: const Color(0xFFC4C4C4),
                padding: const EdgeInsets.all(30),
                child: const Text(
                  'Clark Kerr',
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: const Alignment(0.8, 0.9),
          child: FloatingActionButton(
              backgroundColor: const Color(0xFFD9D9D9),
              onPressed: () {
                Navigator.pushNamed(context, '/help');
              },
              child: const Text(
                '?',
                style: TextStyle(color: Colors.black, fontSize: 30),
              )),
        ),
      ]),
    );
  }
}

class FoodRoute extends StatelessWidget {
  const FoodRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Route"),
        backgroundColor: Color(0xFF2F80EC),
      ),
    );
  }
}

class ReviewRoute extends StatelessWidget {
  const ReviewRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Route"),
        backgroundColor: Color(0xFF2F80EC),
      ),
    );
  }
}

class HelpRoute extends StatelessWidget {
  const HelpRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Route"),
        backgroundColor: Color(0xFF2F80EC),
      ),
    );
  }
}
