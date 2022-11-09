import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/home',
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

  @override
  void initState(){
    super.initState();
    getCafeData();

  }

  getCafeData() async {
    var allFoodResponse = await http.get(Uri.parse('https://food-grind.herokuapp.com/getAllNutFacts/'));
    var allTodaysFoodResponse = await http.get(Uri.parse('https://food-grind.herokuapp.com/getAllFoods/'));
    var allFood = jsonDecode(allFoodResponse.body)['NutFacts'];
    var allTodaysFood = jsonDecode(allTodaysFoodResponse.body);

    for (var k in allFood.keys){
      allFoodMap[k] = Food(k, '', allFood[k], []);
    }

    for (var i = 0; i < allTodaysFood['AllFoods'].length; i++){
      for (var f in allTodaysFood['AllFoods'][i][0]){
        // print(f);
        // print(allFoodMap[f]);
        if(allFoodMap[f] != null){
          diningHallMenus[i].add(allFoodMap[f]);
        } else { // If this is a special menu item or something, and its nutritional facts do not exist
          print(f);
          diningHallMenus[i].add(Food(f, '', ["Not Available"], []));
        }
      }
    }
    // print(diningHallMenus);
    setState(() {
      halls;
    });
    // print('got cafe data');
  }

  @override
  Widget build(BuildContext context) {
    const double nameButtonFontSize = 25;
    const double openButtonFontSize = 15;
    Widget homeBlock(DiningHall hall, int chosenColor) {
      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: const Color.fromARGB(255, 83, 83, 83),
          // ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[300],
        ),
        // height: 160,
        // width: double.infinity,
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
                    ? "Today: ${stars[hall.dailyRating - 1]}"
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
        ListView(
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
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(chosenHall);
  }

  @override
  Widget build(BuildContext context) {
    const double menuItemFontSize = 20;

    Widget foodBlock(Food currFood) {
      return GestureDetector(
        onTap: (){
          _instructionsModal(context, currFood);
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.only(left:20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.grey[300],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.black),
                      color: Colors.grey[300],
                    ),
                    child: Text(currFood.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: menuItemFontSize, fontWeight: FontWeight.normal)),
                  )
              ),
              // Expanded( ///Are the Nutrition Facts necessary for the preview?
              //     child: Container(
              //       decoration: BoxDecoration(
              //         border: Border.all(color: Colors.black),
              //         color: Colors.grey[300],
              //       ),
              //       child: Text(currFood.nutFacts.toString(), style: const TextStyle(fontSize: menuItemFontSize, fontWeight: FontWeight.normal)),
              //     )
              // ),
              Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.black),
                        color: Colors.grey[300],
                      ),
                      child: Text("${stars[currFood.historicalRating - 1]}", style: const TextStyle(fontSize: menuItemFontSize, fontWeight: FontWeight.normal)),
                    )
                  )
              ),
            ],
          )
        )
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
      body: ListView(children: foodWidgets),
    );
  }

  void _instructionsModal(context, Food currFood) {
    const double nameFontSize = 25;
    const double nutritionFactsFontSize = 20;
    var simplifiedNutFacts = "";
    for (var f in currFood.nutFacts){
      simplifiedNutFacts += f + "\n";
    }

    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return Container(
        height: MediaQuery.of(context).size.height*.8,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(currFood.name, style: const TextStyle(
                  fontSize: nameFontSize, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("${stars[currFood.historicalRating - 1]}", style: const TextStyle(
                  fontSize: nameFontSize, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(simplifiedNutFacts, style: const TextStyle(
                  fontSize: nutritionFactsFontSize, fontWeight: FontWeight.normal)),
            ),
            const Padding(
              padding: EdgeInsets.only(top:0, bottom:8.0, right:8.0, left:8.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 0.5,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                )
              )
            )
          ],
        )
      );
    });
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
  late List nutFacts;
  late List labels;
  late int historicalRating = 5;

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

Map allFoodMap = {};

Food pizza = Food(
    'Pizza', '', ['Protein: 1000000g', 'Sugar: 23g'], ['Vegan', 'Non-Dairy']);

Food burger = Food(
    'Triple beef quarter pounder cheeseburger', '', ['Protein: 10g', 'Sugar: 23g'], ['Vegan', 'Non-Dairy']);

List<List<Food>> diningHallMenus = [[],[],[],[]];

// List<Food> c3Menu = [pizza, burger];
// List<Food> ckMenu = [burger, burger, burger];
// List<Food> croadsMenu = [pizza, burger, pizza];
// List<Food> fhMenu = [pizza];

DiningHall cafeThree = DiningHall('Cafe 3', '', diningHallMenus[0]);
DiningHall clarkKerr = DiningHall('Clark Kerr', '', diningHallMenus[1]);
DiningHall crossroads = DiningHall('Crossroads', '', diningHallMenus[2]);
DiningHall foothill = DiningHall('Foothill', '', diningHallMenus[3]);

