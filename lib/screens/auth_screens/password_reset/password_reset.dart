

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/auth_provider/auth_provider.dart' show AuthProvider;
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_colors/app_colors.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_loader/app_loader.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_toastMsg/app_toastMsg.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/status_bar_color/status%20bar%20color.dart';
import 'package:provider/provider.dart';

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
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 70.h,),
                Text('Forgot password?',style: theme.textTheme.displaySmall,),
                SizedBox(height: 20.h,),
                Text('Enter your email address and we will send you a link to reset your password',style: theme.textTheme.titleMedium,),
                SizedBox(height: 40.h,),
                TextFormField(
                  controller: _emailController,
                  cursorColor: theme.primaryColor,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if(!value.contains('@') || !value.contains('.com')){
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
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
                         ToastMsg.successToast('Password reset link sent successfully, check your email');
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
                    child: context.watch<AuthProvider>().isLoading?AppLoader.lightThemeLoader():Text('Send link',style: theme.textTheme.titleLarge?.copyWith(color: Colors.white,fontWeight: FontWeight.w500),)
                ): ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        minimumSize: Size(double.infinity.w, 50.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r))
                    ),
                    child: Text('Send link',style: theme.textTheme.titleLarge?.copyWith(color: Colors.grey,fontWeight: FontWeight.w500),)
                ),
                SizedBox(height: 20.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Remember password?', style: theme.textTheme.titleSmall,),
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('Sign In',style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary,fontWeight: FontWeight.bold),)

                    )
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}
