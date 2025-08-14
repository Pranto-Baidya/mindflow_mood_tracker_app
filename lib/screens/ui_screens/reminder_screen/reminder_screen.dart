import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/notification_service/local_notification.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/theme_provider/theme_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_colors/app_colors.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_toastMsg/app_toastMsg.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool isTyping = false;
  bool isDateTimeSelected = false;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    _titleController.addListener(checkTyping);
    _descriptionController.addListener(checkTyping);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.removeListener(checkTyping);
    _descriptionController.removeListener(checkTyping);
    super.dispose();
  }

  void checkTyping(){
    bool hasContent = _titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty && selectedTime!=null && selectedDate!=null;
    if(hasContent!=isTyping){
      setState(() {
        isTyping = hasContent;
      });
    }
  }

  void pickDate()async{
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100)
    );
    if(pickedDate!=null){
      setState(() {
        selectedDate = pickedDate;
      });
      checkTyping();
      checkDateTime();
    }
  }

  void pickTime()async{
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.dial,
        initialTime: TimeOfDay.now()
    );
    if(pickedTime!=null){
      setState(() {
        selectedTime = pickedTime;
      });
      checkTyping();
      checkDateTime();
    }
  }

  DateTime? get combinedDateTime {
    if (selectedDate != null && selectedTime != null) {
      return DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
    }
    return null;
  }

  void checkDateTime(){
    if(selectedDate!=null && selectedTime!=null){
      setState(() {
        isDateTimeSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDark = context.watch<ThemeProvider>().currentTheme==ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.add_new_reminder_title,style: theme.textTheme.headlineMedium,),
        iconTheme: theme.iconTheme,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h,),
              Text(AppLocalizations.of(context)!.set_up_reminder_label,style: theme.textTheme.headlineSmall,),
              SizedBox(height: 20.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 250.w,
                    height: 50.h,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _idController,
                      cursorColor: theme.colorScheme.primary,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.numbers,color: theme.iconTheme.color,),
                        hintText: AppLocalizations.of(context)!.enter_reminder_id_hint,
                        hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: AppLocalizations.of(context)!.unique_id_warning,
                    textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                    margin: EdgeInsets.only(right: 30.w,left: 30.w),
                    padding: EdgeInsets.all(10),
                    preferBelow: false,
                    decoration: BoxDecoration(
                      color: isDark ? MoodTrackerColors.darkError
                          : MoodTrackerColors.lightError,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.info_outline, color: theme.iconTheme.color),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.h,),
              TextFormField(
                controller: _titleController,
                cursorColor: theme.colorScheme.primary,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.title,color: theme.iconTheme.color,),
                  hintText: AppLocalizations.of(context)!.write_title_hint,
                  hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20.h,),
              TextFormField(
                controller: _descriptionController,
                cursorColor: theme.colorScheme.primary,
                maxLines: 3,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description,color: theme.iconTheme.color,),
                  hintText: AppLocalizations.of(context)!.write_description_hint,
                  hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20.h,),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.select_date_time_label,style: theme.textTheme.titleMedium,),
                  IconButton(
                      onPressed: (){
                        pickDate();
                      },
                      icon: Icon(Icons.date_range)
                  ),
                  IconButton(
                      onPressed: (){
                        pickTime();
                      },
                      icon: Icon(Icons.access_time)
                  ),
                ],
              ),
              SizedBox(height: 10.h,),
              if(isDateTimeSelected)
                ...[
                  Row(
                    children: [
                      Text(AppLocalizations.of(context)!.date_time_set_label,style: theme.textTheme.titleMedium,),
                      if(combinedDateTime!=null)
                        Expanded(
                          child: Wrap(
                            children: [
                              Text(DateFormat('d/M/y, h:mm a').format(combinedDateTime!))
                             ]
                          ),
                        )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 18.w),
                        child: TextButton(
                            onPressed: (){
                              pickTime();
                              pickDate();
                            },
                            child: Text(AppLocalizations.of(context)!.change_date_time_button,style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),)
                        ),
                      )
                    ],
                  ),
                ],
              SizedBox(height: 20.h,),
              ElevatedButton(
                  onPressed: isTyping?()async{
                    await NotificationService.setReminderNotification(
                        id: int.parse(_idController.text),
                        title: _titleController.text,
                        description: _descriptionController.text,
                        date: selectedDate!,
                        time: selectedTime!
                    );
                    ToastMsg.successToast(AppLocalizations.of(context)!.reminder_scheduled_toast);
                    Navigator.pop(context);
                  }:null,
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity.w, 50.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                      backgroundColor: theme.colorScheme.primary
                  ),
                  child: isTyping?Text(AppLocalizations.of(context)!.set_reminder_button,style: theme.textTheme.titleLarge?.copyWith(color: Colors.white,fontWeight: FontWeight.w500),)
                      :Text(AppLocalizations.of(context)!.schedule_reminder_button,style: theme.textTheme.titleLarge?.copyWith(color: Colors.grey,fontWeight: FontWeight.w500),)
              )
            ],
          ),
        ),
      ),
    );
  }
}