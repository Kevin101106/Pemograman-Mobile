
import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/food_api_service.dart';
import '../utils/food_rules.dart';

class EditFoodScreen extends StatefulWidget {
  final FoodItem food;

  const EditFoodScreen({super.key, required this.food});

  @override
  State<EditFoodScreen> createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  late final TextEditingController nameController;
  late final TextEditingController quantityController;
  late String selectedCategory;
  late String selectedLocation;
  late DateTime storedDate;
  late DateTime useByDate;
  bool isSaving = false;

  final FoodApiService apiService = FoodApiService();

  final List<String> categories = [
    'Vegetables',
    'Meat',
    'Fruit',
    'Dairy',
    'Other',
  ];

  final List<String> locations = [
    'Refrigerator',
    'Freezer',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.food.name);
    quantityController = TextEditingController(
      text: widget.food.quantity.toString(),
    );
    selectedCategory = widget.food.category;
    selectedLocation = widget.food.location;
    storedDate = widget.food.storedDate;
    useByDate = widget.food.useByDate;

    if (!categories.contains(selectedCategory)) {
      categories.add(selectedCategory);
    }

    if (!locations.contains(selectedLocation)) {
      locations.add(selectedLocation);
    }
  }

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
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> saveChanges() async {
    final nameError = FoodRules.validateName(nameController.text);
    final quantityError = FoodRules.validateQuantity(quantityController.text);
    final dateError = FoodRules.validateDates(storedDate, useByDate);

    if (nameError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(nameError)),
      );
      return;
    }

    if (quantityError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(quantityError)),
      );
      return;
    }

    if (dateError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(dateError)),
      );
      return;
    }

    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    final updatedFood = FoodItem(
      id: widget.food.id,
      name: nameController.text.trim(),
      category: selectedCategory,
      quantity: int.parse(quantityController.text.trim()),
      storedDate: storedDate,
      useByDate: useByDate,
      location: selectedLocation,
    );

    try {
      final savedFood = await apiService.updateFood(updatedFood);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food updated successfully'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, savedFood);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update food: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
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
          'Edit Food',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Food Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Example: Chicken',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
              items: categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
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
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Example: 2',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
              items: locations
                  .map((location) => DropdownMenuItem(
                        value: location,
                        child: Text(location),
                      ))
                  .toList(),
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
                onPressed: isSaving ? null : saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 17),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
