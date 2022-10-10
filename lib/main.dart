import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/food',
      routes: {
        '/home': (context) => const HomeRoute(),
        '/food': (context) => const FoodRoute(),
        '/review': (context) => const ReviewRoute(),
        '/help': (context) => const HelpRoute(),
      },
    ),
  );
}

class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  getCafeData() async {
    var response = await http.get(Uri.https('header', 'unencoded path'));
    var jsonData = jsonDecode(response.body);
    for (int i = 0; i < halls.length; i++) {
      halls[i].dailyRating = jsonData[i]['dailyRating'];
      halls[i].allRating = jsonData[i]['allRating'];
      halls[i].openTimes = jsonData[i]['openTimes'];
    }
  }

  @override
  Widget build(BuildContext context) {
    const double nameButtonFontSize = 30;
    const double openButtonFontSize = 20;
    Widget homeBlock(DiningHall hall, int chosenColor) {
      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 83, 83, 83),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
        ),
        height: 160,
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Align(
              alignment: const Alignment(-1, 0),
              child: Text(
                hall.name,
                style: const TextStyle(
                    fontSize: nameButtonFontSize, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: const Alignment(-1, 0),
              child: Text(
                (hall.dailyRating > 0)
                    ? "Today: ${stars[hall.dailyRating.round() - 1]}"
                    : 'No Reviews Yet',
                style: TextStyle(
                    color: (hall.dailyRating > 0) ? Colors.black : Colors.black,
                    fontSize: nameButtonFontSize),
              ),
            ),
            Align(
              alignment: const Alignment(-1, 0),
              child: Text((hall.isOpen) ? 'OPEN' : 'CLOSED',
                  style: TextStyle(
                      fontSize: openButtonFontSize,
                      fontWeight: FontWeight.w700,
                      color: (hall.isOpen) ? Colors.green : Colors.red)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 239, 239),
      appBar: AppBar(
        title: const Text(
          'FoodGrind',
          style: TextStyle(fontSize: 30),
        ),
        toolbarHeight: 40,
        backgroundColor: const Color.fromRGBO(46, 43, 43, 1),
        shadowColor: const Color(0x00FFFFFF),
      ),
      body: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              color: const Color.fromRGBO(46, 43, 43, 1),
              height: 60,
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                dailyQuote,
                style: const TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            GestureDetector(
              onTap: () {
                chosenHall = halls[0];
                Navigator.pushNamed(context, '/food');
              },
              child: homeBlock(halls[0], 0xFFFFFFFF),
            ),
            GestureDetector(
              onTap: () {
                chosenHall = halls[1];
                Navigator.pushNamed(context, '/food');
              },
              child: homeBlock(halls[1], 0xFFEFEFEF),
            ),
            GestureDetector(
              onTap: () {
                chosenHall = halls[2];
                Navigator.pushNamed(context, '/food');
              },
              child: homeBlock(halls[2], 0xFFD6D6D6),
            ),
            GestureDetector(
              onTap: () {
                chosenHall = halls[3];
                Navigator.pushNamed(context, '/food');
              },
              child: homeBlock(halls[3], 0xFFC4C4C4),
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

// Route to Specific Dining Hall
class FoodRoute extends StatefulWidget {
  const FoodRoute({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  State<FoodRoute> createState() => _FoodRouteState();
}

class _FoodRouteState extends State<FoodRoute> {
  late List<Widget> foodWidgets;

  @override
  Widget build(BuildContext context) {
    Widget foodBlock(Food currFood) {
      return GestureDetector(
        // ignore: avoid_print
        onTap: () => print(foodWidgets),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                width: 2.0,
                color: Color.fromARGB(255, 83, 83, 83),
              ),
            ),
          ),
          child: Center(
            child: Text(currFood.name),
          ),
        ),
      );
    }

    foodWidgets = <Widget>[
      for (Food foodItem in chosenHall.menu) foodBlock(foodItem)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(chosenHall.name),
        titleTextStyle: const TextStyle(fontSize: 30),
        backgroundColor: const Color.fromARGB(255, 83, 83, 83),
      ),
      body: SingleChildScrollView(
        child: Column(children: foodWidgets),
      ),
    );
  }
}

// Route to leave reviews
class ReviewRoute extends StatelessWidget {
  const ReviewRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review Route"),
        backgroundColor: const Color.fromARGB(255, 83, 83, 83),
      ),
    );
  }
}

// Help and About Route
class HelpRoute extends StatelessWidget {
  const HelpRoute({Key? key}) : super(key: key);

  // ignore: avoid_returning_null_for_void
  void get data => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Help Route"),
          backgroundColor: const Color.fromARGB(255, 83, 83, 83),
        ),
        body: Center(
            child: Container(
                margin: const EdgeInsets.only(
                    left: 0, top: 0, right: 250, bottom: 680),
                child: const Text(
                    'About us: This app was created by berkely students who are to lazy to look up the menu at every dining hall to see whats not shit. It was created by Nihal Boina, Jameson Crate, and Jorge-Luis Gonzalez)',
                    style: TextStyle(fontSize: 15)))
            //   Column(
            //     children:
            //       const [
            //       Text('Fuck off')
            //     ]

            //   key: Text('This app was created by berkely students who are to lazy to look up the menu at every dining hall to see whats not shit. It was created by Nihal Boina, Jameson Crate, and Jorge-Luis Gonzalez')
            // ));

            //style: const TextStyle(fontSize: buttonFontSize),
            ));
  }
}

class Food {
  late String name, image;
  late Map nutFacts;
  late List labels;

  Food(this.name, this.image, this.nutFacts, this.labels);
}

class DiningHall {
  late String name, image;
  late int allRating = 0, dailyRating = 4;
  late List menu, openTimes = [[], [], [], [], [], []];
  late bool isOpen = false;

  DiningHall(this.name, this.image, this.menu);
}

class Review {
  late String location, comment;
  late double rating;
  late List meal;

  Review(this.location, this.rating, this.meal, this.comment);
}

List<DiningHall> sortHalls(List<DiningHall> options) {
  List<DiningHall> openHalls = [];
  List<DiningHall> closedHalls = [];
  for (DiningHall h in options) {
    if (h.isOpen) {
      openHalls.add(h);
    } else {
      closedHalls.add(h);
    }
  }
  closedHalls.sort((a, b) => b.dailyRating.compareTo(a.dailyRating));
  openHalls.sort((a, b) => b.dailyRating.compareTo(a.dailyRating));
  return openHalls + closedHalls;
}

String dailyQuote = 'Be the first one to leave a comment today!';

DiningHall chosenHall = cafeThree;

List<DiningHall> unsortedHalls = [clarkKerr, cafeThree, foothill, crossroads];
List<DiningHall> halls = sortHalls(unsortedHalls);
List<String> stars = ['★', '★★', '★★★', '★★★★', '★★★★★'];

Food pizza = Food(
    'Pizza', '', {'Protein': '10g', 'Sugar': '23g'}, ['Vegan', 'Non-Dairy']);

Food burger = Food(
    'Burger', '', {'Protein': '10g', 'Sugar': '23g'}, ['Vegan', 'Non-Dairy']);

List<Food> foodList0 = [pizza, burger];
List<Food> foodList1 = [burger, burger, burger];
List<Food> foodList2 = [pizza, burger, pizza];
List<Food> foodList3 = [pizza];

DiningHall cafeThree = DiningHall('Cafe 3', '', foodList0);
DiningHall clarkKerr = DiningHall('Clark Kerr', '', foodList1);
DiningHall foothill = DiningHall('Foothill', '', foodList2);
DiningHall crossroads = DiningHall('Crossroads', '', foodList3);
