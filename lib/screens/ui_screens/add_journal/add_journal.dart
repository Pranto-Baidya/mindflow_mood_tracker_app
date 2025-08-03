


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/model/journal_model.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/data_provider/data_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/preferences_provider/preferences_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_loader/app_loader.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_toastMsg/app_toastMsg.dart';
import 'package:provider/provider.dart';
import '../../../provider/theme_provider/theme_provider.dart';

class AddJournal extends StatefulWidget {
  const AddJournal({super.key});

  @override
  State<AddJournal> createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {

  final List<String> defaultTags = ['Work', 'Family', 'Health', 'Sleep', 'Friends', 'Study', 'Exercise', 'Diet'];

  Set<String> selectedTags = {};

  final user = FirebaseAuth.instance.currentUser;

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final GlobalKey<FormState> _tagKey = GlobalKey<FormState>();

  String selectedMood = 'Neutral';

  TimeOfDay selectedTime = TimeOfDay.now();

  DateTime selectedDate = DateTime.now();

  DateTime get combinedDateTime{
    return DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute
    );
  }

  Future<void> submitJournal() async {
    final journals = JournalModel(
      id: '',
      uid: user?.uid ?? '',
      date: combinedDateTime,
      time: selectedTime,
      mood: selectedMood,
      content: _contentController.text,
      tags: selectedTags.toList(),
    );

    await context.read<DataProvider>().addJournal(journals);
  }

