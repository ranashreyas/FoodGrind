import 'dart:convert';
import 'dart:core';
import 'dart:io' show HttpHeaders, Platform;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:device_info/device_info.dart';
// import 'package:platform_device_id/platform_device_id.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


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
    getCafeData();
  }

  getCafeData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');

    // final queryParameters = {
    //   'userId': 'one'
    // };
    // final uri =
    // Uri.https('www.myurl.com', '/postId/', queryParameters);
    // final response = await http.get(uri, headers: {
    //   HttpHeaders.authorizationHeader: 'Token',
    //   HttpHeaders.contentTypeHeader: 'application/json',
    // });

    final http.Response response = await http.post(
      Uri.parse('https://food-grind.herokuapp.com/postId/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': "djfskdjhflsjhds",
      }),
    );

    // var map = new Map<String, dynamic>();
    // map['userId'] = '43';
    // http.Response response = await http.post(
    //   uri,
    //   body: map,
    // );

    // final uri = Uri.parse('https://food-grind.herokuapp.com/postId/');
    // final response = await http.post(uri, body: {"userId": "43"});
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');


    // if (firstTime != null && !firstTime) {// Not first time
    //
    // } else {// First time
    //   prefs.setBool('first_time', false);
    //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    //   String? id;
    //   if (Platform.isAndroid) {
    //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //     id = androidInfo.id;
    //     final url = Uri.parse('https://food-grind.herokuapp.com/postId');
    //     final headers = {"Content-type": "application/json"};
    //     final json = '{"userId": $id}';
    //     final response = await post(url, headers: headers, body: json);
    //     print('Status code: ${response.statusCode}');
    //     print('Body: ${response.body}');
    //
    //   } else if (Platform.isIOS) {
    //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //     id = iosInfo.identifierForVendor;
    //     final url = Uri.parse('https://food-grind.herokuapp.com/postRating');
    //     final headers = {"Content-type": "application/json"};
    //     final json = '{"userId": $id}';
    //     final response = await post(url, headers: headers, body: json);
    //     print('Status code: ${response.statusCode}');
    //     print('Body: ${response.body}');
    //   }
    //
    //   // TODO push id for first time
    // }

    //Resets everything
    diningHallMenus = [[],[],[],[]];
    unsortedHalls = [cafeThree, clarkKerr, crossroads, foothill];
    halls = [];
    allFoodMap = {};

    // {
    //   'ratings':{
    //     "Apple Pie": {
    //       "SumReviews": 68,
    //       "NumReviews": 17
    //     }
    //     ....
    //   }
    // }

    // {
    //   'reviews': {
    //     "Apple Pie": [
    //       {
    //         "Rating": 5,
    //         "Review": "It was ok",
    //         "Time": 123456 //ms since epoch
    //       },
    //       {
    //         "Rating": 2,
    //         "Review": "It was bad",
    //         "Time": 123456
    //       }
    //       ....
    //     ]
    //     ....
    //   }
    // }


    var allFoodResponse = await http.get(Uri.parse('https://food-grind.herokuapp.com/getAllNuts/'));
    var allTodaysFoodResponse = await http.get(Uri.parse('https://food-grind.herokuapp.com/getAllFoods/'));
    var allTimesResponse = await http.get(Uri.parse('https://food-grind.herokuapp.com/getAllTimesnZones/'));
    // var allFoodRatingsResponse = await http.get(Uri.parse('https://food-grind.herokuapp.com/ratings/')); ///TODO Implement Ratings
    // var allFoodReviewsResponse = await http.get(Uri.parse('https://food-grind.herokuapp.com/reviews/')); ///TODO Implement Reviews
    var allFood = jsonDecode(allFoodResponse.body)['NutFacts'];
    var allTodaysFood = jsonDecode(allTodaysFoodResponse.body);
    var openTimes = jsonDecode(allTimesResponse.body)['times']; ///TODO Implement open times
    // var allFoodRatings = jsonDecode(allFoodRatingsResponse.body)['ratings'] ///TODO Implement Ratings List
    // var allFoodReviews = jsonDecode(allFoodRatingsResponse.body)['reviews'] ///TODO Implement Reviews List

    for (var k in allFood.keys){
      // allFoodMap[k] = Food(k, '', allFood[k], [], allFoodRatings[k]['SumReviews'], allFoodRatings[k]['NumReviews'], allFoodReviews[k]); ///TODO Implement, replace next line
      allFoodMap[k] = Food(k, '', allFood[k], [], 7, 2, [{"Rating": 5.0,"Review": "It was ok","Time": 123456},{"Rating": 2.0,"Review": "It was bad","Time": 223456}]); //this.name, this.image, this.nutFacts, this.labels, this.sumRatings, this.numRatings
    }

    for (var i = 0; i < allTodaysFood['AllFoods'].length; i++){
      for (var f in allTodaysFood['AllFoods'][i][0]){ //change index 0, 1, 2 for b, l, d
        if(allFoodMap[f] != null){
          diningHallMenus[i].add(allFoodMap[f]);
          int foodSumRating = allFoodMap[f].sumRatings;
          int foodNumRating = allFoodMap[f].numRatings;
          unsortedHalls[i].sumRatings += foodSumRating;
          unsortedHalls[i].numRatings += foodNumRating;
        } else { // If this is a special menu item or something, and its nutritional facts do not exist
          print(f);
          diningHallMenus[i].add(Food(f, '', ["Not Available"], [], 5, 1, [{"Rating": 5.0,"Review": "Glad it is back","Time": 123456},{"Rating": 2.0,"Review": "Why was it brought back?","Time": 223456}]));
          unsortedHalls[i].sumRatings += 5;
          unsortedHalls[i].numRatings += 1;
        }
      }
    }

    halls = sortHalls(unsortedHalls);


    setState(() {
      Navigator.pushNamed(context, routeAfterLoad);
    });
  }

  @override
  Widget build(BuildContext context) {

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

  Future onRefresh() async{
    routeAfterLoad = '/home';
    setState(() {
      Navigator.pushNamed(context, '/loading');
    });
  }

  @override
  Widget build(BuildContext context) {
    const double nameButtonFontSize = 25;
    const double openButtonFontSize = 15;

    Widget homeBlock(DiningHall hall) {
      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[300],
        ),
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
        RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            children: hallWidgetList
          )
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
  State<FoodRoute> createState() => _FoodRouteState();
}

