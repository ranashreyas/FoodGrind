import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/loading',
      routes: {
        '/loading': (context) => const LoadingRoute(),
        '/home': (context) => const HomeRoute(),
        '/food': (context) => const FoodRoute(),
        '/help': (context) => const HelpRoute(),
      },
    ),
  );
}

class LoadingRoute extends StatefulWidget {
  const LoadingRoute({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoadingRouteState createState() => _LoadingRouteState();
}

class _LoadingRouteState extends State<LoadingRoute> {

  @override
  void initState(){
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(
    //     SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.top]
    // );
    getCafeData();

  }

  getCafeData() async {
    var allFoodResponse = await http.get(Uri.parse('https://food-grind.herokuapp.com/getAllNuts/'));
    var allTodaysFoodResponse = await http.get(Uri.parse('https://food-grind.herokuapp.com/getAllFoods/'));
    var allTimesResponse = await http.get(Uri.parse('https://food-grind.herokuapp.com/getAllTimesnZones/'));
    // var allFoodRatingsResponse = await http.get(Uri.parse('https://food-grind.herokuapp.com/ratings/')); ///TODO Implement
    var allFood = jsonDecode(allFoodResponse.body)['NutFacts'];
    var allTodaysFood = jsonDecode(allTodaysFoodResponse.body);
    var openTimes = jsonDecode(allTimesResponse.body)['times']; ///TODO Implement
    // var allFoodRatings = jsonDecode(allFoodRatingsResponse.body)['ratings'] ///TODO Implement

    for (var k in allFood.keys){
      // allFoodMap[k] = Food(k, '', allFood[k], [], allFoodRatings[k][0], allFoodRatings[k][1]); ///TODO Implement
      allFoodMap[k] = Food(k, '', allFood[k], [], 68, 17); //this.name, this.image, this.nutFacts, this.labels, this.sumRatings, this.numRatings
      allFoodMap[k].sumRatings;
    }

    for (var i = 0; i < allTodaysFood['AllFoods'].length; i++){
      for (var f in allTodaysFood['AllFoods'][i][1]){
        if(allFoodMap[f] != null){
          diningHallMenus[i].add(allFoodMap[f]);
          int foodSumRating = allFoodMap[f].sumRatings;
          int foodNumRating = allFoodMap[f].numRatings;
          unsortedHalls[i].sumRatings += foodSumRating;
          unsortedHalls[i].numRatings += foodNumRating;
        } else { // If this is a special menu item or something, and its nutritional facts do not exist
          print(f);
          diningHallMenus[i].add(Food(f, '', ["Not Available"], [], 5, 1));
          unsortedHalls[i].sumRatings += 5;
          unsortedHalls[i].numRatings += 1;
        }
      }
    }

    halls = sortHalls(unsortedHalls);


    setState(() {
      Navigator.pushNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {

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
      body: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.black, size: 100)
      )
    );
  }
}



class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {

  late List<Widget> hallWidgetList;

  @override
  Widget build(BuildContext context) {
    const double nameButtonFontSize = 25;
    const double openButtonFontSize = 15;

    Widget homeBlock(DiningHall hall) {
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
        padding: const EdgeInsets.only(top: 25, left: 30, right: 30, bottom: 25),
        child: InkWell(
          onTap: () {
            chosenHall = hall;
            Navigator.pushNamed(context, '/food');
          },
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                alignment: const Alignment(-1, 0),
                child: Text(
                  hall.name,
                  style: const TextStyle(
                      fontSize: nameButtonFontSize, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  alignment: const Alignment(-1, 0),
                  child: Row(children: stars[(hall.sumRatings/hall.numRatings*2 - 1).round()])
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                alignment: const Alignment(-1, 0),
                child: Text((hall.isOpen) ? 'OPEN' : 'CLOSED',
                    style: TextStyle(
                        fontSize: openButtonFontSize,
                        fontWeight: FontWeight.w700,
                        color: (hall.isOpen) ? Colors.green : Colors.red)),
              ),
            ],
          ),
        ),
      );
    }


    hallWidgetList = <Widget>[
      for (DiningHall h in halls) homeBlock(h)
    ];
    hallWidgetList.insert(0, Container(
      color: const Color.fromRGBO(46, 43, 43, 1),
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Text(
        dailyQuote,
        style: const TextStyle(fontSize: 20, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    ));


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 239, 239),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          children: hallWidgetList
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
  final _reviewKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("${chosenHall.name}, ${chosenHall.sumRatings/chosenHall.numRatings}");
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
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.only(left:20, right: 20, top: 7, bottom: 7),
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
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.black),
                    color: Colors.grey[300],
                  ),
                  child: Row(children: stars[(currFood.sumRatings/currFood.numRatings*2 - 1).round()] )
                  // Text("10 ${stars[currFood.historicalRating - 1]}", style: const TextStyle(fontSize: menuItemFontSize, fontWeight: FontWeight.normal)),
                )
              )
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
    var rating = 3.0;

    for (var f in currFood.nutFacts){
      simplifiedNutFacts += f + "\n";
    }

    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return SizedBox(
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
              child: Row(children: stars[(currFood.sumRatings/currFood.sumRatings*2 - 1).round()] )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(simplifiedNutFacts, style: const TextStyle(
                  fontSize: nutritionFactsFontSize, fontWeight: FontWeight.normal)),
            ),
            Form(
              key: _reviewKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:0, bottom:8.0, right:8.0, left:8.0),
                    child: TextFormField(
                      validator: (value) {
                        // if (value == null || value.isEmpty) {
                        //   return 'Please enter some text';
                        // }
                        // return null;
                        print("Review: ${value!}, Stars: $rating");
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    )
                  ),
                ]
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
                  onRatingUpdate: (r) {
                    rating = r;
                  },
                )
              )
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_reviewKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Processing Data')),
                      // );
                    }
                  },
                  child: const Text('Submit'),
                )
            ),
          ],
        )
      );
    });
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
      body: Container(
        margin: const EdgeInsets.only(left: 20, right:20),
        child: const Center(
            child: Text('About us: FoodGrind created by Berkeley students who are too lazy to look up the menu at every dining hall to see whats not shit. It was created by Nihal Boina, Shreyas Rana, Jameson Crate, and Jorge-Luis Gonzalez.', style: TextStyle(fontSize: 15))
        )
      )
    );
  }
}

