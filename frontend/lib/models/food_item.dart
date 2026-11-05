
class FoodItem {
  final int? id;
  final String name;
  final String category;
  final int quantity;
  final DateTime storedDate;
  final DateTime useByDate;
  final String location;

  const FoodItem({
    this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.storedDate,
    required this.useByDate,
    required this.location,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as int?,
      name: json['name'] as String,
      category: json['category'] as String,
      quantity: (json['quantity'] as num).toInt(),
      storedDate: DateTime.parse(json['stored_date']),
      useByDate: DateTime.parse(json['use_by_date']),
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'quantity': quantity,
      'stored_date': storedDate.toIso8601String().split('T').first,
      'use_by_date': useByDate.toIso8601String().split('T').first,
      'location': location,
    };
  }
}
