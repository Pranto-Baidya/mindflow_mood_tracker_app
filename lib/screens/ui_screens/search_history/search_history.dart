import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/preferences_provider/preferences_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/animated_container/animated_container_widget.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../provider/theme_provider/theme_provider.dart';

class SearchHistory extends StatefulWidget {
  const SearchHistory({super.key});

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {

  void clearAllHistoryDialogue(BuildContext context){
    var theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clear_history_title, style: theme.textTheme.titleLarge,),
        content: Text(
          AppLocalizations.of(context)!.clear_history_description,
          style: theme.textTheme.titleMedium,
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: Text(
              AppLocalizations.of(context)!.cancel_button,
              style: theme.textTheme.titleSmall
                  ?.copyWith(
                color: theme
                    .colorScheme
                    .primary,
              ),
            ),
          ),
          TextButton(
            onPressed: ()async{
              await context.read<PreferencesProvider>().clearAllHistory();
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.confirm_button,
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDark = context.watch<ThemeProvider>().currentTheme == ThemeMode.dark;
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.search_history_title, style: theme.textTheme.headlineMedium),
          iconTheme: theme.iconTheme,
          backgroundColor: Colors.transparent,

          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: context.read<PreferencesProvider>().historyList.isEmpty?
              Icon(Icons.delete_forever,color: Colors.red,size: 30.sp,)
                  :IconButton(
                  onPressed: (){
                    clearAllHistoryDialogue(context);
                  },
                  icon: Icon(Icons.delete_forever,color: Colors.red,size: 30.sp,)
              ),
            )
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 10.h,),
            Expanded(
              child: Consumer<PreferencesProvider>(
                  builder: (context,hist,_){
                    return hist.historyList.isEmpty? Center(child: Text(AppLocalizations.of(context)!.no_history_message,style: theme.textTheme.titleMedium,),)
                        :ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: hist.historyList.length,
                        itemBuilder: (context,index){
                          final data = hist.historyList[index];
                          return AnimatedMoodContainerWidget(
                            index: index,
                            offset: Offset(0,0.2),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 2.h),
                              child: Card(
                                color: theme.cardColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                                child: ListTile(
                                  tileColor: Colors.transparent,
                                  contentPadding: EdgeInsets.all(10),
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: theme.colorScheme.primary,
                                    child: Text((index+1).toString().padLeft(2,'0'),style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),),
                                  ),
                                  title: Text("${AppLocalizations.of(context)!.youSearchedFor} '$data'",style: theme.textTheme.titleMedium,),
                                  trailing: IconButton(
                                      onPressed: ()async{
                                        await hist.removeSpecificHistory(index);
                                      },
                                      icon: Icon(Icons.delete,color: Colors.red,)
                                  ),

                                ),
                              ),
                            ),
                          );
                        }
                    );

                  }
              ),
            ),
          ],
        )
    );
  }
}