import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your ArcRuler widget here.
// Adjust the path if it is in a different folder (e.g., 'package:my_app/widgets/arc_ruler.dart')
import 'package:metabolic/features/result_process/widgets/arc_ruler.dart';

class MetabolismResultProcess extends StatefulWidget {
  final double score; // Score from 0 to 100

  const MetabolismResultProcess({super.key, required this.score});

  @override
  State<MetabolismResultProcess> createState() =>
      _MetabolismResultProcessState();
}

class _MetabolismResultProcessState extends State<MetabolismResultProcess>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scoreAnimation;

  // Explicit animations for sequenced transitions
  late Animation<Color?> _domeColorAnimation;
  late Animation<double> _textFadeOutAnimation;
  late Animation<double> _textFadeInAnimation;
  late Animation<double> _slideUpAnimation;
  late Animation<double> _buttonFadeInAnimation;

  // Define the master duration here so it's easy to change later
  final Duration _animationDuration = const Duration(
    milliseconds: 4000,
  ); // CHANGED to 4 seconds

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration, // Applied here
    );

    // 1. The Score counting up
    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.score,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    final finalStatusColor = _getStatusColor(widget.score);

    // 2. Color Transition (Shifted earlier: 35% to 55% of animation)
    _domeColorAnimation =
        ColorTween(
          begin: const Color(0xFF308BF9),
          end: finalStatusColor,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.35, 0.55, curve: Curves.easeInOut),
          ),
        );

    // 3. Text Cross-fade (Shifted earlier)
    _textFadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.45, curve: Curves.easeOut),
      ),
    );

    _textFadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.55, curve: Curves.easeIn),
      ),
    );

    // 4. Slide Upwards (55% to 75% of animation)
    _slideUpAnimation =
        Tween<double>(
          begin: 0.0, // Stays at 0 until 55%
          end: -80.0, // Slides up 80 pixels
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.55, 0.75, curve: Curves.easeInOut),
          ),
        );

    // 5. Button Fade In (70% to 90% of animation)
    _buttonFadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.70, 0.90, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getStatusColor(double score) {
    if (score < 70) return const Color(0xFFE48226); // Bad (Orange)
    if (score < 80) return const Color(0xFFFFBF2D); // Moderate (Yellow)
    return const Color(0xFF3EAF58); // Good (Green)
  }

  String _getStatusText(double score) {
    if (score < 70) return "bad";
    if (score < 80) return "moderate";
    return "good";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final currentScore = _scoreAnimation.value;
          final currentDomeColor =
              _domeColorAnimation.value ?? const Color(0xFF308BF9);

          return Stack(
            alignment: Alignment.center,
            children: [
              // --- SCORE TEXT SECTION ---
              Positioned(
                top: 60,
                child: Column(
                  children: [
                    Text(
                      'Your Metabolism Score',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF252525),
                        height: 1.10,
                        letterSpacing: -0.72,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const SizedBox(width: 20),
                        Text(
                          currentScore.toInt().toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 80,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '%',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- ARC SCALE & DOME ---
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 450,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // The Color Dome
                      Positioned(
                        top: 100,
                        child: Container(
                          width: 628,
                          height: 628,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                currentDomeColor.withOpacity(0.7),
                                currentDomeColor,
                              ],
                              stops: const [0.0, 0.2],
                            ),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 140),

                              // The sliding text block
                              Transform.translate(
                                offset: Offset(0, _slideUpAnimation.value),
                                child: SizedBox(
                                  width: 280,
                                  height: 70, // Fixed height limits jumps
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      // Initial Text
                                      Opacity(
                                        opacity: _textFadeOutAnimation.value,
                                        child: Text(
                                          "Your score falls in...",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                      ),
                                      // Final Result Text
                                      Opacity(
                                        opacity: _textFadeInAnimation.value,
                                        child: Text(
                                          "Great. Your score falls in\n${_getStatusText(widget.score)} range!",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // The Button (Follows the text up, fading in as it does)
                              Transform.translate(
                                offset: Offset(
                                  0,
                                  _slideUpAnimation.value +
                                      (1 - _buttonFadeInAnimation.value) * 15,
                                ),
                                child: Opacity(
                                  opacity: _buttonFadeInAnimation.value,
                                  child: OutlinedButton(
                                    onPressed:
                                        _buttonFadeInAnimation.value > 0.8
                                        ? () {}
                                        : null,
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Colors.white,
                                      ),
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 20,
                                      ),
                                    ),
                                    child: Text(
                                      "What it means?",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        height: 1.10,
                                        letterSpacing: 0.30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // YOUR EXTERNAL ARC RULER WIDGET
                      Positioned(
                        top: 80,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: ArcRuler(
                            value: widget.score,
                            onChanged: (val) {},
                            thumbAnimationDuration:
                                _animationDuration, // Applied here to match perfectly
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
