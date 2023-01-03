import 'package:flutter/material.dart';

import '../laughing_data.dart';

class WeekSummary extends StatelessWidget {
  final int week;

  const WeekSummary({Key? key, required this.week}) : super(key: key);

  String calculateLaughs([String filter = '']) {
    final total = weeksData[week - 1].days.fold(0, (int acc, DayData cur) {
      if ((filter == 'weekday' && (cur.day == 0 || cur.day == 6)) ||
          (filter == 'weekend' && (cur.day > 0 && cur.day < 6))) {
        return acc;
      }
      return acc + cur.laughs;
    });
    return total.toString();
  }

  String calculateMinMax([String filter = '']) {
    final dayMax = weeksData[week - 1].days.reduce((DayData a, DayData b) {
      if (a.laughs > b.laughs) {
        return filter == 'worst' ? b : a;
      } else {
        return filter == 'worst' ? a : b;
      }
    });
    return [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ][dayMax.day];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Week $week',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ListItem(label: 'Total laughs', value: calculateLaughs()),
          ListItem(label: 'Weekday laughs', value: calculateLaughs('weekday')),
          ListItem(label: 'Weekend laughs', value: calculateLaughs('weekend')),
          ListItem(label: 'Funniest day', value: calculateMinMax('funniest')),
          ListItem(
            label: 'Worst day',
            value: calculateMinMax('worst'),
            hideDivider: true,
          )
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String label;
  final String value;
  final bool hideDivider;

  const ListItem({
    Key? key,
    required this.label,
    required this.value,
    this.hideDivider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFD4D4D4).withOpacity(hideDivider ? 0 : 1),
            width: 1,
          )
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF565656),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF565656),
            ),
          )
        ],
      ),
    );
  }
}