  Future<void> pickDateAndTime()async{
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime.now()
    );

    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial
    );

    if(pickedTime!=null && pickedTime!=selectedTime){
      setState(() {
        selectedTime = pickedTime;
      });
    }

    if(pickedDate!=null && pickedDate!=selectedDate){
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void newTagAlert(BuildContext context){
    final prefs = context.read<PreferencesProvider>();

    showDialog(
        context: context,
        builder: (BuildContext context){
          var theme = Theme.of(context);
          return AlertDialog(
            title: Text('Add a new tag',style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),),
            content: Form(
              key: _tagKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _tagsController,
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "Please add a tag";
                      }
                      return null;
                    },
                    cursorColor: theme.colorScheme.primary,
                    decoration: InputDecoration(
                      hint: Text('Write the tag name you want to add',style: theme.textTheme.titleSmall?.copyWith(color :Colors.grey),)
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  ElevatedButton(
                      onPressed: ()async{
                        if(_tagKey.currentState!.validate()){
                          if(_tagsController.text.trim().isNotEmpty && !prefs.customTags.contains(_tagsController.text.trim())){
                            setState(() {
                              final newTag = _tagsController.text.trim();
                              prefs.customTags.add(newTag);
                              selectedTags.add(newTag);
                              prefs.saveCustomTag(prefs.customTags);
                              Navigator.pop(context);
                              _tagsController.clear();
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          elevation: 0,
                          minimumSize: Size(double.infinity.w, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r)
                          ),
                      ),
                      child: Text('Add tag',style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w500))
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget _buildTags(String tag,BuildContext context){
    return Text(tag,style: Theme.of(context).textTheme.titleMedium);
  }

  Widget _buildMoodIcon(String mood, IconData icon,) {
    Color moodColor;
    switch(mood){
      case 'Very happy' :
        moodColor = Colors.cyan;
        break;
      case 'Happy':
        moodColor = Colors.green;
        break;
      case 'Neutral' :
        moodColor = Colors.yellow.shade800;
        break;
      case 'Sad' :
        moodColor = Color(0xFFFF6F61);
        break;
      case 'Depressed' :
        moodColor = Color(0xFF39546d);
        break;

      default :
        moodColor = Colors.grey.shade300;
    }
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => selectedMood = mood),
          child: CircleAvatar(
            radius: 25,
            backgroundColor:
            selectedMood == mood ? moodColor : moodColor = Colors.grey.shade300,
            child: Icon(
              icon, color: selectedMood == mood ? Colors.white : Colors.black,
            ),
          ),
        ),
        SizedBox(height: 10.h,),
        if(selectedMood == mood)
          _buildTags(mood, context)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final dataProvider = context.watch<DataProvider>();
    final prefs = context.read<PreferencesProvider>();
    final allTags = {...defaultTags, ...prefs.customTags};
    return Scaffold(
        appBar: AppBar(
          title : Text('Add a mood journal',style: theme.textTheme.headlineMedium,),
          backgroundColor: Colors.transparent,
          iconTheme: theme.iconTheme,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarBrightness: context.watch<ThemeProvider>().currentTheme==ThemeMode.dark? Brightness.light:Brightness.light
          ),
        ),
        body: Form(
          key: _key,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: ListView(
              children: [
                SizedBox(height: 20.h,),
                Container(
                  width: double.infinity.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(15.r)
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.h,),
                        Text('Date : ${DateFormat('d/M/y, h:mm a').format(combinedDateTime)}',style: theme.textTheme.titleMedium,),
                        TextButton(
                            onPressed: pickDateAndTime,
                            child: Text('Change date',style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),)
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h,),
                Container(
                  width: double.infinity.w,
                  height: 155.h,
                  decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(15.r)
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h,),
                      Text('Select your mood',style: theme.textTheme.titleMedium,),
                      SizedBox(height: 15.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMoodIcon("Very happy", Icons.sentiment_very_satisfied_sharp,),
                          _buildMoodIcon("Happy", Icons.sentiment_satisfied_sharp,),
                          _buildMoodIcon("Neutral", Icons.sentiment_neutral,),
                          _buildMoodIcon("Sad", Icons.sentiment_dissatisfied),
                          _buildMoodIcon('Depressed', Icons.sentiment_very_dissatisfied)
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h,),
                TextFormField(
                  controller: _contentController,
                  cursorColor: theme.colorScheme.primary,
                  maxLines: 5,
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return "Please write how you're feeling now";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintFadeDuration: Duration(seconds: 5),
                    hintText: 'Write about your mood',
                    hintStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.grey,fontWeight: FontWeight.w400),

                  ),
                ),
                SizedBox(height: 20.h,),
                Text('Select Tags',style: theme.textTheme.titleMedium,),
                SizedBox(height: 20.h,),
                Wrap(
                  alignment: WrapAlignment.start,
                  children: [

                    ...allTags.map((tag){
                      bool isSelected = selectedTags.contains(tag);
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: ChoiceChip(
                          label: Text(tag,style: theme.textTheme.titleMedium?.copyWith(color: isSelected?Colors.white: theme.colorScheme.primary),),
                          selected: isSelected,
                          side: BorderSide(color: theme.colorScheme.primary),
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                          selectedColor: theme.colorScheme.primary,
                          checkmarkColor: Colors.white,
                          onSelected: (selected){
                            if(selected){
                              setState(() {
                                selectedTags.add(tag);
                              });
                            }
                            else{
                              setState(() {
                                selectedTags.remove(tag);
                              });
                            }
                          },
                        ),
                      );
                    }),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 6),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                        child: IconButton(
                          onPressed: (){
                            newTagAlert(context);
                          },
                          icon: Icon(Icons.add,color: theme.colorScheme.primary,),
                        ),
                      ),
                    )
                  ]
                  ),

                SizedBox(height: 20.h,),
                ElevatedButton(
                  onPressed: ()async{
                    if(_key.currentState!.validate()){
                      await submitJournal();
                      ToastMsg.successToast('Added a new mood journal');
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      elevation: 0,
                      minimumSize: Size(double.infinity.w, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      )
                  ),
                  child: dataProvider.isLoading?AppLoader.lightThemeLoader()
                      :Text('Save',style: theme.textTheme.titleLarge?.copyWith(color: Colors.white,fontWeight: FontWeight.w500),),
                )
              ],
            ),
          ),
        )
    );
  }
}
