import 'package:flutter/material.dart';

enum MetabolicZone { optimal, moderate, focused }

// 1. This represents the raw data coming from your database
class DailyReading {
  final MetabolicZone zone;
  final String? weight;

  DailyReading({required this.zone, this.weight});
}

// 2. This is what the UI actually uses to draw the cell
class DayRecord {
  final DateTime date;
  final MetabolicZone? zone;
  final String? metric;

  DayRecord({required this.date, this.zone, this.metric});

  Color get dotColor {
    switch (zone) {
      case MetabolicZone.optimal:
        return Colors.green;
      case MetabolicZone.moderate:
        return Colors.amber;
      case MetabolicZone.focused:
        return Colors.redAccent;
      default:
        return Colors.transparent;
    }
  }
}
