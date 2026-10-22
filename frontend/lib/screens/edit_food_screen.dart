
import 'package:flutter/material.dart';
import '../food_store.dart';
import '../models/food_item.dart';

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

    if (pickedDate != null) {
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

    if (pickedDate != null) {
      setState(() {
        useByDate = pickedDate;
      });
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void saveChanges() {
    final name = nameController.text.trim();
    final quantity = int.tryParse(quantityController.text.trim());

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food name is required.')),
      );
      return;
    }

    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity must be a whole number greater than 0.')),
      );
      return;
    }

    if (useByDate.isBefore(storedDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Use-by date cannot be before stored date.')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final updatedFood = FoodItem(
      name: name,
      category: selectedCategory,
      quantity: quantity,
      storedDate: storedDate,
      useByDate: useByDate,
      location: selectedLocation,
    );

    final index = FoodStore.foods.indexOf(widget.food);

    if (index != -1) {
      FoodStore.foods[index] = updatedFood;
    }

    Navigator.pop(context, updatedFood);
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
              value: selectedCategory,
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
              value: selectedLocation,
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
