
import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/food_api_service.dart';
import '../utils/food_rules.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final FoodApiService apiService = FoodApiService();

  String selectedCategory = 'Vegetables';
  String selectedLocation = 'Refrigerator';

  DateTime storedDate = DateTime.now();
  DateTime useByDate = DateTime.now().add(const Duration(days: 3));

  bool isLoading = false;

  Future<void> selectStoredDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: storedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && mounted) {
      setState(() {
        storedDate = pickedDate;
        if (useByDate.isBefore(storedDate)) {
          useByDate = storedDate;
        }
      });
    }
  }

  Future<void> selectUseByDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: useByDate.isBefore(storedDate) ? storedDate : useByDate,
      firstDate: storedDate,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && mounted) {
      setState(() {
        useByDate = pickedDate;
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> saveFood() async {
    FocusScope.of(context).unfocus();

    if (isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    final dateError = FoodRules.validateDates(storedDate, useByDate);

    if (dateError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(dateError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final food = FoodItem(
        name: nameController.text.trim(),
        category: selectedCategory,
        quantity: int.parse(quantityController.text.trim()),
        storedDate: storedDate,
        useByDate: useByDate,
        location: selectedLocation,
      );

      await apiService.addFood(food);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save food: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text(
          'Add Food',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Food Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Example: Chicken',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: FoodRules.validateName,
              ),
              const SizedBox(height: 20),
              const Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Vegetables', child: Text('Vegetables')),
                  DropdownMenuItem(value: 'Meat', child: Text('Meat')),
                  DropdownMenuItem(value: 'Fruit', child: Text('Fruit')),
                  DropdownMenuItem(value: 'Dairy', child: Text('Dairy')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedCategory = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Quantity',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Example: 2',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: FoodRules.validateQuantity,
              ),
              const SizedBox(height: 20),
              const Text(
                'Stored Date',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: selectStoredDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatDate(storedDate)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Use-by Date',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: selectUseByDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatDate(useByDate)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Location',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedLocation,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'Refrigerator', child: Text('Refrigerator')),
                  DropdownMenuItem(value: 'Freezer', child: Text('Freezer')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedLocation = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveFood,
                  child: isLoading
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Saving...'),
                          ],
                        )
                      : const Text(
                          'Save Food',
                          style: TextStyle(fontSize: 17),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
