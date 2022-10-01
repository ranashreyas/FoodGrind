import 'package:flutter/material.dart';

class Food {
  late String name;
  late String image;
  late Map nutFacts;
  late List labels;

  Food(this.name, this.image);
}

class DiningHall {
  late String name;
  late String image;
  late double allRating;
  late List menu;
  double dailyRating = 5;

  DiningHall(this.name, this.image);

  double getDaily() {
    // STILL NEEDS TO BE IMPLEMENTED
    return 0;
  }

  double getTotal() {
    // STILL NEEDS TO BE IMPLEMENTED
    return 0;
  }
}

class Review {
  late double rating;
  late List meal;
  late String comment;

  Review(this.rating, this.meal, this.comment);
}

var cafeThree = DiningHall('Cafe 3', '');
var clarkKerr = DiningHall('Clark Kerr', '');
var foothill = DiningHall('Foothill', '');
var crossroads = DiningHall('Crossroads', '');

List<DiningHall> halls = [clarkKerr, cafeThree, foothill, crossroads];
List<String> stars = ['★', '★★', '★★★', '★★★★', '★★★★★'];

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
    const double buttonFontSize = 30;
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
                child: Align(
                  alignment: const Alignment(-1, 0),
                  child: Column(
                    children: [
                      Text(
                        halls[0].name,
                        style: const TextStyle(fontSize: buttonFontSize),
                      ),
                      Text(
                        (halls[0].dailyRating > 0)
                            ? stars[halls[0].dailyRating.round() - 1]
                            : 'No Reviews Yet',
                        style: const TextStyle(
                            color: Colors.yellow, fontSize: buttonFontSize),
                      ),
                    ],
                  ),
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
                child: Text(
                  halls[1].name,
                  style: const TextStyle(fontSize: buttonFontSize),
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
                child: Text(
                  halls[2].name,
                  style: const TextStyle(fontSize: buttonFontSize),
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
                child: Text(
                  halls[3].name,
                  style: const TextStyle(fontSize: buttonFontSize),
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
        backgroundColor: const Color(0xFF2F80EC),
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
        backgroundColor: const Color(0xFF2F80EC),
      ),
    );
  }
}

// Help and About Route
class HelpRoute extends StatelessWidget {
  const HelpRoute({Key? key}) : super(key: key);

  Null get data => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Help Route"),
          backgroundColor: const Color(0xFF2F80EC),
        ),
        body: Center(
          child: Container(
              margin: EdgeInsets.only(left: 0, top: 0, right: 250, bottom: 680),
              child: Text('About us:', style: TextStyle(fontSize: 35))),
              // Column(
              //   children: const [
              //     Text('Fuck off')
              //   ]

          
          //key: Text('This app was created by berkely students who are to lazy to look up the menu at every dining hall to see whats not shit. It was created by Nihal Boina, Jameson Crate, and Jorge-Luis Gonzalez')
        ));

    //style: const TextStyle(fontSize: buttonFontSize),
  }
}
