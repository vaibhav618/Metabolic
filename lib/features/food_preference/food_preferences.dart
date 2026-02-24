import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'improve.dart'; // Add this line! Adjust the path if it's in a different folder.

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

  // Custom blue color from the design
  final Color primaryBlue = const Color(0xFF308BF9);

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
              Text(
                'Tell us your food preferences',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF252525),
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -2.04,
                ),
              ),
              const SizedBox(height: 35),

              // Scrollable content area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dietary Preferences Section
                      Text(
                        'Choose dietary preferences',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF535359),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.10,
                          letterSpacing: -0.30,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Diet Options List
                      ..._dietOptions.map((option) => _buildDietOption(option)),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ImproveScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF308BF9),
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
              style: GoogleFonts.poppins(
                color: isSelected ? primaryBlue : const Color(0xFF252525),
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.30,
                letterSpacing: -0.30,
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
                        width: 18,
                        height: 18,
                        decoration: const ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.50, -0.00),
                            end: Alignment(0.50, 1.00),
                            colors: [Color(0xFF308BF9), Color(0xFF8EC1FF)],
                          ),
                          shape: OvalBorder(),
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
}
