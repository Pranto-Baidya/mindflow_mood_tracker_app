
import 'dart:math';

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

class EditJournal extends StatefulWidget {
  final JournalModel model;
  const EditJournal({super.key, required this.model});

  @override
  State<EditJournal> createState() => _EditJournalState();
}

class _EditJournalState extends State<EditJournal> {

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  List<String> defaultTags = ['Work', 'Family', 'Health', 'Sleep', 'Friends', 'Study', 'Exercise', 'Diet'];
  
  Set<String> selectedTags = {};

  String selectedMood = '';

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  bool isUpdated = false;

  void checkUpdate() {

    final hasTagChanged = !(selectedTags.length == widget.model.tags.length &&
        selectedTags.containsAll(widget.model.tags));

    bool hasChanged = _contentController.text != widget.model.content ||
        selectedMood != widget.model.mood ||
        hasTagChanged;

    if (hasChanged != isUpdated) {
      setState(() {
        isUpdated = hasChanged;
      });
    }
  }


  @override
  void initState() {

    _contentController.text = widget.model.content;
    selectedTags = widget.model.tags.toSet();
    selectedMood = widget.model.mood;
    selectedDate = widget.model.date;
    selectedTime = widget.model.time;

    _contentController.addListener(checkUpdate);

    super.initState();
  }

  @override
  void dispose() {
    _contentController.removeListener(checkUpdate);
    _tagsController.removeListener(checkUpdate);
    super.dispose();
  }

  Future<void> editJournal()async{
    final journal = JournalModel(
        id: widget.model.id,
        uid: widget.model.uid,
        date: selectedDate,
        time: selectedTime,
        mood: selectedMood,
        content: _contentController.text,
        tags: selectedTags.toList()
    );
    await context.read<DataProvider>().updateJournal(journal);
  }

  DateTime get combinedDateTime {
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
  }


  Widget _buildText(String tag,BuildContext context){
    return Text(tag,style: Theme.of(context).textTheme.titleSmall,);
  }

  Widget _buildMood(String mood, IconData icon){
    Color color;
    switch(mood){
      case 'Very happy' :
        color = Colors.cyan;
        break;
      case 'Happy' :
        color = Colors.green;
        break;
      case 'Neutral' :
        color = Colors.yellow.shade800;
        break;
      case 'Sad' :
        color = Color(0xFFFF6F61);
        break;
      case 'Depressed' :
        color = Color(0xFF39546d);
        break;
      default :
        color = Colors.grey.shade300;
    }
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            setState(() {
              selectedMood = mood;
              checkUpdate();
            });
          },
          child: CircleAvatar(
            radius: 25,
            backgroundColor: selectedMood == mood ? color : Colors.grey.shade300,
            child: Icon(icon,color: selectedMood==mood? Colors.white : Colors.black,),
          ),
        ),
        SizedBox(height: 10.h,),
        if(selectedMood==mood)
        _buildText(mood, context)
      ],
    );
  }

  Future<void> pickDateAndTime()async{
    DateTime? pickedDate = await showDatePicker(
        context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),

    );
    if(pickedDate!=null && pickedDate!=selectedDate){
      setState(() {
        selectedDate = pickedDate;
        checkUpdate();
      });
    }
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial
    );

    if(pickedTime!=null && pickedTime!=selectedTime){
      setState(() {
        selectedTime = pickedTime;
        checkUpdate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final prefs = context.read<PreferencesProvider>();
    return Scaffold(
     appBar: AppBar(
       title: Text('Edit mood journal',style: theme.textTheme.headlineMedium,),
       iconTheme: theme.iconTheme,
       backgroundColor: Colors.transparent,
       systemOverlayStyle: SystemUiOverlayStyle(
           statusBarBrightness: context.watch<ThemeProvider>().currentTheme==ThemeMode.dark? Brightness.light:Brightness.light
       ),
     ),
      body: Form(
        key: _key,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w,),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h,),
                Container(
                  width: double.infinity.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h,),
                      Text('Date : ${DateFormat('d/M/y, h:mm a').format(combinedDateTime)}',style: theme.textTheme.titleMedium,),
                      TextButton(
                        onPressed : pickDateAndTime,
                          child: Text('Edit existing date and time',style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),)
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h,),
                Container(
                  width: double.infinity.w,
                  height: 160.h,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h,),
                      Text('Select your mood',style: theme.textTheme.titleMedium,),
                      SizedBox(height: 15.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                         _buildMood('Very happy', Icons.sentiment_very_satisfied_sharp),
                          _buildMood("Happy", Icons.sentiment_satisfied_sharp,),
                          _buildMood("Neutral", Icons.sentiment_neutral,),
                          _buildMood("Sad", Icons.sentiment_dissatisfied),
                          _buildMood('Depressed', Icons.sentiment_very_dissatisfied)
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h,),
                TextFormField(
                  controller: _contentController,
                  maxLines: 5,
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return 'Please write updates about your mood';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintFadeDuration: Duration(seconds: 5),
                    hintText: 'write an update',
                    hintStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.grey,fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 20.h,),
                Text('Update tags',style:theme.textTheme.titleMedium,),
                SizedBox(height: 20.h,),
                Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    ...{...defaultTags, ...prefs.customTags}.map((tag) {
                      final isSelected = selectedTags.contains(tag);
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: ChoiceChip(
                          label: Text(
                            tag,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isSelected ? Colors.white : theme.colorScheme.primary,
                            ),
                          ),
                          selected: isSelected,
                          side: BorderSide(color: theme.colorScheme.primary),
                          backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                          selectedColor: theme.colorScheme.primary,
                          checkmarkColor: Colors.white,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedTags.add(tag);
                              } else {
                                selectedTags.remove(tag);
                              }
                              checkUpdate();
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),

                SizedBox(height: 20.h,),
                isUpdated?
                ElevatedButton(
                    onPressed: ()async{
                      if(_key.currentState!.validate()){
                        await editJournal();
                        Navigator.pop(context);
                        ToastMsg.successToast('Journal updated successfully');
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
                    child: context.watch<DataProvider>().isLoading?AppLoader.lightThemeLoader():Text('Save changes',style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500,color: Colors.white),)
                ):ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        elevation: 0,
                        minimumSize: Size(double.infinity.w, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        )
                    ),
                    child: Text('Save changes',style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500,color: Colors.grey),)
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
