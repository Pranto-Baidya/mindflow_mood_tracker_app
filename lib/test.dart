import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/data_provider/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class MoodChartScreen extends StatelessWidget {
  const MoodChartScreen({super.key});

  Map<String, double> _calculateAverageMoodPerDay(BuildContext context) {
    final journalList = Provider.of<DataProvider>(context, listen: false).journals;

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final Map<String, List<int>> moodValues = {
      "Mon": [],
      "Tue": [],
      "Wed": [],
      "Thu": [],
      "Fri": [],
      "Sat": [],
      "Sun": [],
    };

    for (var journal in journalList) {
      if (journal.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          journal.date.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        String day = DateFormat('E').format(journal.date); // Mon, Tue...
        moodValues[day]?.add(_moodWeight(journal.mood));
      }
    }

    // Average map
    final Map<String, double> averageMap = {};
    moodValues.forEach((day, list) {
      averageMap[day] = list.isEmpty
          ? 0
          : list.reduce((a, b) => a + b) / list.length;
    });

    return averageMap;
  }

  int _moodWeight(String mood) {
    switch (mood) {
      case "Very Happy" :
        return 5;
      case "Happy":
        return 4;
      case "Neutral":
        return 3;
      case "Sad":
        return 2;
      case "Depressed" :
        return 1;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final moodData = _calculateAverageMoodPerDay(context);
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < days.length; i++) {
      final value = moodData[days[i]] ?? 0.0;
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: value,
              width: 16,
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(6),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 3,
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("সাপ্তাহিক মুড গ্রাফ"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            maxY: 3,
            minY: 0,
            alignment: BarChartAlignment.spaceAround,
            barTouchData: BarTouchData(enabled: true),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
              sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 1:
                    return const Text("😢");
                  case 2:
                    return const Text("🙁");
                  case 3:
                    return const Text("😐");
                  case 4:
                    return const Text("🙂");
                  case 5:
                    return const Text("😄");
                  default:
                    return const Text("");
                }
              },
            ),
          ),

          bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    return Text(
                      days[index],
                      style: const TextStyle(fontSize: 12),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: false),
            barGroups: barGroups,
          ),
        ),
      ),
    );
  }
}
