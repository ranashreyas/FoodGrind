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
  double dailyRating = 3;

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

var chosenHall = cafeThree;

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
    Widget homeBlock(DiningHall hall, int chosenColor) {
      return Container(
        height: 200,
        width: double.infinity,
        color: Color(chosenColor),
        padding: const EdgeInsets.all(30),
        child: Align(
          alignment: const Alignment(-1, 0),
          child: Column(
            children: [
              Text(
                hall.name,
                style: const TextStyle(fontSize: buttonFontSize),
              ),
              Text(
                (hall.dailyRating > 0)
                    ? stars[hall.dailyRating.round() - 1]
                    : 'No Reviews Yet',
                style: const TextStyle(
                    color: Colors.yellow, fontSize: buttonFontSize),
              ),
            ],
          ),
        ),
      );
    }

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
                  chosenHall = halls[0];
                  Navigator.pushNamed(context, '/food');
                },
                child: homeBlock(halls[0], 0xFFFFFFFF)),
            GestureDetector(
                onTap: () {
                  chosenHall = halls[1];
                  Navigator.pushNamed(context, '/food');
                },
                child: homeBlock(halls[1], 0xFFEFEFEF)),
            GestureDetector(
                onTap: () {
                  chosenHall = halls[2];
                  Navigator.pushNamed(context, '/food');
                },
                child: homeBlock(halls[2], 0xFFD6D6D6)),
            GestureDetector(
                onTap: () {
                  chosenHall = halls[3];
                  Navigator.pushNamed(context, '/food');
                },
                child: homeBlock(halls[3], 0xFFC4C4C4)),
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
      body: Text(chosenHall.name),
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
