import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/local_auth_provider/local_auth_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/ui_screens/home/all_mood_journal_screen.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/animated_container/animated_container_widget.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_toastMsg/app_toastMsg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../provider/theme_provider/theme_provider.dart';

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final TextEditingController _pinController = TextEditingController();

  bool showUnlockRow = false;

  @override
  void initState() {
    _pinController.addListener(checkTextField);
    super.initState();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinController.removeListener(checkTextField);
    super.dispose();
  }

  void checkTextField(){
    bool show = _pinController.text.isNotEmpty;
    if(showUnlockRow!=show){
      setState(() {
        showUnlockRow = show;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final provider = context.watch<LocalAuthProvider>();
    final auth = context.read<LocalAuthProvider>();
    bool isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: isDark? Brightness.light : Brightness.dark,
          statusBarColor: Colors.transparent,
          systemNavigationBarColor:
          context.watch<ThemeProvider>().currentTheme == ThemeMode.dark
              ? const Color(0xFF1C2526)
              : const Color(0xFFF5F7FA),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.enter_pin_title, style: theme.textTheme.headlineSmall),
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _pinController,
                  obscureText: true,
                  cursorColor: theme.colorScheme.primary,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.transparent,
                    inactiveFillColor: Colors.transparent,
                    selectedColor: theme.colorScheme.primary,
                    selectedFillColor: Colors.white,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                ),
              ),
              if (provider.errorMsg.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Text(
                    provider.errorMsg,
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.red),
                  ),
                ),
              SizedBox(height: 30.h),
              showUnlockRow?
              AnimatedMoodContainerWidget(
                index: 1,
                offset: Offset(0.2, 0),
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.unlock_button,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                        child: IconButton(
                          onPressed: () async {
                            final inputPin = _pinController.text.trim();

                            if (inputPin.length != 4) {
                              ToastMsg.errorToast(AppLocalizations.of(context)!.invalid_pin_error);
                              return;
                            }

                            await provider.verifyPin(inputPin);

                            if (provider.isAuthenticated) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const AllMoodJournals()),
                              );
                            }
                          },
                          icon: Icon(Icons.arrow_forward, color: theme.colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ):SizedBox(),
              SizedBox(height: 50.h,),
              TextButton(
                  onPressed: ()async{
                    await auth.authenticateUser();
                    if(auth.isAuthenticated){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AllMoodJournals()));
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.use_fingerprint_prompt,style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary,fontWeight: FontWeight.w500),)
              )
            ],
          ),
        ),
      ),
    );
  }
}