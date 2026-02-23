import 'package:flutter/material.dart';
import '../models/day_record.dart';

class DayCell extends StatelessWidget {
  final DayRecord? record;
  final VoidCallback? onTap; // 1. Add the onTap callback

  const DayCell({
    super.key,
    required this.record,
    this.onTap, // 2. Add it to the constructor
  });

  @override
  Widget build(BuildContext context) {
    if (record == null) return const SizedBox.shrink();

    bool isSunday = record!.date.weekday == DateTime.sunday;

    // 3. Wrap the whole column in a GestureDetector
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior
          .opaque, // Makes the empty space around the text clickable too
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '${record!.date.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSunday ? Colors.redAccent : Colors.black87,
            ),
          ),
          const SizedBox(height: 6),

          if (record!.zone != null)
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: record!.dotColor,
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(height: 6),

          const SizedBox(height: 4),

          if (record!.metric != null)
            Text(
              record!.metric!,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            )
          else
            const SizedBox(height: 12),
        ],
      ),
    );
  }
}
