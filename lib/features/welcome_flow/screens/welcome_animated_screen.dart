import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

class WelcomeSequenceScreen extends StatefulWidget {
  // 1. Add your variables here
  final String userName;
  final String bmiValue;
  final String bmrValue;

  const WelcomeSequenceScreen({
    super.key,
    required this.userName,
    required this.bmiValue,
    required this.bmrValue,
  });

  @override
  State<WelcomeSequenceScreen> createState() => _WelcomeSequenceScreenState();
}

class _WelcomeSequenceScreenState extends State<WelcomeSequenceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Animation segments
  late Animation<double> _topSectionMove;
  late Animation<double> _statsFade;
  late Animation<Offset> _blueShapeSlide;
  late Animation<double> _bottomTextFade;
  late Animation<double> _buttonFade;

  @override
  void initState() {
    super.initState();

    // Total duration of the entire flow
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    // 1. Move Top Section up (from 0.0 to 1.0)
    _topSectionMove = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOutCubic),
      ),
    );

    // 2. Fade in Stats (BMI/BMR)
    _statsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.5, curve: Curves.easeIn),
      ),
    );

    // 3. Slide up the blue shape from bottom
    _blueShapeSlide =
        Tween<Offset>(begin: const Offset(0, 1.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 0.7, curve: Curves.easeOutCubic),
          ),
        );

    // 4. Fade in "Let's get familiar" text
    _bottomTextFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 0.85, curve: Curves.easeIn),
      ),
    );

    // 5. Fade in Button (and trigger upwards shift)
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.85, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // Start animation automatically after a brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper to replay animation for testing
  void _replayAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- TOP SECTION (Profile & Texts) ---
          AnimatedBuilder(
            animation: _topSectionMove,
            builder: (context, child) {
              // Interpolate padding to move the widget from center to top
              final topPadding = lerpDouble(
                size.height * 0.35, // Starting position (centered)
                size.height * 0.10, // Ending position (top)
                _topSectionMove.value,
              )!;

              return Positioned(
                top: topPadding,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    // Profile Icon Avatar
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFF0F0F0),
                        shape: OvalBorder(),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Welcome Text
                    // Welcome Text
                    SizedBox(
                      width: 279,
                      // FittedBox automatically scales down the text if it's too wide
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Text(
                          'Welcome ${widget.userName}!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF252525),
                            fontSize:
                                34, // This now acts as the MAXIMUM font size
                            fontWeight: FontWeight.w400,
                            letterSpacing: -2.04,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    SizedBox(
                      width: 279,
                      child: Text(
                        'Your profile has been created',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF535359),
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- STATS SECTION (Fades in later) ---
                    FadeTransition(
                      opacity: _statsFade,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 3. Pass the dynamic bmiValue here
                          _buildStatColumn('Current BMI', widget.bmiValue),
                          Container(
                            height: 35,
                            width: 1,
                            color: Colors.grey.shade300,
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                          ),
                          // 4. Pass the dynamic bmrValue here
                          _buildStatColumn('Current BMR', widget.bmrValue),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // --- BOTTOM BLUE CURVE (Huge Oval) ---
          AnimatedBuilder(
            animation: _blueShapeSlide,
            builder: (context, child) {
              // Sliding logic: 'dy' goes from 1.0 (hidden) to 0.0 (visible)
              final dy = _blueShapeSlide.value.dy;
              // How much of the 628 circle we want visible at the end (~380px)
              final visibleHeight = size.height * 0.45;
              final topPos = size.height - (visibleHeight * (1 - dy));

              return Positioned(
                // Center the 628px circle horizontally regardless of screen size
                left: (size.width - 628) / 2,
                top: topPos,
                child: child!,
              );
            },
            child: Container(
              width: 628,
              height: 628,
              decoration: const ShapeDecoration(
                color: Color(0xFF308BF9),
                shape: OvalBorder(),
              ),
              // Use a Stack inside the dome to position text and button
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // --- Fading & Shifting Text ---
                  AnimatedBuilder(
                    animation: _buttonFade,
                    builder: (context, child) {
                      // Text starts lower down, then shifts up by 35 pixels when button appears
                      final shiftUp = lerpDouble(0, -35, _buttonFade.value)!;
                      return Positioned(
                        top:
                            110 +
                            shiftUp, // Starts at 130px from the dome's top
                        child: Opacity(
                          opacity: _bottomTextFade.value,
                          child: SizedBox(
                            width: 324,
                            child: Text(
                              'Let’s get familiar with\nRespyr',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -1,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // --- Fading & Sliding Button ---
                  AnimatedBuilder(
                    animation: _buttonFade,
                    builder: (context, child) {
                      // Button slides up slightly from 200px to 170px as it fades in
                      final buttonTop = lerpDouble(
                        200,
                        170,
                        _buttonFade.value,
                      )!;
                      return Positioned(
                        top: buttonTop,
                        child: Opacity(
                          opacity: _buttonFade.value,
                          child: child,
                        ),
                      );
                    },
                    child: Material(
                      // Must be transparent so your blue gradient shows through
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Action for Practice Test
                          print("Start Practice Test Tapped!");
                        },
                        // Matches the border radius so the ripple doesn't bleed out of the corners
                        borderRadius: BorderRadius.circular(50),
                        // Adds a soft white splash and highlight effect
                        splashColor: Colors.white.withOpacity(0.3),
                        highlightColor: Colors.white.withOpacity(0.1),
                        child: Container(
                          height: 61,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Start Practice Test',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.10,
                                  letterSpacing: 0.30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Optional: Replay button for testing
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        onPressed: _replayAnimation,
        child: const Icon(Icons.refresh, color: Colors.blue),
      ),
    );
  }

  // Helper widget to build the BMI/BMR columns
  Widget _buildStatColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: const Color(0xFF535359),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color(0xFF252525),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
