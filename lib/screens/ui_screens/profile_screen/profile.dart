import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/locale_provider/locale_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/preferences_provider/preferences_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/provider/theme_provider/theme_provider.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/auth_screens/sign_in_sign_up/sign_in_sign_up.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/screens/ui_screens/reminder_screen/reminder_screen.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_loader/app_loader.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/app_toastMsg/app_toastMsg.dart';
import 'package:mindflow_mood_tracker_app_with_firebase/widgets/custom_listile/custom_listTile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../l10n/app_localizations.dart';
import '../../../notification_service/local_notification.dart';
import '../../../provider/auth_provider/auth_provider.dart';
import '../../../provider/local_auth_provider/local_auth_provider.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final TextEditingController _bioController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPassController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  final GlobalKey<FormState> _updatePassKey =  GlobalKey<FormState>();
  final GlobalKey<FormState> _deletePassKey =  GlobalKey<FormState>();
  final GlobalKey<FormState> _pinLockKey = GlobalKey<FormState>();


  bool isAddingBio = false;

  bool isLocalAuthEnabled = false;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    user?.reload().then((_){ //manually signup korle user er nam show hobe
      setState(() {

      });
    });
  }

  bool isGoogleUser(User? user){
    return user?.providerData.any((info)=>info.providerId=='google.com') ?? false;
  }

  @override
  void didChangeDependencies() {
    _bioController.text = context.watch<PreferencesProvider>().bio??'';
    super.didChangeDependencies();
  }

  Future<void> changePasswordForGoogleUser()async{
    Uri url = Uri.parse('https://myaccount.google.com/security');
    if(await canLaunchUrl(url)){
      await launchUrl(url);
    }
    else{
      throw Exception('Failed to redirect');
    }
  }

  void changeTheme(BuildContext context){
    var theme = Theme.of(context);
    final themeProvider = context.read<ThemeProvider>();
    AppThemeMode selected = themeProvider.mode;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.change_theme_title,style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...AppThemeMode.values.map((mode){
                    return RadioListTile(
                      tileColor: Colors.transparent,
                      title: mode==AppThemeMode.light?
                      Text(AppLocalizations.of(context)!.light_mode,style: theme.textTheme.titleMedium,)
                          :mode==AppThemeMode.dark?Text(AppLocalizations.of(context)!.dark_mode,style: theme.textTheme.titleMedium,)
                          :Text(AppLocalizations.of(context)!.system_default,style: theme.textTheme.titleMedium,),
                      value: mode,
                      groupValue: selected,
                      onChanged: (value){
                        themeProvider.setTheme(mode);
                        Navigator.pop(context);
                      },
                    );
                  })
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel_button,style: theme.textTheme.titleMedium?.copyWith(color: Colors.red),)
              )
            ],
          );
        }
    );
  }


  void enableLocalAuthAlert(BuildContext context){
    var theme = Theme.of(context);
    final provider = context.read<LocalAuthProvider>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.set_pin_title,style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),),
            content: Form(
              key: _pinLockKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _pinController,
                      cursorColor: theme.colorScheme.primary,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.pin_empty_error;
                        }
                        if (value.length != 4) {
                          return AppLocalizations.of(context)!.pin_length_error;
                        }
                        return null;
                      },

                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.pin_hint,
                          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    ElevatedButton(
                        onPressed: ()async{
                          if(_pinLockKey.currentState!.validate()){
                            await provider.savePin(_pinController.text);
                            await context.read<PreferencesProvider>().toggleLocalAuth(true);
                            ToastMsg.successToast(AppLocalizations.of(context)!.pin_lock_enabled_toast);
                            Navigator.pop(context);
                            _pinController.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: theme.colorScheme.primary,
                          minimumSize: Size(double.infinity.w, 50.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r)
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.set_pin_button, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white,fontWeight: FontWeight.w500),)
                    )
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel_button,style: theme.textTheme.titleMedium?.copyWith(color: Colors.red),)
              )
            ],
          );
        }
    );
  }

  void updatePassAlert(BuildContext context){
    var theme = Theme.of(context);
    final auth = context.read<AuthProvider>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.update_password_title,style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),),
            content: Form(
              key: _updatePassKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context)!.update_password_description,style: theme.textTheme.titleMedium,),
                    SizedBox(height: 20.h,),
                    TextFormField(
                      controller: _emailController,
                      validator: (value){
                        if(value!.isEmpty){
                          return AppLocalizations.of(context)!.email_empty_error;
                        }
                        if(!value.contains('@') || !value.contains('.com')){
                          return AppLocalizations.of(context)!.email_invalid_error;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.email_hint,
                          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    TextFormField(
                      controller: _currentPassController,
                      obscureText: true,
                      validator: (value){
                        if(value!.isEmpty){
                          return AppLocalizations.of(context)!.current_password_empty_error;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.current_password_hint,
                          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    TextFormField(
                      controller: _newPassController,
                      obscureText: true,
                      validator: (value){
                        if(value!.isEmpty){
                          return AppLocalizations.of(context)!.new_password_empty_error;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.new_password_hint,
                          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    ElevatedButton(
                        onPressed: ()async{
                          if(_updatePassKey.currentState!.validate()){
                            bool success = await auth.reauthenticateAndChangePassword(
                                email: _emailController.text.trim(),
                                currentPassword: _currentPassController.text.trim(),
                                newPassword: _newPassController.text.trim()
                            );
                            if(success){
                              ToastMsg.successToast(AppLocalizations.of(context)!.password_updated_toast);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInSignUp()));
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: context.watch<AuthProvider>().isLoading?AppLoader.lightThemeLoader():Text(AppLocalizations.of(context)!.update_password_title,style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500,color: Colors.white),)
                    )
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel_button,style: theme.textTheme.titleMedium?.copyWith(color: Colors.red),)
              )
            ],
          );
        }
    );
  }

  void deleteAccountAlert(BuildContext context){
    var theme = Theme.of(context);
    final auth = context.read<AuthProvider>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.delete_account_title,style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500,color: Colors.red),),
            content: Form(
              key: _deletePassKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context)!.delete_account_description,style: theme.textTheme.titleMedium,),
                    SizedBox(height: 20.h,),
                    TextFormField(
                      controller: _emailController,
                      validator: (value){
                        if(value!.isEmpty){
                          return AppLocalizations.of(context)!.email_empty_error;
                        }
                        if(!value.contains('@') || !value.contains('.com')){
                          return AppLocalizations.of(context)!.email_invalid_error;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.email_hint,
                          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    TextFormField(
                      controller: _currentPassController,
                      obscureText: true,
                      validator: (value){
                        if(value!.isEmpty){
                          return AppLocalizations.of(context)!.current_password_empty_error;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.current_password_hint,
                          hintStyle: theme.textTheme.titleSmall?.copyWith(color: Colors.grey)
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    ElevatedButton(
                        onPressed: ()async{
                          if(_deletePassKey.currentState!.validate()){
                            bool success = await auth.reauthenticateAndDeleteAccount(
                              email: _emailController.text.trim(),
                              password: _currentPassController.text.trim(),
                            );
                            if(success){
                              ToastMsg.successToast(AppLocalizations.of(context)!.account_deletion_toast);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInSignUp()));
                            }
                            else{
                              ToastMsg.errorToast(auth.errorMsg!);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.red,
                          minimumSize: Size(double.infinity.w, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: context.watch<AuthProvider>().isLoading?AppLoader.lightThemeLoader():Text(AppLocalizations.of(context)!.delete_account_title,style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500,color: Colors.white),)
                    )
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel_button,style: theme.textTheme.titleMedium?.copyWith(color: Colors.red),)
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    final prefs = context.watch<PreferencesProvider>();
    bool isDark = context.watch<ThemeProvider>().currentTheme == ThemeMode.dark;
    final locale = context.read<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.user_profile_title, style: theme.textTheme.headlineMedium),
        iconTheme: theme.iconTheme,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            user?.photoURL != null
                ? CircleAvatar(
              radius: 50.r,
              backgroundImage: NetworkImage(user?.photoURL ?? ''),
            )
                :
            CircleAvatar(
              radius: 50.r,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              child: Icon(Icons.person, color: theme.colorScheme.primary, size: 60),
            ),

            SizedBox(height: 20.h),
            Text(
              user?.displayName ?? '',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAddingBio)
                    Row(
                      children: [
                        SizedBox(
                          width: 180.w,
                          child: TextField(
                            controller: _bioController,
                            cursorColor: theme.colorScheme.primary,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.add_bio_hint,
                              hintStyle: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final newBio = _bioController.text.trim();
                            if (newBio.isNotEmpty) {
                              await prefs.saveUserBio(newBio);
                            }
                            setState(() {
                              isAddingBio = false;
                            });
                          },
                          child: Text(AppLocalizations.of(context)!.save_button, style: TextStyle(fontSize: 15, color: theme.colorScheme.primary)),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isAddingBio = false;
                            });
                          },
                          child: Text(AppLocalizations.of(context)!.cancel_button, style: TextStyle(fontSize: 15, color: Colors.red)),
                        ),
                      ],
                    )
                  else if (prefs.bio != null && prefs.bio!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(prefs.bio!, style: theme.textTheme.titleMedium),
                    )
                  else
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isAddingBio = true;
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!.write_bio_prompt,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500,color: Colors.grey),
                      ),
                    ),

                  if (!isAddingBio)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isAddingBio = true;
                        });
                      },
                      icon: Icon(Icons.edit, color: theme.colorScheme.primary),
                    ),

                  if (prefs.bio != null && prefs.bio!.isNotEmpty && !isAddingBio)
                    IconButton(
                      onPressed: () async {
                        await prefs.clearUserBio();
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                ],
              ),
            ),

            SizedBox(height: 10.h,),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(AppLocalizations.of(context)!.personalisation_section,style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            CustomListTile(
                title: AppLocalizations.of(context)!.change_theme_title,
                leadingIcon: isDark?Icons.dark_mode: context.watch<ThemeProvider>().currentTheme==ThemeMode.system?Icons.android:Icons.light_mode,
                onTap: (){
                  changeTheme(context);
                }
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Card(
                elevation: 0,
                color: theme.cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                    tileColor: Colors.transparent,
                    contentPadding: EdgeInsetsGeometry.all(10),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Icon(Icons.language,color: theme.iconTheme.color,),
                    ),
                    title: Text(AppLocalizations.of(context)!.change_language_title,style: theme.textTheme.titleMedium,),
                    trailing: DropdownButton(
                      dropdownColor: theme.dropdownMenuTheme.menuStyle?.backgroundColor?.resolve(({})),
                      value: context.watch<LocaleProvider>().locale,
                      items: [
                        DropdownMenuItem(
                            value: Locale('en'),
                            child: Text('English', style: theme.textTheme.titleMedium)),
                        DropdownMenuItem(
                            value: Locale('bn'),
                            child: Text('বাংলা', style: theme.textTheme.titleMedium)),
                      ],
                      onChanged: (Locale? loc) {
                        if (loc != null) {
                          locale.setLocale(loc);
                        }
                      },
                    )
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Card(
                elevation: 0,
                color: theme.cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                    tileColor: Colors.transparent,
                    contentPadding: EdgeInsetsGeometry.all(10),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Icon(Icons.notifications_sharp,color: theme.iconTheme.color,),
                    ),
                    title: Text(AppLocalizations.of(context)!.allow_notifications,style: theme.textTheme.titleMedium,),
                    trailing: Switch(
                      value: context.watch<PreferencesProvider>().isNotificationEnabled,
                      onChanged: (value) async {
                        context.read<PreferencesProvider>().setNotification(value);
                        if (value) {
                          await NotificationService.showImmediateNotification();
                          await NotificationService.showNotificationAt();
                        }
                        else {
                          await NotificationService.cancelNotifications();
                        }
                      },
                    ),

                ),
              ),
            ),
            SizedBox(height: 10.h,),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(AppLocalizations.of(context)!.reminder,style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            CustomListTile(
                title: AppLocalizations.of(context)!.schedule_reminder,
                leadingIcon: Icons.alarm,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ReminderScreen()));
                }
            ),
            SizedBox(height: 10.h,),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(AppLocalizations.of(context)!.security_section,style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: Card(
                elevation: 0,
                color: theme.cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                    tileColor: Colors.transparent,
                    contentPadding: EdgeInsetsGeometry.all(10),
                    leading: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Icon(Icons.lock,color: theme.iconTheme.color,),
                    ),
                    title: Text(AppLocalizations.of(context)!.enable_biometric_pin_lock,style: theme.textTheme.titleMedium,),
                    trailing: Switch(
                        value: prefs.isAuthEnabled,
                        onChanged: (value)async{
                          final localAuth = context.read<LocalAuthProvider>();
                          if(value){
                            if (!localAuth.isPinSet) {
                              enableLocalAuthAlert(context);
                            }
                            else{
                              await context.read<PreferencesProvider>().toggleLocalAuth(true);
                            }
                          }
                          else{
                            await context.read<PreferencesProvider>().toggleLocalAuth(false);
                            await localAuth.deletePin();
                          }
                        }
                    )
                ),
              ),
            ),
            SizedBox(height: 10.h,),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(AppLocalizations.of(context)!.account_section,style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.w),
              child: GestureDetector(
                onTap: ()async{
                  await context.read<AuthProvider>().signOut();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>SignInSignUp()),(Route<dynamic>route)=>false,);
                },
                child: Card(
                  elevation: 0,
                  color: theme.cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                      tileColor: Colors.transparent,
                      contentPadding: EdgeInsetsGeometry.all(10),
                      leading: Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Icon(Icons.logout,color: theme.iconTheme.color,),
                      ),
                      title: Text(AppLocalizations.of(context)!.sign_out_title,style: theme.textTheme.titleMedium,),
                      trailing: context.watch<AuthProvider>().isLoading?Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: isDark?AppLoader.darkThemeLoaderPrimarySmall():AppLoader.lightThemeLoaderPrimarySmall(),
                      ):Icon(Icons.arrow_forward_ios_outlined,color: theme.iconTheme.color,)
                  ),
                ),
              ),
            ),
            CustomListTile(
                title: AppLocalizations.of(context)!.change_password_title,
                leadingIcon: Icons.password,
                onTap: ()async{
                  if(isGoogleUser(user)){
                    await changePasswordForGoogleUser();
                  }
                  else {
                    updatePassAlert(context);
                  }
                }
            ),
            CustomListTile(
                title: AppLocalizations.of(context)!.delete_account_title,
                leadingIcon: Icons.delete_forever,
                iconColor: Colors.red,
                onTap: (){
                  deleteAccountAlert(context);
                }
            ),
          ],
        ),
      ),
    );
  }
}