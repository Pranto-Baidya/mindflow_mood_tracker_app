

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/auth_provider/auth_provider.dart' show AuthProvider;
import 'package:mindflow_mood_tracker_app_with_firebase/provider/data_provider/data_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/internet_connection_provider/internet_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/theme_provider/theme_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/auth_screens/sign_in_sign_up/sign_in_sign_up.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/ui_screens/add_journal/add_journal.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/ui_screens/edit_journal/edit_journal.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/ui_screens/mood_stats_screen/pie_chart_screen.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/ui_screens/profile_screen/profile.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/test.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/animated_container/animated_container_widget.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_loader/app_loader.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_toastMsg/app_toastMsg.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/custom_listile/custom_listTile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AllMoodJournals extends StatefulWidget {
  const AllMoodJournals({super.key});

  @override
  State<AllMoodJournals> createState() => _AllMoodJournalsState();
}

class _AllMoodJournalsState extends State<AllMoodJournals> {

  String? uid;
  bool isSearching = false;

  bool hasSearched = false;

  bool isFiltering = false;

  final TextEditingController _searchController = TextEditingController();

  void toggleSearching(){
    setState(() {
      isSearching = !isSearching;
      if(!isSearching){
        _searchController.clear();
      }
    });
  }

 @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        uid = user.uid;
        context.read<DataProvider>().getAllJournals(uid!);
      }
      final net = context.read<InternetProvider>();
      net.addListener(_showInternetToast);
    });
    super.initState();
  }

  void _showInternetToast() {
    final net = context.read<InternetProvider>();
    if (mounted) {
      final message = 'Internet connection restored';
      if (net.isConnected) {
        ToastMsg.successToast(message);
      }
    }
  }

  Future<void> _launchUrl()async{
    final Uri url = Uri.parse('https://www.linkedin.com/in/prantobaidya/');

    if(await canLaunchUrl(url)){
      await launchUrl(url,mode: LaunchMode.externalApplication);
    }
    else{
      throw 'Failed to launch url';
    }
  }

  Future<void> _launchEmail()async{
    Uri emailUri = Uri(
      scheme: 'mailto',
      path: "prantodey3@gmail.com",
    );
    if(await canLaunchUrl(emailUri)){
      await launchUrl(emailUri,mode: LaunchMode.externalApplication);
    }
    else{
      throw 'Could not launch email uri';
    }
  }

  void filterAlert(BuildContext context){
    final data = context.read<DataProvider>();
    List<String> moods = ['Very happy','Happy','Neutral','Sad','Depressed'];
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Filter by',style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...moods.map((m){
                    return RadioListTile(
                        tileColor: Colors.transparent,
                        title: Text(m,style:Theme.of(context).textTheme.titleMedium,),
                        value: m,
                        groupValue: data.selectedMood,
                        onChanged: (value){
                          data.setMoodFilter(m);
                          Navigator.pop(context);
                        }
                    );
                  }),
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: ListTile(
                      onTap: ()async{
                        final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100)
                        );
                        if(pickedDate!=null){
                          setState(() {
                            data.setDateFilter(pickedDate);
                            Navigator.pop(context);
                          });
                        }
                      },
                      tileColor: Colors.transparent,
                      leading: Icon(Icons.date_range,color: Theme.of(context).iconTheme.color,),
                      title: Text('Selecting date',style: Theme.of(context).textTheme.titleMedium,),
                      subtitle: data.selectedDate == null? Text('Tap to select') :
                      Text('Date: ${DateFormat('d/M/y').format(data.selectedDate!)}',style: Theme.of(context).textTheme.titleSmall,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: ListTile(
                      onTap: ()async{
                        final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now()
                        );
                        if(pickedTime!=null){
                          setState(() {
                            data.setTimeFilter(pickedTime);
                            Navigator.pop(context);
                          });
                        }
                      },
                        tileColor: Colors.transparent,
                      leading: Icon(Icons.access_time,color: Theme.of(context).iconTheme.color,),
                      title: Text('Selecting time',style: Theme.of(context).textTheme.titleMedium,),
                      subtitle: data.selectedTime==null? Text('Tap to select') :
                      Text('Time : ${data.selectedTime!.hour} : ${data.selectedTime!.minute.toString().padLeft(2, '0')}'),
                    ),
                  )
              
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  setState(() {
                    isFiltering = false;
                  });
                },
                child:  Text("Cancel",style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary),),
              )
            ],
          );
        }
    );
  }

  Color _getBackgroundColor(String mood) {
    switch (mood) {
      case 'Very happy':
        return Colors.cyan;
      case 'Happy':
        return Colors.green;
      case 'Neutral':
        return Colors.yellow.shade800;
      case 'Sad':
        return Color(0xFFFF6F61);
      case 'Depressed':
        return Color(0xFF39546d);
      default:
        return Colors.yellow.shade800;
    }
  }

  IconData _moodIcon(String mood) {
    switch (mood) {
      case 'Very happy':
        return Icons.sentiment_very_satisfied_sharp;
      case 'Happy':
        return Icons.sentiment_satisfied_sharp;
      case 'Neutral':
        return Icons.sentiment_neutral;
      case 'Sad':
        return Icons.sentiment_dissatisfied;
      case 'Depressed':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final data = context.watch<DataProvider>();
    final user = FirebaseAuth.instance.currentUser;
    bool isDark = context.watch<ThemeProvider>().currentTheme==ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title:
        isSearching?
            AnimatedMoodContainerWidget(
              index: 0,
              offset: Offset(0.5, 0) ,
              child: TextField(
                controller: _searchController,
                cursorColor: theme.colorScheme.primary,
                decoration: InputDecoration(
                  hintText: 'Find a mood journal',
                  hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
                onChanged: (value)async{
                  await context.read<DataProvider>().searchContents(value);
                  setState(() {
                    hasSearched = true;
                  });
                },
              ),
            )
        :Row(
          children: [
            Text(
              'Mindflow',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500
              ),
            ),
          ],
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: isDark? Brightness.light:Brightness.light
        ),
        backgroundColor: Colors.transparent,
        actions: [
          isSearching?
          SizedBox()
          :
          user != null && user.photoURL != null
              ? Padding(
            padding:  EdgeInsets.only(right: 15.w),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));

                  },
                  child: ClipOval(
                              child: Image.network(user.photoURL!, fit: BoxFit.cover, width: 38.w, height: 38.w,),
                            ),
                ),
              )
              : Padding(
            padding:  EdgeInsets.only(right: 15.w),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              child: IconButton(
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile()));
                 },
                  icon : Icon(Icons.person, color: Theme.of(context).colorScheme.primary)
              ),
            ),
          ),
          isSearching?
              SizedBox()
          :Padding(
            padding:  EdgeInsets.only(right: 15.w),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              child: IconButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddJournal()),
                  );
                },
                icon: Icon(Icons.add,color: theme.colorScheme.primary,),
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(right: 15.w),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              child: IconButton(
                onPressed: (){
                  toggleSearching();
                },
                icon: isSearching? Icon(Icons.cancel,color: theme.colorScheme.primary,):Icon(Icons.search,color: theme.colorScheme.primary,),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<DataProvider>().getRefreshedJournals(uid!);
        },
        backgroundColor: theme.cardColor,
        color: theme.colorScheme.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            isSearching?
                SizedBox()
            :Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                  child: data.isLoading || data.journals.isEmpty ? Text('')
                      : isFiltering?Text('Showing filtered results', style: theme.textTheme.headlineSmall,)
                      :Text('Your daily mood records', style: theme.textTheme.headlineSmall,),
                ),
                Spacer(),
                data.isLoading || data.journals.isEmpty?
                    SizedBox()
                :
                Padding(
                  padding:  EdgeInsets.only(right: 15.w),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                    child: IconButton(
                      onPressed: () {
                        if (isFiltering) {
                          context.read<DataProvider>().clearFilters();
                          setState(() {
                            isFiltering = false;
                          });
                        } else {
                          filterAlert(context);
                          setState(() {
                            isFiltering = true;
                          });
                        }
                      },
                      icon: Icon(
                        isFiltering ? Icons.filter_alt : Icons.filter_alt_off,
                        color: theme.colorScheme.primary,
                      ),
                    ),

                  ),
                ),
              ],
            ),
           isFiltering? SizedBox(height: 10.h) : SizedBox(),
            if (isFiltering)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      if (data.selectedMood != null)
                        _buildMoodChip(data.selectedMood!, theme),

                      if (data.selectedDate != null)
                        _buildDateChip(data.selectedDate!, theme),

                      if (data.selectedTime != null)
                        _buildTimeChip(data.selectedTime!, theme, context),
                    ],
                  ),
                ),
              )
            else
              SizedBox(height: 10.h),

            SizedBox(height: 10.h),
            Consumer<InternetProvider>(
                builder:(context,net,_){
                  if(net.isConnected){
                    return Expanded(
                      child: Consumer2<DataProvider, ThemeProvider>(
                        builder: (context, data, themeProvider,_) {
                          final journalList = isSearching
                              ? data.searchedContent
                              : isFiltering ? data.filteredJournals
                              : data.journals;

                          return data.isLoading
                              ? Center(
                            child: themeProvider.currentTheme == ThemeMode.dark
                                ? AppLoader.darkThemeLoaderPrimary()
                                : AppLoader.lightThemeLoaderPrimary(),
                          )
                              : journalList.isEmpty
                              ? Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 100.h,),
                                isDark? Lottie.asset('assets/sad_dark.json',fit: BoxFit.cover,width: 500.w,height: 180.h)
                                    :Lottie.asset('assets/sad_light.json',fit: BoxFit.cover,width: 500.w,height: 180.h),
                                SizedBox(height: 10.h,),
                                Center(
                                    child: isSearching?Text('No mood journals found',style: theme.textTheme.titleMedium,) :Text('No mood journals to show, add one to see',style: theme.textTheme.titleMedium,)),
                              ],
                            ),
                          )
                              : ListView.builder(
                            itemCount: journalList.length,
                            itemBuilder: (context, index) {
                              final result = journalList[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 5.h,
                                ),
                                child: Dismissible(
                                  key: Key(result.id),
                                  direction: DismissDirection.horizontal,
                                  confirmDismiss: (direction) async {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditJournal(model: result),
                                        ),
                                      );
                                      return false;
                                    } else if (direction ==
                                        DismissDirection.startToEnd) {
                                      final confirmed = await showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text("Confirm Delete",style: theme.textTheme.titleLarge,),
                                          content: Text(
                                            "Are you sure you want to delete this journal?",
                                            style: theme.textTheme.titleMedium,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: Text(
                                                "Cancel",
                                                style: theme.textTheme.titleSmall
                                                    ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: Text(
                                                "Delete",
                                                style: theme.textTheme.titleSmall
                                                    ?.copyWith(color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      return confirmed == true;
                                    }
                                    return false;
                                  },
                                  onDismissed: (direction) {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      context.read<DataProvider>().deleteJournal(
                                        result.id,
                                        result.uid,
                                      );
                                    }
                                  },
                                  background: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  secondaryBackground: Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    child: Icon(Icons.edit, color: Colors.white),
                                  ),
                                  child: AnimatedMoodContainerWidget(
                                    index: index,
                                    offset: Offset(0, 0.2),
                                    child: ExpansionTile(
                                      backgroundColor: theme.cardColor,
                                      tilePadding: EdgeInsets.all(20),
                                      collapsedBackgroundColor: theme.cardColor,
                                      collapsedIconColor: theme.iconTheme.color,
                                      iconColor: theme.iconTheme.color,
                                      collapsedShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.r),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.r),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: _getBackgroundColor(
                                          result.mood,
                                        ),
                                        child: Icon(_moodIcon(result.mood)),
                                      ),
                                      title: Text(
                                        result.content,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 20.w,
                                            right: 15.w,
                                            bottom: 10.h,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Date :    ${DateFormat('d/M/y').format(result.date)}, ${result.time.format(context)}',
                                                style:
                                                theme.textTheme.titleMedium,
                                              ),
                                              SizedBox(height: 10.h),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Tags :  ',
                                                    style: theme
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                  ...result.tags.map((tag){
                                                    return Padding(
                                                      padding:  EdgeInsets.symmetric(horizontal: 5.w),
                                                      child: Chip(
                                                        label: Text(tag,style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary,)),
                                                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                                                        side: BorderSide(color: theme.colorScheme.primary,),
                                                      ),
                                                    );
                                                  })
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                  else{
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 150.h,),
                          isDark? Lottie.asset('assets/internet_dark.json', width: 150.w, height: 150.h):Lottie.asset('assets/internet_light.json', width: 150.w, height: 150.h),
                          SizedBox(height: 20.h),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              'No internet connection', style: theme.textTheme.titleLarge,
                            ),
                          )
                        ],
                      ),
                    );
                  }
              }
            )
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: theme.drawerTheme.backgroundColor,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: [
            UserAccountsDrawerHeader(
                accountName: Text(user?.displayName ?? '',style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),),
                accountEmail: Text(user?.email?? '',style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),),
                currentAccountPicture: user?.photoURL!=null?ClipOval(child: Image.network(user?.photoURL??'',width: 40,height: 40,))
                    :CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person,color: theme.colorScheme.primary,size: 40,),
                ),
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary
                ),
            ),
            SizedBox(height: 20.h,),
            AnimatedMoodContainerWidget(
              index: 1,
              offset: Offset(0, 0.2),
              child: CustomListTile(
                  leadingIcon: Icons.show_chart,
                  title: 'View mood stats',
                  onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MoodPieChartScreen()));
                  }
              )
            ),
            AnimatedMoodContainerWidget(
                index: 2,
                offset: Offset(0, 0.2),
                child: CustomListTile(
                    leadingIcon: Icons.history,
                    title: 'History',
                    onTap:(){

                    }
                )
            ),
            AnimatedMoodContainerWidget(
                index: 3,
                offset: Offset(0, 0.2),
                child: CustomListTile(
                    leadingIcon: Icons.bug_report_outlined,
                    title: 'Report a bug',
                    onTap:()async{
                      await _launchEmail();
                    }
                )
            ),
            AnimatedMoodContainerWidget(
                index: 4,
                offset: Offset(0, 0.2),
                child: CustomListTile(
                    leadingIcon: Icons.info_outline,
                    title: 'About dev',
                    onTap:()async{
                      await _launchUrl();
                    }
                )
            ),
            AnimatedMoodContainerWidget(
                index: 5,
                offset: Offset(0, 0.2),
                child: CustomListTile(
                    leadingIcon: Icons.power_settings_new_outlined,
                    title: 'Exit app',
                    onTap:(){

                    }
                )
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildMoodChip(String mood, ThemeData theme) {
    final color = _getBackgroundColor(mood);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        width: 150.w,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          children: [
            SizedBox(width: 15.w),
            CircleAvatar(
              radius: 18.r,
              backgroundColor: color,
              child: Icon(_moodIcon(mood), color: Colors.white),
            ),
            SizedBox(width: 10.w),
            Text(
              mood,
              style: theme.textTheme.titleMedium?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateChip(DateTime selectedDate, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        width: 160.w,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          children: [
            SizedBox(width: 15.w),
            CircleAvatar(
              radius: 18.r,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.date_range, color: Colors.white),
            ),
            SizedBox(width: 10.w),
            Text(
              DateFormat('d/M/y').format(selectedDate),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(TimeOfDay selectedTime, ThemeData theme, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Container(
        width: 150.w,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          children: [
            SizedBox(width: 15.w),
            CircleAvatar(
              radius: 18.r,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.access_time, color: Colors.white),
            ),
            SizedBox(width: 10.w),
            Text(
              selectedTime.format(context),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
