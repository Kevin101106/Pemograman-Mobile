import 'package:flutter/material.dart';
import '../food_store.dart';
import '../models/food_item.dart';
import 'add_food_screen.dart';
import 'food_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'All';
  String selectedLocation = 'All';
  bool sortAscending = true;

  final List<String> categories = [
    'All',
    'Vegetables',
    'Meat',
    'Fruit',
    'Dairy',
    'Other',
  ];

  final List<String> locations = [
    'All',
    'Refrigerator',
    'Freezer',
    'Other',
  ];

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return months[month - 1];
  }

  String foodStatus(FoodItem food) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final expiryDate = DateTime(
      food.useByDate.year,
      food.useByDate.month,
      food.useByDate.day,
    );

    if (expiryDate.isBefore(todayDate)) {
      return 'Melewati Batas';
    }

    if (expiryDate.difference(todayDate).inDays <= 2) {
      return 'Segera Digunakan';
    }

    return 'Masih Segar';
  }

  Color statusColor(FoodItem food) {
    switch (foodStatus(food)) {
      case 'Melewati Batas':
        return Colors.red;
      case 'Segera Digunakan':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  IconData categoryIcon(String category) {
    switch (category) {
      case 'Vegetables':
        return Icons.eco;
      case 'Meat':
        return Icons.set_meal;
      case 'Fruit':
        return Icons.apple;
      case 'Dairy':
        return Icons.local_drink;
      default:
        return Icons.restaurant;
    }
  }

  Future<void> openAddFood() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddFoodScreen(),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> openFoodDetail(FoodItem food) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodDetailScreen(food: food),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  List<FoodItem> get filteredFoods {
    final query = searchController.text.trim().toLowerCase();

    final result = FoodStore.foods.where((food) {
      final matchesName = food.name.toLowerCase().contains(query);
      final matchesCategory =
          selectedCategory == 'All' || food.category == selectedCategory;
      final matchesLocation =
          selectedLocation == 'All' || food.location == selectedLocation;

      return matchesName && matchesCategory && matchesLocation;
    }).toList();

    result.sort((a, b) {
      final comparison = a.useByDate.compareTo(b.useByDate);
      return sortAscending ? comparison : -comparison;
    });

    return result;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foods = FoodStore.foods;
    final visibleFoods = filteredFoods;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text(
          'FreshTrack 🥬',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello, User! 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Keep track of your food and avoid food waste.',
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Food',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (foods.isNotEmpty) ...[
              TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search food name...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear),
                        ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedLocation,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      items: locations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedLocation = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${visibleFoods.length} food item(s)',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        sortAscending = !sortAscending;
                      });
                    },
                    icon: Icon(
                      sortAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                    ),
                    label: Text(
                      sortAscending
                          ? 'Earliest use-by'
                          : 'Latest use-by',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
            if (foods.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.eco_outlined,
                        size: 56,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No food added yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Start tracking your food to keep it fresh and reduce food waste.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: openAddFood,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Your First Food'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (visibleFoods.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 48,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No matching food found',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Try another search or change the filters.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ...visibleFoods.map(
                (food) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => openFoodDetail(food),
                    child: _foodCard(food),
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: openAddFood,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _foodCard(FoodItem food) {
    final status = foodStatus(food);
    final color = statusColor(food);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                categoryIcon(food.category),
                color: Colors.green,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Quantity: ${food.quantity}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Use by: ${formatDate(food.useByDate)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Location: ${food.location}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
