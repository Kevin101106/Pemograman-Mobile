
import 'package:flutter/material.dart';
import '../food_store.dart';
import '../models/food_item.dart';
import 'edit_food_screen.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem? food;

  const FoodDetailScreen({super.key, this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  late FoodItem? currentFood;

  @override
  void initState() {
    super.initState();
    currentFood = widget.food;
  }

  String formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  String getStatus(DateTime useByDate) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final expiryDate = DateTime(
      useByDate.year,
      useByDate.month,
      useByDate.day,
    );
    final difference = expiryDate.difference(todayDate).inDays;

    if (difference < 0) return 'Melewati Batas';
    if (difference <= 2) return 'Segera Digunakan';
    return 'Masih Segar';
  }

  Color getStatusColor(String status) {
    if (status == 'Melewati Batas') return Colors.red;
    if (status == 'Segera Digunakan') return Colors.orange;
    return Colors.green;
  }

  Future<void> editFood() async {
    final food = currentFood;
    if (food == null) return;

    final result = await Navigator.push<FoodItem>(
      context,
      MaterialPageRoute(
        builder: (context) => EditFoodScreen(food: food),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        currentFood = result;
      });
    }
  }

  Future<void> deleteFood() async {
    final food = currentFood;
    if (food == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Food'),
        content: Text('Hapus ${food.name} dari daftar makanan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      FoodStore.foods.remove(food);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final food = currentFood;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text(
          'Food Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: food == null
          ? const Center(child: Text('Food not found.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        size: 55,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      food.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      getStatus(food.useByDate),
                      style: TextStyle(
                        color: getStatusColor(getStatus(food.useByDate)),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _detailItem(
                    icon: Icons.category,
                    title: 'Category',
                    value: food.category,
                  ),
                  _detailItem(
                    icon: Icons.inventory_2,
                    title: 'Quantity',
                    value: food.quantity.toString(),
                  ),
                  _detailItem(
                    icon: Icons.calendar_today,
                    title: 'Stored Date',
                    value: formatDate(food.storedDate),
                  ),
                  _detailItem(
                    icon: Icons.event,
                    title: 'Use-by Date',
                    value: formatDate(food.useByDate),
                  ),
                  _detailItem(
                    icon: Icons.kitchen,
                    title: 'Location',
                    value: food.location,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: editFood,
                      icon: const Icon(Icons.edit),
                      label: const Text(
                        'Edit Food',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: deleteFood,
                      icon: const Icon(Icons.delete),
                      label: const Text(
                        'Delete Food',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _detailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