class Food {
  late String name, image;
  late List nutFacts;
  late List labels;
  late int sumRatings = 0;
  late int numRatings = 0;

  Food(this.name, this.image, this.nutFacts, this.labels, this.sumRatings, this.numRatings);
}

class DiningHall {
  late String name, image;
  late int sumRatings = 0;
  late int numRatings = 0;
  late List menu, openTimes = [[], [], [], [], [], []];
  late bool isOpen = (name == "Crossroads")?false:true;


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
  closedHalls.sort((a, b) => (b.sumRatings/b.numRatings).compareTo(a.sumRatings/a.numRatings));
  openHalls.sort((a, b) => (b.sumRatings/b.numRatings).compareTo(a.sumRatings/a.numRatings));
  return openHalls + closedHalls;
}

String dailyQuote = 'Be the first one to leave a comment today!';

DiningHall chosenHall = cafeThree;

List<DiningHall> unsortedHalls = [cafeThree, clarkKerr, crossroads, foothill];
List<DiningHall> halls = [];
var stars = [
  <Widget>[Image.asset('Assets/images/halfStar.png', height: 20, width: 20)],
  <Widget>[Image.asset('Assets/images/star.png', height: 20, width: 20)], //1 star
  <Widget>[Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/halfStar.png', height: 20, width: 20)],
  <Widget>[Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20)], // 2 star
  <Widget>[Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/halfStar.png', height: 20, width: 20)],
  <Widget>[Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20)], // 3 star
  <Widget>[Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/halfStar.png', height: 20, width: 20)],
  <Widget>[Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20)],
  <Widget>[Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/halfStar.png', height: 20, width: 20)],
  <Widget>[Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20), Image.asset('Assets/images/star.png', height: 20, width: 20)],
];

Map allFoodMap = {};

// Food pizza = Food(
//     'Pizza', '', ['Protein: 1000000g', 'Sugar: 23g'], ['Vegan', 'Non-Dairy']);
//
// Food burger = Food(
//     'Triple beef quarter pounder cheeseburger', '', ['Protein: 10g', 'Sugar: 23g'], ['Vegan', 'Non-Dairy']);

List<List<Food>> diningHallMenus = [[],[],[],[]];

DiningHall cafeThree = DiningHall('Cafe 3', '', diningHallMenus[0]);
DiningHall clarkKerr = DiningHall('Clark Kerr', '', diningHallMenus[1]);
DiningHall crossroads = DiningHall('Crossroads', '', diningHallMenus[2]);
DiningHall foothill = DiningHall('Foothill', '', diningHallMenus[3]);