class _FoodRouteState extends State<FoodRoute> {
  late List<Widget> foodWidgets;
  late List<Widget> reviewWidgets;
  final _reviewKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print("${chosenHall.name}, ${chosenHall.sumRatings/chosenHall.numRatings}");
    ratingsTemp = [];
  }

  Future onRefresh() async{
    routeAfterLoad = '/food';
    setState(() {
      Navigator.pushNamed(context, '/loading');
    });
  }

  Future<String?> _getId() async {

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }
    return "hello";
  }

  // Future<void> makePostRequest(String? deviceId, double rating, Food currFood) async {
  //   final url = Uri.parse('https://food-grind.herokuapp.com/postRating');
  //   final headers = {"Content-type": "application/json"};
  //   final json = '{"userId": $deviceId, "postRating": ${rating.toString()}, "location": ${chosenHall.name}, "food": ${currFood.name}, "timePosted", ${DateTime.now().millisecondsSinceEpoch/86400000}}';
  //   final response = await post(url, headers: headers, body: json);
  //   print('Status code: ${response.statusCode}');
  //   print('Body: ${response.body}');
  // }

  @override
  Widget build(BuildContext context) {
    const double menuItemFontSize = 20;

    Widget foodBlock(Food currFood) {

      List<Widget> ratingsRow = stars[(currFood.sumRatings/currFood.numRatings*2 - 1).round()]
          .map((element)=>element).toList(); //Copies the map, not creates an instance
      ratingsRow.insert(ratingsRow.length, Text(currFood.numRatings.toString()) );

      return GestureDetector(
        onTap: (){
          _foodInfoModal(context, currFood, ratingsRow);
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
                  child: Row(children: ratingsRow )
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
        automaticallyImplyLeading: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () {
          setState(() {
            Navigator.pushNamed(context, '/home');
          });
        }),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(children: foodWidgets)
      )
    );
  }

  void _foodInfoModal(context, Food currFood, List<Widget> ratingsRow) {
    const double nameFontSize = 25;
    const double nutritionFactsFontSize = 20;
    var simplifiedNutFacts = "";
    var rating = 3.0;

    for (var f in currFood.nutFacts){
      simplifiedNutFacts += f + "\n";
    }

    Widget reviewBlock(var review){
      return Container(
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.only(left:20, right: 20, top: 10, bottom: 10),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.black),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.grey[300],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: stars[(review['Rating']*2-1).round()] ),
            Text(review["Review"], overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: nutritionFactsFontSize, fontWeight: FontWeight.normal)),
            Text(review["Time"].toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: nutritionFactsFontSize, fontWeight: FontWeight.normal)),
          ],
        )
      );
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
              child: Row(children: ratingsRow )
            ),
            const Divider(height: 20,thickness: 1, indent: 5, endIndent: 5, color: Colors.black,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(simplifiedNutFacts, style: const TextStyle(
                  fontSize: nutritionFactsFontSize, fontWeight: FontWeight.normal)),
            ),
            const Divider(height: 10,thickness: 1, indent: 5, endIndent: 5, color: Colors.black,),
            // Form(
            //   key: _reviewKey,
            //   child: Column(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(top:0, bottom:8.0, right:8.0, left:8.0),
            //         child: TextFormField(
            //           decoration: const InputDecoration(
            //             icon: Icon(Icons.comment),
            //             labelText: 'Write a Review',
            //           ),
            //           validator: (value) {
            //             ///TODO Implement Review database push
            //             print("Review: ${value!}, Stars: $rating, Time Posted: ${DateTime.now().millisecondsSinceEpoch/86400000}");
            //           },
            //           keyboardType: TextInputType.multiline,
            //           maxLines: null,
            //         )
            //       ),
            //     ]
            //   )
            // ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 0.5,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                  onPressed: () async {
                    String? deviceId = await _getId();
                    print("DeviceID: $deviceId, Current Dining Hall: ${chosenHall.name} Current Food: ${currFood.name}, Stars: $rating, Time Posted: ${DateTime.now().millisecondsSinceEpoch/86400000}");

                    final url = Uri.parse('https://food-grind.herokuapp.com/postRating');
                    final headers = {"Content-type": "application/json"};
                    final json = '{"userId": $deviceId, "rating": ${rating.toString()}, "location": ${chosenHall.name}, "food": ${currFood.name}, "timePosted", ${DateTime.now().millisecondsSinceEpoch/86400000}}';
                    final response = await post(url, headers: headers, body: json);
                    print('Status code: ${response.statusCode}');
                    print('Body: ${response.body}');

                    // makePostRequest(deviceId, rating, currFood);
                    // if (_reviewKey.currentState!.validate()) {} ///TODO add back for Reviews
                  },
                  child: const Text('Submit'),
                )
            ),
            // const Divider(height: 20,thickness: 1, indent: 5, endIndent: 5, color: Colors.black,), ///TODO add back for Reviews
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Text("Reviews", style: TextStyle(
            //       fontSize: nameFontSize, fontWeight: FontWeight.bold)),
            // ),
            // for (var review in currFood.reviews) reviewBlock(review)
          ],
        )
      );
    });
  }
}

// Help and About Route
class HelpRoute extends StatelessWidget {
  const HelpRoute({Key? key}) : super(key: key);

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
  late var reviews;

  Food(this.name, this.image, this.nutFacts, this.labels, this.sumRatings, this.numRatings, this.reviews);
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
String routeAfterLoad = '/home';

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

List<List<Food>> diningHallMenus = [[],[],[],[]];

DiningHall cafeThree = DiningHall('Cafe 3', '', diningHallMenus[0]);
DiningHall clarkKerr = DiningHall('Clark Kerr', '', diningHallMenus[1]);
DiningHall crossroads = DiningHall('Crossroads', '', diningHallMenus[2]);
DiningHall foothill = DiningHall('Foothill', '', diningHallMenus[3]);

List<List<Widget>> ratingsTemp = [];

