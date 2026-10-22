
class FoodItem {
  final String name;
  final String category;
  final int quantity;
  final DateTime storedDate;
  final DateTime useByDate;
  final String location;

  const FoodItem({
    required this.name,
    required this.category,
    required this.quantity,
    required this.storedDate,
    required this.useByDate,
    required this.location,
  });
}
