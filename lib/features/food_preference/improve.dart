import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart'; // 1. Added this import

class ImproveScreen extends StatefulWidget {
  const ImproveScreen({super.key});

  @override
  State<ImproveScreen> createState() => _ImproveScreenState();
}

class _ImproveScreenState extends State<ImproveScreen> {
  // State for selected goal
  String _selectedGoal = 'Weight Loss';

  // Custom blue color from the design
  final Color primaryBlue = const Color(0xFF4A85F6);

  // Data list for the options
  final List<Map<String, dynamic>> _goalOptions = [
    {
      'title': 'Weight Loss',
      'subtitle': 'Support healthy weight reduction through better metabolism.',
      'iconPath': 'assets/loss.svg',
      'iconColor': const Color(0xFF4A85F6), // Blue
    },
    {
      'title': 'Weight Gain',
      'subtitle': 'Support healthy weight gain through better metabolism.',
      'iconPath': 'assets/gain.svg',
      'iconColor': const Color(0xFF5BB26F), // Green
    },
    {
      'title': 'Muscle Gain',
      'subtitle': 'Support healthy muscle gain through better metabolism.',
      'iconPath': 'assets/body.svg',
      'iconColor': const Color(0xFFEAA03B), // Orange/Yellow
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          // CHANGED: Reduced horizontal padding from 24.0 to 16.0 to make everything wider
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const SizedBox(height: 16),
              Text(
                'What would you like\nto improve?',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF252525),
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 35),

              // Scrollable content area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _goalOptions
                        .map((option) => _buildGoalCard(option))
                        .toList(),
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
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF4A4A4A),
                    ),
                  ),

                  // Finish Up Button
                  InkWell(
                    onTap: () {
                      // Handle next/finish action
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 45.0,
                        vertical: 16.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFF308BF9),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(padding: EdgeInsetsGeometry.only(right: 20)),
                          Text(
                            'Finish up',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 18),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
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

  // Custom widget for the selectable goal cards
  Widget _buildGoalCard(Map<String, dynamic> option) {
    bool isSelected = _selectedGoal == option['title'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedGoal = option['title'];
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? primaryBlue : const Color(0xFFE0E0E0),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SVG Icon
              SvgPicture.asset(
                option['iconPath'],
                width: 34,
                height: 34,
                colorFilter: ColorFilter.mode(
                  option['iconColor'],
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 16),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option['title'],
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF535359),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option['subtitle'],
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF535359),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
