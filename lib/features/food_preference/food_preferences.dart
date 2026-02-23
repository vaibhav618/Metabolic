import 'package:flutter/material.dart';

class FoodPreferancesScreen extends StatefulWidget {
  const FoodPreferancesScreen({super.key});

  @override
  State<FoodPreferancesScreen> createState() => _FoodPreferancesScreenState();
}

class _FoodPreferancesScreenState extends State<FoodPreferancesScreen> {
  // State for selected dietary preference
  String _selectedDiet = 'Only Vegetarian';

  // List of dietary options based on the UI
  final List<String> _dietOptions = [
    'No dietary preferences',
    'Only Vegetarian',
    'Non-vegetarian',
    'Vegan',
    'Pescatarian(Only fish)',
  ];

  // State for selected cuisines
  final List<String> _selectedCuisines = [
    'Location Based',
    'Indian',
    'Mexican',
  ];

  // Custom blue color from the design
  final Color primaryBlue = const Color(0xFF5284FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const SizedBox(height: 16),
              const Text(
                'Tell us your food\npreferences',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  letterSpacing: -0.5,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 40),

              // Scrollable content area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dietary Preferences Section
                      const Text(
                        'Choose dietary preferences',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5A5A5A),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Diet Options List
                      ..._dietOptions
                          .map((option) => _buildDietOption(option))
                          .toList(),

                      const SizedBox(height: 32),

                      // Cuisine Section
                      const Text(
                        'Choose cuisine',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5A5A5A),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Search TextField
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search cuisine',
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryBlue),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Selected Cuisine Chips
                      Wrap(
                        spacing: 12.0,
                        runSpacing: 12.0,
                        children: _selectedCuisines.map((cuisine) {
                          return _buildCuisineChip(cuisine);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation Area
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  IconButton(
                    onPressed: () {
                      // Handle back action
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),

                  // Next/Forward Button
                  InkWell(
                    onTap: () {
                      // Handle next action
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryBlue,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom widget for the radio-like selection to match the specific styling
  Widget _buildDietOption(String title) {
    bool isSelected = _selectedDiet == title;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedDiet = title;
        });
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? primaryBlue : const Color(0xFF2D2D2D),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryBlue : Colors.black87,
                  width: 1.0,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryBlue,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // Custom chip widget to exactly match the outlined style with cross
  Widget _buildCuisineChip(String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: primaryBlue, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(color: primaryBlue, fontSize: 14)),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              setState(() {
                _selectedCuisines.remove(label);
              });
            },
            child: Icon(Icons.close, size: 16, color: primaryBlue),
          ),
        ],
      ),
    );
  }
}
