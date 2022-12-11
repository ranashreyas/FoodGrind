// "Quinoa Pilaf": [
//   "Calories (kcal): 214.73",
//   "Total Lipid/Fat (g): 9.14",
//   "Saturated fatty acid (g): 1.21",
//   "Trans Fat (g): N/A",
//   "Cholesterol (mg): 0",
//   "Sodium (mg): 2.89",
//   "Carbohydrate (g): 27.36",
//   "Total Dietary Fiber (g): 3.02",
//   "Sugar (g): 0.01",
//   "Protein (g): 6.04",
//   "Vitamin A (iu): 101.47",
//   "Vitamin C (mg): 1.51",
//   "Calcium (mg): 21.62",
//   "Iron (mg): 2.05",
//   "Water (g): 39.27",
//   "Ash (g): 1.04",
//   "Vitamin A (rae): N/A",
//   "Potassium (mg): 245.69",
//   "Vitamin D(iu): 0",
//   "Carbon Footprint (kg CO2): 0.22",
//   "Pasta, Dinner, Front plate, etc....."
// ]

import 'dart:convert';
import 'dart:core';
import 'dart:io' show HttpHeaders, Platform;
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:device_info/device_info.dart';
// import 'package:platform_device_id/platform_device_id.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';



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

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm').format(now);
    int minPassedInDay = int.parse(formattedDate.split(':')[0])*60 + int.parse(formattedDate.split(':')[1]);
    if(minPassedInDay > 1260){
      hallFoodStateString = 'CLOSED till 7:30 a.m.';
      hallFoodState = 2;
    } else if(minPassedInDay > 990){
      hallFoodStateString = 'DINNER: 4:30 p.m. - 9:00 p.m.';
      hallFoodState = 2;
    } else if(minPassedInDay > 930){
      hallFoodStateString = 'CLOSED till 4:30 p.m.';
      hallFoodState = 2;
    } else if(minPassedInDay > 660){
      hallFoodStateString = 'LUNCH: 11:00 a.m. - 3:00 p.m.';
      hallFoodState = 1;
    } else if(minPassedInDay > 600){
      hallFoodStateString = 'CLOSED till 11:00 a.m.';
      hallFoodState = 1;
    } else if(minPassedInDay > 450){
      hallFoodStateString = 'BREAKFAST: 7:30 a.m. - 10:00 a.m.';
      hallFoodState = 0;
    } else {
      hallFoodStateString = 'CLOSED till 7:30 a.m.';
      hallFoodState = 0;
    }
    print("$hallFoodStateString $hallFoodState");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance(); // Handles first install, send to database
      bool? firstTime = prefs.getBool('first_time');

      if (firstTime != null && !firstTime) {// Not first time

      } else {// First time
        // print("First Install");
        prefs.setBool('first_time', false);
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        String? id;
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          id = androidInfo.id;
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          id = iosInfo.identifierForVendor;
        }

        final http.Response response = await http.post(
          Uri.parse('https://foodgrindapi.herokuapp.com/postId/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'userId': id!,
          }),
        );
        print('Status code: ${response.statusCode}');
        // print('Body: ${response.body}');
      }

      var allFoodResponse = await http.get(
          Uri.parse('https://foodgrindapi.herokuapp.com/getAllNuts/'));
      var allTodaysFoodResponse = await http.get(
          Uri.parse('https://foodgrindapi.herokuapp.com/getAllFoods/'));
      var allFoodRatingsResponse = await http.get(
          Uri.parse('https://foodgrindapi.herokuapp.com/getAllRatings/'));
      var quoteOfDayResponse = await http.get(Uri.parse('https://foodgrindapi.herokuapp.com/getQODD/'));


      var allFood = jsonDecode(allFoodResponse.body)['NutFacts'];
      var allTodaysFood = jsonDecode(allTodaysFoodResponse.body);
      dailyQuote = jsonDecode(quoteOfDayResponse.body)["QODD"];
      // var openTimes = jsonDecode(allTimesResponse.body)['times'];

      // TODO comment out
      // allTodaysFood = jsonDecode('{"AllFoods": [[{"eggs":["Scrambled Eggs","Scrambled Eggs and Mushrooms"],"stuff":["Polenta with Roasted Tomatoes and Mushrooms","Pan-fried Potatoes and Peppers","Steamed Cauliflower Florets","White Rice","Brown Rice"], "Bar": ["Rolled Oatmeal","Bagel Bar","Yogurt Parfait Bar","Assorted Mini Muffins","Assorted Mini Danishes"]}]]}');
      // hallFoodState = 0;

      var allFoodRatings = jsonDecode(
          allFoodRatingsResponse.body)['AllRatings'];

      for (var k in allFood.keys) { //Initializes complete dictionary of foods

        List<Widget> reviewRow = stars[((allFoodRatings[k][0]>0)?allFoodRatings[k][0]*2 - 1:10).round()]
            .map((element)=>element).toList(); //Copies the map, not creates an instance
        reviewRow.insert(reviewRow.length, Text(((allFoodRatings[k][1]>0)?allFoodRatings[k][1]:0).toString()) );

        allFoodMap[k] = Food(
            k,//Food name
            '',//image???
            allFood[k],//nutrition facts
            "", //tags???
            (allFoodRatings.containsKey(k) && allFoodRatings[k][1] > 0)? (allFoodRatings[k][0] * allFoodRatings[k][1].toDouble()).round():0,//sum ratings
            (allFoodRatings.containsKey(k) && allFoodRatings[k][1] > 0)? allFoodRatings[k][1]:0,// num ratings
            reviewRow,
            []); // reviews
      }
      for (var i = 0; i < allTodaysFood['AllFoods'].length; i++) {
        unsortedHalls[i].sumRatings = 0;
        unsortedHalls[i].numRatings = 0;
      }
      for (var i = 0; i < allTodaysFood['AllFoods'].length; i++) {
        // print(allTodaysFood['AllFoods'][i][hallFoodState]);
        for (var k in allTodaysFood['AllFoods'][i][hallFoodState].keys) { //change index 0, 1, 2 for b, l, d
          for(var f in allTodaysFood['AllFoods'][i][hallFoodState][k]){
            if(!diningHallMenus[i].containsKey(k)){
              diningHallMenus[i][k] = [];
            }
            if (allFoodMap[f] != null) {
              diningHallMenus[i][k]?.add(Food(allFoodMap[f].name, allFoodMap[f].image, allFoodMap[f].nutFacts, allFoodMap[f].label, allFoodMap[f].sumRatings, allFoodMap[f].numRatings, allFoodMap[f].reviewRow, allFoodMap[f].reviews));

              diningHallMenus[i][k]?.sort((a, b) => (b.sumRatings~/(b.numRatings+0.000001)).compareTo(a.sumRatings~/(a.numRatings+0.000001)));

              int foodSumRating = allFoodMap[f].sumRatings;
              int foodNumRating = allFoodMap[f].numRatings;
              unsortedHalls[i].sumRatings += foodSumRating;
              unsortedHalls[i].numRatings += foodNumRating;
            } else { // If this is a special menu item or something, and its nutritional facts do not exist
              print(f);
              List<Widget> ratingsRow = stars[9]
                  .map((element)=>element).toList(); //Copies the map, not creates an instance
              ratingsRow.insert(ratingsRow.length, const Text("1"));

              diningHallMenus[i][k]?.add(Food(
                  f,
                  '',
                  ["Nutrition Facts Not Available"],
                  "other",
                  5,
                  1,
                  ratingsRow,
                  []));
              unsortedHalls[i].sumRatings += 5;
              unsortedHalls[i].numRatings += 1;
            }
          }
        }
      }

      cafeThree.menu = diningHallMenus[0];
      clarkKerr.menu = diningHallMenus[1];
      crossroads.menu = diningHallMenus[2];
      foothill.menu = diningHallMenus[3];

      halls = sortHalls(unsortedHalls);
    } catch (e){
      print(e);
      dailyQuote = "API Error! Today's food not updated!";
    }
    setState(() {
      Navigator.pushNamedAndRemoveUntil(context, routeAfterLoad, (route) => false);
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
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
      diningHallMenus = [{}, {}, {}, {}];
      unsortedHalls = [cafeThree, clarkKerr, crossroads, foothill];
      halls = [];
      allFoodMap = {};
      dailyQuote = 'Be the first one to leave a comment today!';
      Navigator.pushNamedAndRemoveUntil(context, '/loading', (route) => false);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    const double nameButtonFontSize = 25;
    const double openButtonFontSize = 15;

    Widget homeBlock(DiningHall hall) {

      List<Widget> reviewRowHall = (((hall.sumRatings/(hall.numRatings+0.0000001)*2 - 1).round()<0)?stars[10]:stars[(hall.sumRatings/(hall.numRatings+0.0000001)*2 - 1).round()]).map((element)=>element).toList();
      reviewRowHall.insert(reviewRowHall.length, Text(hall.numRatings.toString()));

      return Container(
        margin: const EdgeInsets.only(left: 7, right: 7, top: 7),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
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
                  child: Row(children: reviewRowHall)
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                alignment: const Alignment(-1, 0),
                child: Text('$hallFoodStateString',
                    style: TextStyle(
                        fontSize: openButtonFontSize,
                        fontWeight: FontWeight.w700,
                        color: (hallFoodStateString.contains('CLOSED')) ? Colors.red : Colors.green)),
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
      color: Colors.grey[800],
      height: 60,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Text(
        dailyQuote,
        style: const TextStyle(fontSize: 15, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    ));


    return Scaffold(
      backgroundColor: Colors.grey[200],
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

  Map<String, bool> dropDownStates = {};

  late List<Widget> entireDropdownWidgets = [];
  late List<List<Widget>> stationWidgets;

  late List<Widget> reviewWidgets;
  final _quoteKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print("${chosenHall.name} ${chosenHall.sumRatings} ${chosenHall.numRatings}");
  }

  Future onRefresh() async{
    routeAfterLoad = '/food';
    setState(() {
      diningHallMenus = [{}, {}, {}, {}];
      unsortedHalls = [cafeThree, clarkKerr, crossroads, foothill];
      halls = [];
      allFoodMap = {};
      dailyQuote = 'Be the first one to leave a comment today!';
      // Navigator.pushNamed(context, '/loading');
      Navigator.pushNamedAndRemoveUntil(context, '/loading', (route) => false);
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

  @override
  Widget build(BuildContext context) {
    const double menuItemFontSize = 15;
    const double dropdownFontSize = 25;

    Widget foodBlock(Food currFood, String tag) {
      // print(currFood.name + " " + currFood.reviewRow.toString());
      return Container(
          margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
          padding: const EdgeInsets.only(
              left: 20, right: 20, top: 7, bottom: 7),
          decoration: BoxDecoration(
            border: (debug)?Border.all(color: Colors.black):Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Colors.white,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                    decoration:  BoxDecoration(
                      border: (debug)?Border.all(color: Colors.black):Border.all(color: Colors.transparent),
                      color: Colors.white,
                    ),
                    child: Flexible(child: Text(
                    currFood.name,
                    style: const TextStyle(fontSize: menuItemFontSize,
                    fontWeight: FontWeight.normal)),)
                    // child: Text(
                    //     currFood.name, overflow: TextOverflow.ellipsis,
                    //     style: const TextStyle(fontSize: menuItemFontSize,
                    //         fontWeight: FontWeight.normal)),
                  )
              ),
              Container(
                decoration:  BoxDecoration(
                  border: (debug)?Border.all(color: Colors.black):Border.all(color: Colors.transparent),
                  color: Colors.white,
                ),
                child:IconButton(
                  icon: const Icon(Icons.fastfood),
                  iconSize: 30,
                  color: Colors.black,
                  onPressed: () {
                    _foodNutFactsModal(context, currFood);
                  },
                ),
              ),
              Container(
                decoration:  BoxDecoration(
                  border: (debug)?Border.all(color: Colors.black):Border.all(color: Colors.transparent),
                  color: Colors.white,
                ),
                child:IconButton(
                  icon: const Icon(Icons.rate_review),
                  iconSize: 30,
                  color: Colors.black,
                  onPressed: () {
                    _foodReviewModal(context, currFood);
                  },
                ),
              ),
              Center(
                  child: Container(
                      decoration: BoxDecoration(
                        border: (debug)?Border.all(color: Colors.black):Border.all(color: Colors.transparent),
                        color: Colors.white,
                      ),
                      child: Row(children: currFood.reviewRow)
                    // Text("10 ${stars[currFood.historicalRating - 1]}", style: const TextStyle(fontSize: menuItemFontSize, fontWeight: FontWeight.normal)),
                  )
              )
            ],
          )
      );
    }
    
    Widget dropdownBlock(String category){
      return GestureDetector(
          onTap: () {
            setState(() {
              (dropDownStates[category]!)?(dropDownStates[category] = false):(dropDownStates[category] = true);
              entireDropdownWidgets = [];
              // Navigator.pushNamed(context, '/food');
            });
          },
          child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 20),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: Colors.grey[400],
              ),
              child: Row(
                children: <Widget>[
                  (dropDownStates[category]!)?const Icon(Icons.keyboard_arrow_down):const Icon(Icons.keyboard_arrow_up),
                  Expanded(
                      child: Container(
                        decoration:  BoxDecoration(
                          color: Colors.grey[400],
                        ),
                        child: Text(
                            category.toUpperCase(), overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: dropdownFontSize,
                                fontWeight: FontWeight.bold)),
                      )
                  ),
                ],
              )
          )
      );
    }

    for (var k in chosenHall.menu.keys){
      if(!dropDownStates.containsKey(k)){
        dropDownStates[k] = true;
      }

      entireDropdownWidgets.add(dropdownBlock(k)); // creates the dropdown block

      (dropDownStates[k]!)?entireDropdownWidgets.addAll(<Widget>[ //adds the menu that should be shown or not
        for (Food foodItem in chosenHall.menu[k]!) foodBlock(foodItem, k)
      ]):entireDropdownWidgets.add(Container());
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("${chosenHall.name} - ${hallFoodStateString.split(" ")[0]}"),
        titleTextStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
        child: ListView(children: entireDropdownWidgets)
      )
    );
  }

  void _foodNutFactsModal(context, Food currFood) {
    const double nameFontSize = 25;
    const double nutritionFactsFontSize = 20;
    var simplifiedNutFacts = "";

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

            const Divider(height: 20,thickness: 1, indent: 5, endIndent: 5, color: Colors.black,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(simplifiedNutFacts, style: const TextStyle(
                  fontSize: nutritionFactsFontSize, fontWeight: FontWeight.normal)),
            ),
          ],
        )
      );
    });
  }

  void _foodReviewModal(context, Food currFood) {
    const double nameFontSize = 25;
    const double nutritionFactsFontSize = 20;
    var rating = 3.0;
    String quote = "Empty Quote";
    String nickname = "Anonymous Bear";

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
                  child: Row(children: currFood.reviewRow )
              ),
              const Divider(height: 10,thickness: 1, indent: 5, endIndent: 5, color: Colors.black,),

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
                      var ratingToPost = jsonEncode(<String, String>{
                        "userId": deviceId!,
                        "rating": rating.toString(),
                        "location": chosenHall.name,
                        "food": currFood.name,
                        "timePosted": (DateTime.now().millisecondsSinceEpoch/86400000).toString()
                      });
                      // print(ratingToPost);

                      final http.Response response = await http.post(
                        Uri.parse('https://foodgrindapi.herokuapp.com/postRating/'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: ratingToPost,
                      );
                      print(response.statusCode);
                      print(response.body);
                      // if (_reviewKey.currentState!.validate()) {} ///TODO add back for Reviews
                      Navigator.pop(context);
                      routeAfterLoad = "/food";
                      setState(() {
                        diningHallMenus = [{}, {}, {}, {}];
                        unsortedHalls =
                        [cafeThree, clarkKerr, crossroads, foothill];
                        halls = [];
                        allFoodMap = {};
                        dailyQuote =
                        'Be the first one to leave a comment today!';
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/loading", (route) => false);
                      });
                    },
                    child: const Text('Submit'),
                  )
              ),
              const Divider(height: 20,thickness: 1, indent: 5, endIndent: 5, color: Colors.black),
              Form(
                  key: _quoteKey,
                  child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top:0, bottom:8.0, right:8.0, left:8.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                icon: Icon(Icons.comment),
                                labelText: 'Write a Quote of the Day!',
                              ),
                              validator: (value) {
                                // print("Quote: ${value!}");
                                quote = value!;
                                if (quote == "") quote = "Empty Quote";
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top:0, bottom:8.0, right:8.0, left:8.0),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                icon: Icon(Icons.person),
                                labelText: 'Nickname',
                              ),
                              validator: (value) {
                                nickname = value!;
                                if (nickname == "") nickname = "Anonymous Bear";
                              },
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_quoteKey.currentState!.validate()) {} ///TODO add back for Reviews
                                String? deviceId = await _getId();
                                var quoteOfDayData = jsonEncode(<String, String>{
                                  "userId": deviceId!,
                                  "quote": quote,
                                  "nickName": nickname,
                                  "timePosted": (DateTime.now().millisecondsSinceEpoch/86400000).toString()
                                });

                                final http.Response response = await http.post(
                                  Uri.parse('https://foodgrindapi.herokuapp.com/postQuote/'),
                                  headers: <String, String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                  },
                                  body: quoteOfDayData,
                                );
                                print(response.statusCode);
                                print(response.body);

                                Navigator.pop(context);
                                routeAfterLoad = "/food";
                                setState(() {
                                  diningHallMenus = [{}, {}, {}, {}];
                                  unsortedHalls =
                                  [cafeThree, clarkKerr, crossroads, foothill];
                                  halls = [];
                                  allFoodMap = {};
                                  dailyQuote =
                                  'Be the first one to leave a comment today!';
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "/loading", (route) => false);
                                });
                              },
                              child: const Text('Submit (optional)'),
                            )
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).viewInsets.bottom,
                        ),
                      ]
                  )
              ),

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
        margin: const EdgeInsets.all(20),
        child: Center(
            child: Column(
                children: [
                  Image.asset('Assets/images/FOODGRIND.png', height: 283, width: 150),
                  Container(height: 20,),
                  const Text('About us: FoodGrind created by Berkeley students who are too lazy to look up the menu at every dining hall to see whats not shit. It was created by Nihal Boina and Shreyas Rana.', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700), textAlign: TextAlign.center)
                ],
            )
        )
      )
    );
  }
}

