import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    int veryHappy=0,happy=0,neutral=0,sad=0,depressed = 0;

    for(var j in journalList){
      if(j.mood=='Very happy'){
        veryHappy++;
      }
      if(j.mood=='Happy'){
        happy++;
      }
      if(j.mood=='Neutral'){
        neutral++;
      }
      if(j.mood=='Sad'){
        sad++;
      }
      if(j.mood=='Depressed'){
        depressed++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Mood stats',style: theme.textTheme.headlineMedium,),
        iconTheme: theme.iconTheme,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: isDark ? Brightness.light : Brightness.light,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300.h,
            child: MoodPieChart(
                veryHappy: veryHappy,
                happy: happy,
                neutral: neutral,
                sad: sad,
                depressed: depressed
            ),
          )
        ],
      ),
    );
  }
}


class MoodPieChart extends StatelessWidget {
  final int veryHappy;
  final int happy;
  final int neutral;
  final int sad;
  final int depressed;
  const MoodPieChart({super.key, required this.veryHappy, required this.happy, required this.neutral, required this.sad, required this.depressed});

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);

    final total = veryHappy+happy+neutral+sad+depressed;

    if(total==0){
      return Center(child: Text('Not enough data to show in the pie chart',style: theme.textTheme.titleMedium,),);
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
              title: '${(veryHappy/total*100).toStringAsFixed(0)}%',
              titleStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.white)
            ),
            PieChartSectionData(
              color: Colors.green,
              radius: 60,
              value: happy.toDouble(),
              title: '${(happy/total*100).toStringAsFixed(0)}%',
                titleStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.white)
            ),
            PieChartSectionData(
              color: Colors.yellow.shade800,
              radius: 60,
              value: neutral.toDouble(),
              title: '${(neutral/total*100).toStringAsFixed(0)}%',
                titleStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.white)
            ),
            PieChartSectionData(
                color: Color(0xFFFF6F61),
                radius: 60,
                value: sad.toDouble(),
                title: '${(sad/total*100).toStringAsFixed(0)}%',
                titleStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.white)
            ),
            PieChartSectionData(
                color: Color(0xFF39546d),
                radius: 60,
                value: depressed.toDouble(),
                title: '${(depressed/total*100).toStringAsFixed(0)}%',
                titleStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.white)
            ),
          ]
        )
      );
  }
}
