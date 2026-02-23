import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/day_record.dart';
import '../utils/calendar_logic.dart';
import '../widgets/day_cell.dart';
import '../widgets/monthly_overview_card.dart';

class MetabolicScreen extends StatefulWidget {
  const MetabolicScreen({super.key});

  @override
  State<MetabolicScreen> createState() => _MetabolicScreenState();
}

class _MetabolicScreenState extends State<MetabolicScreen> {
  final int currentYear = DateTime.now().year;
  final int currentMonth = DateTime.now().month;

  // New State Variable: Tracks which month is currently visible on screen
  late int _visibleMonth;

  final GlobalKey _currentMonthKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _visibleMonth = currentMonth; // Default to the current month

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentMonth();
    });
  }

  void _scrollToCurrentMonth() {
    if (_currentMonthKey.currentContext != null) {
      Scrollable.ensureVisible(
        _currentMonthKey.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    }
  }

  Map<int, DailyReading> _fetchDataForMonth(int year, int month) {
    if (month == 2) {
      return {
        5: DailyReading(zone: MetabolicZone.optimal, weight: '76.5kg'),
        12: DailyReading(zone: MetabolicZone.moderate, weight: '76.0kg'),
        18: DailyReading(zone: MetabolicZone.focused, weight: '75.2kg'),
        25: DailyReading(zone: MetabolicZone.optimal, weight: '74.8kg'),
      };
    }
    if (month == 1) {
      return {
        10: DailyReading(zone: MetabolicZone.focused, weight: '78.0kg'),
        20: DailyReading(zone: MetabolicZone.moderate),
      };
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    String fixedCardMonthName = DateFormat(
      'MMM yyyy',
    ).format(DateTime(currentYear, _visibleMonth));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '$currentYear Calendar',
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        centerTitle: false,
      ),

      // 1. Replaced Column with Stack to allow overlapping
      body: Stack(
        children: [
          // 2. The Scrollable Calendar Layer (Bottom Layer)
          NotificationListener<ScrollUpdateNotification>(
            onNotification: (notification) {
              int index = (notification.metrics.pixels / 450).round();
              index = index.clamp(0, currentMonth - 1);
              int newVisibleMonth = index + 1;

              if (_visibleMonth != newVisibleMonth) {
                setState(() {
                  _visibleMonth = newVisibleMonth;
                });
              }
              return true;
            },
            child: ListView.builder(
              // Added extra bottom padding (100) so the very last month
              // doesn't get permanently hidden behind the floating button
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              itemCount: currentMonth,
              itemBuilder: (context, index) {
                int monthNumber = index + 1;
                bool isCurrentMonth = monthNumber == currentMonth;

                Map<int, DailyReading> monthlyReadings = _fetchDataForMonth(
                  currentYear,
                  monthNumber,
                );
                List<DayRecord?> monthData = CalendarLogic.generateMonthData(
                  currentYear,
                  monthNumber,
                  monthlyReadings,
                );
                String monthName = DateFormat(
                  'MMM yyyy',
                ).format(DateTime(currentYear, monthNumber));
                int testsRecorded = monthlyReadings.length;

                return Padding(
                  key: isCurrentMonth ? _currentMonthKey : null,
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMonthHeader(
                        monthName,
                        '$testsRecorded Tests Recorded',
                      ),
                      const SizedBox(height: 20),
                      _buildCalendarGrid(monthData),
                    ],
                  ),
                );
              },
            ),
          ),

          // 3. The Floating Button Layer (Top Layer)
          Positioned(
            left: 20,
            right: 20,
            bottom:
                30, // Floats exactly 30 pixels above the bottom of the screen
            child: Container(
              // Adding a subtle shadow makes it pop off the scrolling background
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: MonthlyOverviewCard(
                monthLabel: fixedCardMonthName,
                onTap: () {
                  print('Navigating to overview for $fixedCardMonthName');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid(List<DayRecord?> days) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 1. Weekdays Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekdays.map((day) {
              return Text(
                day,
                style: TextStyle(
                  fontSize: 12,
                  color: day == 'Sun' ? Colors.redAccent : Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 12),

          // 2. The Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.65,
              mainAxisSpacing: 16,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final record = days[index];

              return DayCell(
                record: record,
                onTap: () {
                  // Only trigger the click if the day actually has a reading recorded
                  if (record != null && record.zone != null) {
                    // FOR TESTING: Prints the data to your debug console
                    print('--- Day Clicked ---');
                    print('Date: ${record.date}');
                    print('Weight: ${record.metric}');
                    print('Zone: ${record.zone}');

                    // TODO: Add your actual navigation logic here later.
                    // Example:
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => DailyResultScreen(record: record),
                    //   ),
                    // );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
