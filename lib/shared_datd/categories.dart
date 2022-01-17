//
final allCategories = [
  Category(
    name: "Dite Coke",
    imagePath: "assets/images/beverages_images/diet_coke.png",
  ),
  Category(
    name: 'خضروات',
    imagePath: "assets/images/beverages_images/sprite.png",
  ),
  Category(
    name: 'فواكه',
    imagePath: "assets/images/beverages_images/apple_and_grape_juice.png",
  ),
  Category(
    name: 'خضروات',
    imagePath: "assets/images/beverages_images/orange_juice.png",
  ),
  Category(
    name: 'ورقيات',
    imagePath: "assets/images/beverages_images/coca_cola.png",
  ),
  Category(
    name: 'تمور',
    imagePath: "assets/images/beverages_images/pepsi.png",
  ),
];

class Category {
  final String name;
  final String imagePath;

  Category({
    required this.name,
    required this.imagePath,
  });
}
