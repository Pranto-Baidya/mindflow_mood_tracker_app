import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/data_provider/data_provider.dart';
import 'package:provider/provider.dart';

import '../../../provider/theme_provider/theme_provider.dart';

class MoodPieChartScreen extends StatelessWidget {
  const MoodPieChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final journalList = context.read<DataProvider>().journals;
    bool isDark = context.watch<ThemeProvider>().currentTheme == ThemeMode.dark;

    int veryHappy = 0, happy = 0, neutral = 0, sad = 0, depressed = 0;

    for (var j in journalList) {
      if (j.mood == 'Very happy') veryHappy++;
      if (j.mood == 'Happy') happy++;
      if (j.mood == 'Neutral') neutral++;
      if (j.mood == 'Sad') sad++;
      if (j.mood == 'Depressed') depressed++;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Stats', style: theme.textTheme.headlineMedium),
        iconTheme: theme.iconTheme,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: isDark ? Brightness.light : Brightness.light,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Text(
              'Weekly mood distribution',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 400.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: _buildWeeklyBarChart(context),
              ),
            ),
            SizedBox(height: 20.h),
            _buildLegend(context),
            SizedBox(height: 50.h),
            Text(
              'Overall mood breakdown',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(
              height: 300.h,
              child: MoodPieChart(
                veryHappy: veryHappy,
                happy: happy,
                neutral: neutral,
                sad: sad,
                depressed: depressed,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyBarChart(BuildContext context) {

    final moodData = calculateDailyMood(context);
    final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final isDark = context.watch<ThemeProvider>().currentTheme == ThemeMode.dark;

    return BarChart(
      BarChartData(
        maxY: 10,
        minY: 0,
        barGroups: List.generate(7, (i) {
          final day = days[i];
          final veryHappyCount = moodData[day]!['Very happy']!.toDouble();
          final happyCount = moodData[day]!['Happy']!.toDouble();
          final neutralCount = moodData[day]!['Neutral']!.toDouble();
          final sadCount = moodData[day]!['Sad']!.toDouble();
          final depressedCount = moodData[day]!['Depressed']!.toDouble();

          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: veryHappyCount,
                color: Colors.cyan,
                width: 10.w,
                  borderRadius: BorderRadius.circular(0)
              ),
              BarChartRodData(
                toY: happyCount,
                color: Colors.green,
                width: 10.w,
                  borderRadius: BorderRadius.circular(0)
              ),
              BarChartRodData(
                toY: neutralCount,
                color: Colors.yellow.shade800,
                width: 10.w,
                  borderRadius: BorderRadius.circular(0)
              ),
              BarChartRodData(
                toY: sadCount,
                color: Color(0xFFFF6F61),
                width: 10.w,
                  borderRadius: BorderRadius.circular(0)
              ),
              BarChartRodData(
                toY: depressedCount,
                color: Color(0xFF39546D),
                width: 10.w,
                borderRadius: BorderRadius.circular(0)
              ),
            ],
            barsSpace: 2.w,
          );
        }),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40.w,
              getTitlesWidget: (value, _) {
                if (value % 1 == 0 && value >= 0) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 12.sp,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  days[value.toInt()],
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? Colors.white12 : Colors.black12,
            strokeWidth: 1,
          ),
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIdx, rod, rodIdx) {
              final moods = ['Very happy', 'Happy', 'Neutral', 'Sad', 'Depressed'];
              return BarTooltipItem(
                '${moods[rodIdx]}: ${rod.toY.toInt()}',
                TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 12.sp,
                ),
              );
            },
          ),
        ),
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16.w,
      runSpacing: 8.h,
      children: [
        _legendItem(context, 'Very happy', Colors.cyan),
        _legendItem(context, 'Happy', Colors.green),
        _legendItem(context, 'Neutral', Colors.yellow.shade800),
        _legendItem(context, 'Sad', Color(0xFFFF6F61)),
        _legendItem(context, 'Depressed', Color(0xFF39546D)),
      ],
    );
  }

  Widget _legendItem(BuildContext context, String label, Color color) {
    final isDark = context.watch<ThemeProvider>().currentTheme == ThemeMode.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }

  Map<String, Map<String,int>> calculateDailyMood(BuildContext context) {

    List<dynamic> journalList = context.read<DataProvider>().journals;

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    Map<String, Map<String, int>> moodMap = {
      'Mon': {'Very happy': 0, 'Happy': 0, 'Neutral': 0, 'Sad': 0, 'Depressed': 0},
      'Tue': {'Very happy': 0, 'Happy': 0, 'Neutral': 0, 'Sad': 0, 'Depressed': 0},
      'Wed': {'Very happy': 0, 'Happy': 0, 'Neutral': 0, 'Sad': 0, 'Depressed': 0},
      'Thu': {'Very happy': 0, 'Happy': 0, 'Neutral': 0, 'Sad': 0, 'Depressed': 0},
      'Fri': {'Very happy': 0, 'Happy': 0, 'Neutral': 0, 'Sad': 0, 'Depressed': 0},
      'Sat': {'Very happy': 0, 'Happy': 0, 'Neutral': 0, 'Sad': 0, 'Depressed': 0},
      'Sun': {'Very happy': 0, 'Happy': 0, 'Neutral': 0, 'Sad': 0, 'Depressed': 0},
    };

    for (var j in journalList) {
      if (j.date.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
          j.date.isBefore(endOfWeek.add(Duration(days: 1)))) {
        final day = DateFormat('E').format(j.date);
        if (moodMap.containsKey(day)) {
          moodMap[day]![j.mood] = (moodMap[day]![j.mood] ?? 0) + 1;
        }
      }
    }
    return moodMap;
  }
}

class MoodPieChart extends StatelessWidget {
  final int veryHappy;
  final int happy;
  final int neutral;
  final int sad;
  final int depressed;

  const MoodPieChart({
    super.key,
    required this.veryHappy,
    required this.happy,
    required this.neutral,
    required this.sad,
    required this.depressed,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    final total = veryHappy + happy + neutral + sad + depressed;

    if (total == 0) {
      return Center(
        child: Text(
          'Not enough data to show in the pie chart',
          style: theme.textTheme.titleMedium,
        ),
      );
    }

    return PieChart(
      PieChartData(
        centerSpaceRadius: 40,
        centerSpaceColor: Colors.transparent,
        sectionsSpace: 2,
        sections: [
          PieChartSectionData(
            color: Colors.cyan,
            value: veryHappy.toDouble(),
            radius: 60,
            title: '${(veryHappy / total * 100).toStringAsFixed(0)}%',
            titleStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          PieChartSectionData(
            color: Colors.green,
            radius: 60,
            value: happy.toDouble(),
            title: '${(happy / total * 100).toStringAsFixed(0)}%',
            titleStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          PieChartSectionData(
            color: Colors.yellow.shade800,
            radius: 60,
            value: neutral.toDouble(),
            title: '${(neutral / total * 100).toStringAsFixed(0)}%',
            titleStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          PieChartSectionData(
            color: Color(0xFFFF6F61),
            radius: 60,
            value: sad.toDouble(),
            title: '${(sad / total * 100).toStringAsFixed(0)}%',
            titleStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          PieChartSectionData(
            color: Color(0xFF39546D),
            radius: 60,
            value: depressed.toDouble(),
            title: '${(depressed / total * 100).toStringAsFixed(0)}%',
            titleStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}