class Food {
  late String name, image;
  late List nutFacts;
  late String label;
  late int sumRatings = 0;
  late int numRatings = 0;
  late var reviews;
  late List<Widget> reviewRow;

  Food(this.name, this.image, this.nutFacts, this.label, this.sumRatings, this.numRatings, this.reviewRow, this.reviews);
}

class DiningHall {
  late String name, image;
  late int sumRatings = 0;
  late int numRatings = 0;
  late Map<String, List<Food>> menu;
  late List openTimes = [[], [], [], [], [], []];
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
  closedHalls.sort((a, b) => (b.sumRatings~/(b.numRatings+0.0000001)).compareTo(a.sumRatings~/(a.numRatings+0.0000001)));
  openHalls.sort((a, b) => (b.sumRatings~/(b.numRatings+0.0000001)).compareTo(a.sumRatings~/(a.numRatings+0.0000001)));
  return openHalls + closedHalls;
}

String dailyQuote = '-';
String routeAfterLoad = '/home';

DiningHall chosenHall = cafeThree;
String hallFoodStateString = '-';
int hallFoodState = 0;

List<DiningHall> unsortedHalls = [cafeThree, clarkKerr, crossroads, foothill];
List<DiningHall> halls = [];
var stars = [
  <Widget>[const Icon(Icons.star_half, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20)],
  <Widget>[const Icon(Icons.star, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20)], //1 star
  <Widget>[const Icon(Icons.star, size: 20), const Icon(Icons.star_half, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20)],
  <Widget>[const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20)], // 2 star
  <Widget>[const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star_half, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20)],
  <Widget>[const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20)], // 3 star
  <Widget>[const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star_half, size: 20), const Icon(Icons.star_border, size: 20)],
  <Widget>[const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star_border, size: 20)],//4 star
  <Widget>[const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star_half, size: 20)],
  <Widget>[const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20), const Icon(Icons.star, size: 20)], //5 star
  <Widget>[const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20), const Icon(Icons.star_border, size: 20)],
];

Map allFoodMap = {};

List<Map<String, List<Food>>> diningHallMenus = [{}, {}, {}, {}];

DiningHall cafeThree = DiningHall('Cafe 3', '', diningHallMenus[0]);
DiningHall clarkKerr = DiningHall('Clark Kerr', '', diningHallMenus[1]);
DiningHall crossroads = DiningHall('Crossroads', '', diningHallMenus[2]);
DiningHall foothill = DiningHall('Foothill', '', diningHallMenus[3]);

bool debug = false;