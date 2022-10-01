# foodgrind

An app that puts all of the information about Berkeley Dining halls in one place 
and allows students to rate different Dining halls every day.

## Getting Started

<---- Objects ---->

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
  late double dailyRating;
  late List menu;
  late List location;
  late String direction;

  DiningHall(this.name, this.image, this.location, this.direction);

  double getDistance(List currLocation) {
    assert(currLocation.length == 2);
    return sqrt(pow((location[0] - currLocation[0]), 2) +
        pow((location[1] - currLocation[1]), 2));
  }
}

class Review {
  late double rating;
  late List meal;
  late String comment;

  Review(this.rating, this.meal, this.comment);
}