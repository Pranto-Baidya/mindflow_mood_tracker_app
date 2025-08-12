import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/auth_provider/auth_provider.dart' show AuthProvider;
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_colors/app_colors.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_loader/app_loader.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_toastMsg/app_toastMsg.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/status_bar_color/status%20bar%20color.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {

  @override
  void initState() {
    _emailController.addListener(checkTyping);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    StatusBarColor.apply(context);
    super.didChangeDependencies();
  }

  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  bool isTyping = false;

  void checkTyping(){
    bool hasChanged = _emailController.text.isNotEmpty;
    if(hasChanged!=isTyping){
      setState(() {
        isTyping = hasChanged;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final auth = Provider.of<AuthProvider>(context,listen: false);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Form(
          key: _key,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100.h,),
                  Text(AppLocalizations.of(context)!.forgot_password,style: theme.textTheme.displaySmall,),
                  SizedBox(height: 20.h,),
                  Text(AppLocalizations.of(context)!.reset_password_description,style: theme.textTheme.titleMedium,),
                  SizedBox(height: 40.h,),
                  TextFormField(
                    controller: _emailController,
                    cursorColor: theme.primaryColor,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.email_empty_error;
                      }
                      if(!value.contains('@') || !value.contains('.com')){
                        return AppLocalizations.of(context)!.email_invalid_error;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.email_hint,
                      hintStyle: theme.textTheme.titleMedium,
                      prefixIcon: Icon(Icons.email_outlined,color: theme.iconTheme.color,),
                    ),
                  ),
                  SizedBox(height: 20.h,),
                  isTyping? ElevatedButton(
                      onPressed: ()async{
                        if(_key.currentState!.validate()){
                          bool success = await auth.resetPassword(_emailController.text);
                          if(success){
                            Navigator.pop(context);
                            ToastMsg.successToast(AppLocalizations.of(context)!.password_reset_success_toast);
                          }
                          else{
                            ToastMsg.errorToast(auth.errorMsg!);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: theme.colorScheme.primary,
                          minimumSize: Size(double.infinity.w, 50.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r))
                      ),
                      child: context.watch<AuthProvider>().isLoading?AppLoader.lightThemeLoader():Text(AppLocalizations.of(context)!.send_link_button,style: theme.textTheme.titleLarge?.copyWith(color: Colors.white,fontWeight: FontWeight.w500),)
                  ): ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize: Size(double.infinity.w, 50.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r))
                      ),
                      child: Text(AppLocalizations.of(context)!.send_link_button,style: theme.textTheme.titleLarge?.copyWith(color: Colors.grey,fontWeight: FontWeight.w500),)
                  ),
                  SizedBox(height: 20.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)!.remember_password_prompt, style: theme.textTheme.titleSmall,),
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text(AppLocalizations.of(context)!.sign_in_button,style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary,fontWeight: FontWeight.bold),)
                      )
                    ],
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}